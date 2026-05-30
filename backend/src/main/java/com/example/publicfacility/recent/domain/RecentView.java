package com.example.publicfacility.recent.domain;

import com.example.publicfacility.facility.domain.FacilityCategory;
import com.example.publicfacility.user.domain.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@Table(uniqueConstraints = {
        @UniqueConstraint(columnNames = {"user_id", "facility_id"})
})
public class RecentView {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    private User user;

    @Column(name = "facility_id", nullable = false)
    private Long facilityId;

    @Column(nullable = false)
    private String facilityName;

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

    @Column(nullable = false, length = 2000)
    private String amenitiesSnapshot;

    @Column(nullable = false)
    private LocalDateTime viewedAt;

    public void updateSnapshot(
            String facilityName,
            FacilityCategory category,
            String address,
            Double latitude,
            Double longitude,
            String openTime,
            String phone,
            String amenitiesSnapshot,
            LocalDateTime viewedAt
    ) {
        this.facilityName = facilityName;
        this.category = category;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.openTime = openTime;
        this.phone = phone;
        this.amenitiesSnapshot = amenitiesSnapshot;
        this.viewedAt = viewedAt;
    }
}
