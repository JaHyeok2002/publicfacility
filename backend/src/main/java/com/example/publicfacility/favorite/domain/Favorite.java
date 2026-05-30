package com.example.publicfacility.favorite.domain;

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
public class Favorite {
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
    private LocalDateTime createdAt;
}
