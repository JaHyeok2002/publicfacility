package com.example.publicfacility.favorite.service;

import com.example.publicfacility.facility.domain.FacilityCategory;
import com.example.publicfacility.facility.dto.FacilityResponse;
import com.example.publicfacility.facility.service.FacilityService;
import com.example.publicfacility.favorite.domain.Favorite;
import com.example.publicfacility.favorite.dto.FavoriteCreateRequest;
import com.example.publicfacility.favorite.repository.FavoriteRepository;
import com.example.publicfacility.user.domain.User;
import com.example.publicfacility.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FavoriteService {
    private final FavoriteRepository favoriteRepository;
    private final UserService userService;
    private final ObjectProvider<FacilityService> facilityServiceProvider;

    @Transactional(readOnly = true)
    public List<FacilityResponse> myFavorites(Long userId, Double lat, Double lng) {
        return favoriteRepository.findByUserId(userId).stream()
                .map(f -> toResponse(f, lat, lng))
                .toList();
    }

    @Transactional
    public void addFromBody(Long userId, FavoriteCreateRequest request) {
        if (favoriteRepository.existsByUserIdAndFacilityId(userId, request.facilityId())) {
            return;
        }
        FacilityResponse snapshot = resolveSnapshot(request, userId);
        User user = userService.getUserOrThrow(userId);
        Favorite favorite = Favorite.builder()
                .user(user)
                .facilityId(snapshot.id())
                .facilityName(snapshot.name())
                .category(FacilityCategory.valueOf(snapshot.category()))
                .address(snapshot.address())
                .latitude(snapshot.latitude())
                .longitude(snapshot.longitude())
                .openTime(snapshot.openTime())
                .phone(snapshot.phone())
                .amenitiesSnapshot(String.join(",", snapshot.amenities()))
                .createdAt(LocalDateTime.now())
                .build();
        favoriteRepository.save(favorite);
    }

    @Transactional
    public void addByFacilityId(Long userId, Long facilityId) {
        if (favoriteRepository.existsByUserIdAndFacilityId(userId, facilityId)) {
            return;
        }
        FacilityResponse facility = facilityServiceProvider.getObject().findByIdRealtime(facilityId, null, null, userId, true);
        addFromBody(userId, new FavoriteCreateRequest(
                facility.id(),
                facility.name(),
                FacilityCategory.valueOf(facility.category()),
                facility.address(),
                facility.latitude(),
                facility.longitude(),
                facility.openTime(),
                facility.phone(),
                facility.amenities()
        ));
    }

    private FacilityResponse resolveSnapshot(FavoriteCreateRequest request, Long userId) {
        if (hasFullSnapshot(request)) {
            return new FacilityResponse(
                    request.facilityId(),
                    request.name(),
                    request.category().name(),
                    request.category().getLabel(),
                    request.address(),
                    request.latitude(),
                    request.longitude(),
                    null,
                    request.openTime(),
                    request.phone(),
                    request.amenities(),
                    true
            );
        }
        return facilityServiceProvider.getObject().findByIdRealtime(request.facilityId(), null, null, userId, true);
    }

    private boolean hasFullSnapshot(FavoriteCreateRequest request) {
        return request.name() != null
                && request.category() != null
                && request.address() != null
                && request.latitude() != null
                && request.longitude() != null
                && request.openTime() != null
                && request.phone() != null
                && request.amenities() != null;
    }

    @Transactional
    public void remove(Long userId, Long facilityId) {
        favoriteRepository.deleteByUserIdAndFacilityId(userId, facilityId);
    }

    @Transactional(readOnly = true)
    public Set<Long> favoriteFacilityIds(Long userId) {
        if (userId == null) {
            return Set.of();
        }
        return favoriteRepository.findByUserId(userId).stream()
                .map(Favorite::getFacilityId)
                .collect(Collectors.toSet());
    }

    private FacilityResponse toResponse(Favorite f, Double lat, Double lng) {
        Long distance = (lat != null && lng != null) ? haversineMeters(lat, lng, f.getLatitude(), f.getLongitude()) : null;
        return new FacilityResponse(
                f.getFacilityId(),
                f.getFacilityName(),
                f.getCategory().name(),
                f.getCategory().getLabel(),
                f.getAddress(),
                f.getLatitude(),
                f.getLongitude(),
                distance,
                f.getOpenTime(),
                f.getPhone(),
                parseAmenities(f.getAmenitiesSnapshot()),
                true
        );
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

    private long haversineMeters(double lat1, double lng1, double lat2, double lng2) {
        final double earthRadius = 6371000.0;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return Math.round(earthRadius * c);
    }
}
