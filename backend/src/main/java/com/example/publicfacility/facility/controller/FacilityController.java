package com.example.publicfacility.facility.controller;

import com.example.publicfacility.facility.domain.FacilityCategory;
import com.example.publicfacility.facility.dto.FacilityResponse;
import com.example.publicfacility.facility.service.FacilityService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/facilities")
@RequiredArgsConstructor
public class FacilityController {
    private final FacilityService facilityService;

    @GetMapping
    public List<FacilityResponse> list(
            @RequestParam(required = false) FacilityCategory category,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng
    ) {
        return facilityService.list(category, keyword, sort, lat, lng);
    }

    @GetMapping("/{facilityId}")
    public FacilityResponse detail(
            @PathVariable Long facilityId,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng
    ) {
        return facilityService.detail(facilityId, lat, lng);
    }

    @GetMapping("/nearby")
    public List<FacilityResponse> nearby(
            @RequestParam Double lat,
            @RequestParam Double lng,
            @RequestParam(required = false) FacilityCategory category
    ) {
        return facilityService.nearby(lat, lng, category);
    }
}
