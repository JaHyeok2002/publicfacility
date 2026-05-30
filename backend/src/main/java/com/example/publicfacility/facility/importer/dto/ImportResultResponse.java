package com.example.publicfacility.facility.importer.dto;

public record ImportResultResponse(
        String category,
        int saved,
        int updated,
        int skipped,
        String message
) {
}
