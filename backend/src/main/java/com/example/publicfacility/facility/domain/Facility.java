package com.example.publicfacility.facility.domain;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Table(uniqueConstraints = {
        @UniqueConstraint(columnNames = {"name", "address", "category"})
})
public class Facility {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private FacilityCategory category;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private Double latitude;

    @Column(nullable = false)
    private Double longitude;

    @Column(nullable = false)
    private String openTime;

    @Column(nullable = false)
    private String phone;

    @Column(nullable = false, length = 1000)
    private String amenities;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    public void updateFromImport(Double latitude, Double longitude, String openTime, String phone, String amenities) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.openTime = openTime;
        this.phone = phone;
        this.amenities = amenities;
    }
}
