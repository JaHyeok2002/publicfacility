package com.example.publicfacility.facility.importer.dto;

public record ImportStats(int saved, int updated, int skipped) {
    public ImportStats plus(ImportStats other) {
        return new ImportStats(
                this.saved + other.saved,
                this.updated + other.updated,
                this.skipped + other.skipped
        );
    }
}
