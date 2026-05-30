package com.example.publicfacility.facility.importer.service;

import com.example.publicfacility.facility.domain.FacilityCategory;
import com.example.publicfacility.facility.importer.config.PublicDataProperties;
import com.example.publicfacility.facility.importer.dto.FacilityImportItem;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
@Slf4j
public class CsvFacilityImportService {
    private static final double DEFAULT_LAT = 37.5665;
    private static final double DEFAULT_LNG = 126.9780;
    private final PublicDataProperties properties;

    public List<FacilityImportItem> loadShelters() {
        String path = properties.getShelter().getCsvPath();
        if (isBlank(path)) {
            path = "data/seoul_shelters.csv";
        }

        List<FacilityImportItem> utf8 = loadFromCsv(path, StandardCharsets.UTF_8);
        if (!utf8.isEmpty()) {
            return utf8;
        }
        List<FacilityImportItem> ms949 = loadFromCsv(path, Charset.forName("MS949"));
        if (!ms949.isEmpty()) {
            return ms949;
        }
        return loadFromCsv(path, Charset.forName("CP949"));
    }

    private List<FacilityImportItem> loadFromCsv(String path, Charset charset) {
        List<String> skipReasons = new ArrayList<>();
        int total = 0;
        int success = 0;
        int skipped = 0;
        try (InputStreamReader reader = new InputStreamReader(new ClassPathResource(path).getInputStream(), charset);
             CSVParser parser = CSVFormat.DEFAULT.builder().setHeader().setSkipHeaderRecord(true).setTrim(true).build().parse(reader)) {

            Set<String> headers = parser.getHeaderMap().keySet();
            log.info("Shelter CSV charset={} headers={}", charset, headers);

            List<FacilityImportItem> result = new ArrayList<>();
            for (CSVRecord record : parser) {
                total++;
                try {
                    String name = pick(record, "쉼터명칭", "쉼터명", "시설명", "name");
                    String roadAddress = pick(record, "도로명주소", "소재지도로명주소");
                    String lotAddress = pick(record, "지번주소", "소재지지번주소");
                    String address = !isBlank(roadAddress) ? roadAddress : lotAddress;

                    Double lat = parseDouble(pick(record, "위도", "latitude", "Y좌표", "Y"));
                    Double lng = parseDouble(pick(record, "경도", "longitude", "X좌표", "X"));
                    boolean noCoord = (lat == null || lng == null);
                    if (noCoord) {
                        lat = DEFAULT_LAT;
                        lng = DEFAULT_LNG;
                    }

                    if (isBlank(name) || isBlank(address)) {
                        skipped++;
                        if (skipReasons.size() < 10) skipReasons.add("row " + record.getRecordNumber() + " missing name/address");
                        continue;
                    }

                    String amenities = joinAmenities(
                            kv("시설구분1", pick(record, "시설구분1")),
                            kv("시설구분2", pick(record, "시설구분2")),
                            kv("시설면적", pick(record, "시설면적")),
                            noCoord ? "좌표 정보 없음" : ""
                    );

                    result.add(new FacilityImportItem(
                            name,
                            FacilityCategory.SHELTER,
                            address,
                            lat,
                            lng,
                            "운영 정보 확인 필요",
                            "-",
                            defaultIfBlank(amenities, "무더위쉼터")
                    ));
                    success++;
                } catch (Exception rowEx) {
                    skipped++;
                    if (skipReasons.size() < 10) skipReasons.add("row " + record.getRecordNumber() + " parse error: " + rowEx.getMessage());
                }
            }
            log.info("Shelter CSV result charset={} total={} success={} skipped={}", charset, total, success, skipped);
            for (String reason : skipReasons) {
                log.warn("Shelter CSV skip reason: {}", reason);
            }
            return result;
        } catch (Exception e) {
            log.warn("Shelter CSV load failed path={} charset={}", path, charset, e);
            return List.of();
        }
    }

    private String pick(CSVRecord record, String... headers) {
        for (String header : headers) {
            if (record.isMapped(header)) {
                String value = record.get(header);
                if (!isBlank(value)) return value.trim();
            }
        }
        return "";
    }

    private Double parseDouble(String value) {
        if (isBlank(value)) return null;
        try {
            return Double.parseDouble(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private String kv(String label, String value) {
        return isBlank(value) ? "" : label + ": " + value;
    }

    private String joinAmenities(String... values) {
        StringBuilder sb = new StringBuilder();
        for (String value : values) {
            if (!isBlank(value)) {
                if (sb.length() > 0) sb.append(", ");
                sb.append(value);
            }
        }
        return sb.toString();
    }

    private String defaultIfBlank(String value, String defaultValue) {
        return isBlank(value) ? defaultValue : value;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
