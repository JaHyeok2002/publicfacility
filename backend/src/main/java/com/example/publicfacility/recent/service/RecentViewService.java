package com.example.publicfacility.recent.service;

import com.example.publicfacility.facility.dto.FacilityResponse;
import com.example.publicfacility.recent.domain.RecentView;
import com.example.publicfacility.recent.repository.RecentViewRepository;
import com.example.publicfacility.user.domain.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class RecentViewService {
    private final RecentViewRepository recentViewRepository;

    @Transactional
    public void saveOrUpdate(User user, FacilityResponse facility) {
        RecentView view = recentViewRepository.findByUserIdAndFacilityId(user.getId(), facility.id())
                .orElseGet(() -> RecentView.builder()
                        .user(user)
                        .facilityId(facility.id())
                        .facilityName(facility.name())
                        .category(Enum.valueOf(com.example.publicfacility.facility.domain.FacilityCategory.class, facility.category()))
                        .address(facility.address())
                        .latitude(facility.latitude())
                        .longitude(facility.longitude())
                        .openTime(facility.openTime())
                        .phone(facility.phone())
                        .amenitiesSnapshot(String.join(",", facility.amenities()))
                        .viewedAt(LocalDateTime.now())
                        .build());

        view.updateSnapshot(
                facility.name(),
                Enum.valueOf(com.example.publicfacility.facility.domain.FacilityCategory.class, facility.category()),
                facility.address(),
                facility.latitude(),
                facility.longitude(),
                facility.openTime(),
                facility.phone(),
                String.join(",", facility.amenities()),
                LocalDateTime.now()
        );
        recentViewRepository.save(view);
    }

    @Transactional(readOnly = true)
    public List<FacilityResponse> getRecentViews(Long userId) {
        return recentViewRepository.findByUserIdOrderByViewedAtDesc(userId).stream()
                .map(v -> new FacilityResponse(
                        v.getFacilityId(),
                        v.getFacilityName(),
                        v.getCategory().name(),
                        v.getCategory().getLabel(),
                        v.getAddress(),
                        v.getLatitude(),
                        v.getLongitude(),
                        null,
                        v.getOpenTime(),
                        v.getPhone(),
                        parseAmenities(v.getAmenitiesSnapshot()),
                        false
                ))
                .toList();
    }

    private List<String> parseAmenities(String raw) {
        if (raw == null || raw.isBlank()) {
            return List.of();
        }
        return Arrays.stream(raw.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
    }
}
