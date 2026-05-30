package com.example.publicfacility.facility.domain;

import lombok.Getter;

@Getter
public enum FacilityCategory {
    TOILET("공공화장실"),
    SHELTER("무더위쉼터"),
    WIFI("공공와이파이");

    private final String label;

    FacilityCategory(String label) {
        this.label = label;
    }
}
