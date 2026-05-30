package com.example.publicfacility.favorite.dto;

import com.example.publicfacility.facility.domain.FacilityCategory;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record FavoriteCreateRequest(
        @NotNull Long facilityId,
        String name,
        FacilityCategory category,
        String address,
        Double latitude,
        Double longitude,
        String openTime,
        String phone,
        List<String> amenities
) {
}
