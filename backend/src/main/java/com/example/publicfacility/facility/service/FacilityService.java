package com.example.publicfacility.facility.service;

import com.example.publicfacility.facility.domain.FacilityCategory;
import com.example.publicfacility.facility.dto.FacilityResponse;
import com.example.publicfacility.facility.importer.dto.FacilityImportItem;
import com.example.publicfacility.facility.importer.service.CsvFacilityImportService;
import com.example.publicfacility.facility.importer.service.ToiletOpenApiService;
import com.example.publicfacility.facility.importer.service.WifiOpenApiService;
import com.example.publicfacility.favorite.service.FavoriteService;
import com.example.publicfacility.global.exception.CustomException;
import com.example.publicfacility.recent.service.RecentViewService;
import com.example.publicfacility.user.domain.User;
import com.example.publicfacility.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FacilityService {
    private final ToiletOpenApiService toiletOpenApiService;
    private final CsvFacilityImportService csvFacilityImportService;
    private final WifiOpenApiService wifiOpenApiService;
    private final FavoriteService favoriteService;
    private final UserService userService;
    private final RecentViewService recentViewService;

    @Transactional(readOnly = true)
    public List<FacilityResponse> list(FacilityCategory category, String keyword, String sort, Double lat, Double lng) {
        Long userId = userService.currentUserIdOrNull();
        Set<Long> favoriteIds = favoriteService.favoriteFacilityIds(userId);
        List<FacilityResponse> all = fetchRealtime(category, favoriteIds, lat, lng);

        List<FacilityResponse> filtered = all.stream()
                .filter(f -> keyword == null || keyword.isBlank() || containsKeyword(f, keyword))
                .collect(Collectors.toList());

        if ("distance".equalsIgnoreCase(sort)) {
            filtered.sort(Comparator.comparing(f -> f.distance() == null ? Long.MAX_VALUE : f.distance()));
        }
        return filtered;
    }

    @Transactional
    public FacilityResponse detail(Long facilityId, Double lat, Double lng) {
        Long userId = userService.currentUserIdOrNull();
        FacilityResponse found = findByIdRealtime(facilityId, lat, lng, userId, true);
        if (userId != null) {
            User user = userService.getUserOrThrow(userId);
            recentViewService.saveOrUpdate(user, found);
        }
        return found;
    }

    @Transactional(readOnly = true)
    public List<FacilityResponse> nearby(Double lat, Double lng, FacilityCategory category) {
        return list(category, null, "distance", lat, lng);
    }

    @Transactional(readOnly = true)
    public FacilityResponse findByIdRealtime(Long facilityId, Double lat, Double lng, Long userId, boolean throwIfNotFound) {
        Set<Long> favoriteIds = favoriteService.favoriteFacilityIds(userId);
        List<FacilityResponse> all = fetchRealtime(null, favoriteIds, lat, lng);
        return all.stream()
                .filter(f -> Objects.equals(f.id(), facilityId))
                .findFirst()
                .orElseGet(() -> {
                    if (throwIfNotFound) {
                        throw new CustomException(HttpStatus.NOT_FOUND, "시설을 찾을 수 없습니다.");
                    }
                    return null;
                });
    }

    private List<FacilityResponse> fetchRealtime(FacilityCategory category, Set<Long> favoriteIds, Double lat, Double lng) {
        List<FacilityImportItem> source = new ArrayList<>();
        if (category == null || category == FacilityCategory.TOILET) {
            source.addAll(toiletOpenApiService.fetchToilets());
        }
        if (category == null || category == FacilityCategory.SHELTER) {
            source.addAll(csvFacilityImportService.loadShelters());
        }
        if (category == null || category == FacilityCategory.WIFI) {
            source.addAll(wifiOpenApiService.fetchWifi());
        }
        return source.stream()
                .filter(this::isValid)
                .map(item -> toResponse(item, lat, lng, favoriteIds.contains(stableId(item))))
                .toList();
    }

    private boolean isValid(FacilityImportItem item) {
        return item != null
                && item.name() != null && !item.name().isBlank()
                && item.address() != null && !item.address().isBlank()
                && item.latitude() != null
                && item.longitude() != null;
    }

    private FacilityResponse toResponse(FacilityImportItem item, Double lat, Double lng, boolean favorite) {
        Long distance = (lat != null && lng != null) ? haversineMeters(lat, lng, item.latitude(), item.longitude()) : null;
        return new FacilityResponse(
                stableId(item),
                item.name(),
                item.category().name(),
                item.category().getLabel(),
                item.address(),
                item.latitude(),
                item.longitude(),
                distance,
                item.openTime(),
                item.phone(),
                parseAmenities(item.amenities()),
                favorite
        );
    }

    private Long stableId(FacilityImportItem item) {
        return Math.abs((long) Objects.hash(item.name(), item.address(), item.category().name()));
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

    private boolean containsKeyword(FacilityResponse facility, String keyword) {
        String k = keyword.toLowerCase(Locale.ROOT);
        return facility.name().toLowerCase(Locale.ROOT).contains(k)
                || facility.address().toLowerCase(Locale.ROOT).contains(k);
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
