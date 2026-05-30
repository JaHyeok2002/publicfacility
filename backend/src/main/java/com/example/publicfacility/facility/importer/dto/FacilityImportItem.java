package com.example.publicfacility.facility.importer.dto;

import com.example.publicfacility.facility.domain.FacilityCategory;

public record FacilityImportItem(
        String name,
        FacilityCategory category,
        String address,
        Double latitude,
        Double longitude,
        String openTime,
        String phone,
        String amenities
) {
}
