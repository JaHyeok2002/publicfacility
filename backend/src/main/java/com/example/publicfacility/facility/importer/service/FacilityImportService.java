package com.example.publicfacility.facility.importer.service;

import com.example.publicfacility.facility.domain.Facility;
import com.example.publicfacility.facility.importer.dto.FacilityImportItem;
import com.example.publicfacility.facility.importer.dto.ImportStats;
import com.example.publicfacility.facility.repository.FacilityRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@Slf4j
public class FacilityImportService {
    private final FacilityRepository facilityRepository;
    private final ToiletOpenApiService toiletOpenApiService;
    private final WifiOpenApiService wifiOpenApiService;
    private final CsvFacilityImportService csvFacilityImportService;

    @Transactional
    public ImportStats importToilets() {
        return upsertAll(toiletOpenApiService.fetchToilets());
    }

    @Transactional
    public ImportStats importShelters() {
        return upsertAll(csvFacilityImportService.loadShelters());
    }

    @Transactional
    public ImportStats importWifi() {
        return upsertAll(wifiOpenApiService.fetchWifi());
    }

    @Transactional
    public ImportStats importAll() {
        return importToilets()
                .plus(importShelters())
                .plus(importWifi());
    }

    private ImportStats upsertAll(List<FacilityImportItem> items) {
        int saved = 0;
        int updated = 0;
        int skipped = 0;

        for (int i = 0; i < items.size(); i++) {
            FacilityImportItem item = items.get(i);
            try {
                if (invalid(item)) {
                    log.warn("Import skipped at row {}: invalid item={}", i + 1, item);
                    skipped++;
                    continue;
                }

                Facility existing = facilityRepository.findByNameAndAddressAndCategory(
                        item.name(), item.address(), item.category()
                ).orElse(null);

                if (existing == null) {
                    facilityRepository.save(Facility.builder()
                            .name(item.name())
                            .category(item.category())
                            .address(item.address())
                            .latitude(item.latitude())
                            .longitude(item.longitude())
                            .openTime(item.openTime())
                            .phone(item.phone())
                            .amenities(item.amenities())
                            .createdAt(LocalDateTime.now())
                            .build());
                    saved++;
                    continue;
                }

                if (same(existing, item)) {
                    skipped++;
                    continue;
                }

                existing.updateFromImport(item.latitude(), item.longitude(), item.openTime(), item.phone(), item.amenities());
                facilityRepository.save(existing);
                updated++;
            } catch (Exception e) {
                log.error("Import failed at row {}: item={}", i + 1, item, e);
                skipped++;
            }
        }

        return new ImportStats(saved, updated, skipped);
    }

    private boolean invalid(FacilityImportItem item) {
        return isBlank(item.name()) || isBlank(item.address()) || item.latitude() == null || item.longitude() == null;
    }

    private boolean same(Facility facility, FacilityImportItem item) {
        return Objects.equals(facility.getLatitude(), item.latitude())
                && Objects.equals(facility.getLongitude(), item.longitude())
                && Objects.equals(facility.getOpenTime(), item.openTime())
                && Objects.equals(facility.getPhone(), item.phone())
                && Objects.equals(facility.getAmenities(), item.amenities());
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
