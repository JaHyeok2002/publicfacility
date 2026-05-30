package com.example.publicfacility.favorite.controller;

import com.example.publicfacility.facility.dto.FacilityResponse;
import com.example.publicfacility.favorite.dto.FavoriteCreateRequest;
import com.example.publicfacility.favorite.service.FavoriteService;
import com.example.publicfacility.global.response.MessageResponse;
import com.example.publicfacility.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {
    private final FavoriteService favoriteService;
    private final UserService userService;

    @GetMapping
    public List<FacilityResponse> list(
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng
    ) {
        return favoriteService.myFavorites(userService.requireCurrentUserId(), lat, lng);
    }

    @PostMapping
    public MessageResponse addBody(@Valid @RequestBody FavoriteCreateRequest request) {
        favoriteService.addFromBody(userService.requireCurrentUserId(), request);
        return new MessageResponse("즐겨찾기에 추가되었습니다.");
    }

    @PostMapping("/{facilityId}")
    public MessageResponse add(@PathVariable Long facilityId) {
        favoriteService.addByFacilityId(userService.requireCurrentUserId(), facilityId);
        return new MessageResponse("즐겨찾기에 추가되었습니다.");
    }

    @DeleteMapping("/{facilityId}")
    public MessageResponse remove(@PathVariable Long facilityId) {
        favoriteService.remove(userService.requireCurrentUserId(), facilityId);
        return new MessageResponse("즐겨찾기에서 삭제되었습니다.");
    }
}
