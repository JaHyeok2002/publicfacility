package com.example.publicfacility.facility.dto;

import java.util.List;

public record FacilityResponse(
        Long id,
        String name,
        String category,
        String categoryName,
        String address,
        Double latitude,
        Double longitude,
        Long distance,
        String openTime,
        String phone,
        List<String> amenities,
        boolean favorite
) {
}
