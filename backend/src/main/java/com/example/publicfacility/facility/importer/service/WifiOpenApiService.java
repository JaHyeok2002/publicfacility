package com.example.publicfacility.facility.importer.service;

import com.example.publicfacility.facility.domain.FacilityCategory;
import com.example.publicfacility.facility.importer.config.PublicDataProperties;
import com.example.publicfacility.facility.importer.dto.FacilityImportItem;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class WifiOpenApiService {
    private final ObjectMapper objectMapper;
    private final PublicDataProperties properties;
    private final RestTemplate restTemplate = new RestTemplate();

    public List<FacilityImportItem> fetchWifi() {
        try {
            String serviceKey = cleanKey(properties.getWifi().getServiceKey());
            String baseUrl = trim(properties.getWifi().getBaseUrl());
            if (isBlank(serviceKey) || isBlank(baseUrl)) {
                log.warn("Wifi API skipped: missing serviceKey or baseUrl");
                return List.of();
            }

            String url = baseUrl
                    + "?serviceKey=" + serviceKey
                    + "&pageNo=1"
                    + "&numOfRows=100"
                    + "&type=json";

            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            String body = response.getBody();
            log.info("Wifi API URL: {}", maskServiceKey(url));
            log.info("Wifi API status: {}", response.getStatusCode().value());
            log.info("Wifi API body preview: {}", preview(body));
            if (!response.getStatusCode().is2xxSuccessful() || isBlank(body)) {
                return List.of();
            }
            return parse(body);
        } catch (Exception e) {
            log.error("Wifi OpenAPI fetch failed", e);
            return List.of();
        }
    }

    private List<FacilityImportItem> parse(String body) {
        try {
            JsonNode root = objectMapper.readTree(body);
            JsonNode items = root.path("response").path("body").path("items").path("item");
            if (!items.isArray()) {
                return List.of();
            }

            int total = items.size();
            int skipped = 0;
            List<String> skipReasons = new ArrayList<>();
            List<FacilityImportItem> result = new ArrayList<>();

            for (int i = 0; i < items.size(); i++) {
                try {
                    JsonNode item = items.get(i);
                    String name = text(item, "INSTL_PLC_NM");
                    String address = firstNonBlank(
                            text(item, "LCTN_ROAD_NM_ADDR"),
                            text(item, "LCTN_LOTNO_ADDR")
                    );
                    Double lat = number(item, "WGS84_LAT");
                    Double lng = number(item, "WGS84_LOT");

                    if (isBlank(name) || isBlank(address) || lat == null || lng == null) {
                        skipped++;
                        if (skipReasons.size() < 10) {
                            skipReasons.add("row " + (i + 1) + " missing name/address/lat/lng");
                        }
                        continue;
                    }

                    String amenities = joinAmenities(
                            kv("WIFI_SSID", text(item, "WIFI_SSID")),
                            kv("SRVC_PROV_NM", text(item, "SRVC_PROV_NM")),
                            kv("INSTL_PLC_DTL", text(item, "INSTL_PLC_DTL")),
                            kv("INSTL_CTPV_NM", text(item, "INSTL_CTPV_NM")),
                            kv("INSTL_SGG_NM", text(item, "INSTL_SGG_NM"))
                    );

                    result.add(new FacilityImportItem(
                            name,
                            FacilityCategory.WIFI,
                            address,
                            lat,
                            lng,
                            "상시 이용 가능",
                            "-",
                            defaultIfBlank(amenities, "SSID: Public WiFi Free")
                    ));
                } catch (Exception rowEx) {
                    skipped++;
                    if (skipReasons.size() < 10) {
                        skipReasons.add("row " + (i + 1) + " parse error: " + rowEx.getMessage());
                    }
                }
            }

            log.info("WIFI total rows: {}, converted: {}, skipped: {}", total, result.size(), skipped);
            for (String reason : skipReasons) {
                log.warn("WIFI skipped reason: {}", reason);
            }
            return result;
        } catch (Exception e) {
            log.error("Wifi parse failed", e);
            return List.of();
        }
    }

    private String text(JsonNode node, String... keys) {
        for (String key : keys) {
            JsonNode value = node.path(key);
            if (!value.isMissingNode() && !value.isNull()) {
                String s = value.asText("").trim();
                if (!s.isEmpty()) {
                    return s;
                }
            }
        }
        return "";
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (!isBlank(value)) {
                return value;
            }
        }
        return "";
    }

    private Double number(JsonNode node, String... keys) {
        try {
            String v = text(node, keys);
            return v.isBlank() ? null : Double.parseDouble(v);
        } catch (Exception e) {
            return null;
        }
    }

    private String kv(String k, String v) {
        return isBlank(v) ? "" : k + ": " + v;
    }

    private String defaultIfBlank(String value, String d) {
        return isBlank(value) ? d : value;
    }

    private boolean isBlank(String v) {
        return v == null || v.trim().isEmpty();
    }

    private String trim(String v) {
        return v == null ? "" : v.trim();
    }

    private String cleanKey(String key) {
        return trim(key).replace("\n", "").replace("\r", "").replace("\t", "");
    }

    private String joinAmenities(String... values) {
        StringBuilder sb = new StringBuilder();
        for (String value : values) {
            if (!isBlank(value)) {
                if (sb.length() > 0) {
                    sb.append(", ");
                }
                sb.append(value);
            }
        }
        return sb.toString();
    }

    private String preview(String body) {
        if (body == null) {
            return "null";
        }
        return body.length() > 300 ? body.substring(0, 300) : body;
    }

    private String maskServiceKey(String url) {
        int idx = url.indexOf("serviceKey=");
        if (idx < 0) {
            return url;
        }
        int end = url.indexOf('&', idx);
        String keyPart = end > 0 ? url.substring(idx + 11, end) : url.substring(idx + 11);
        String masked = keyPart.length() <= 8 ? "****" : keyPart.substring(0, 4) + "****" + keyPart.substring(keyPart.length() - 4);
        return end > 0 ? url.substring(0, idx + 11) + masked + url.substring(end) : url.substring(0, idx + 11) + masked;
    }
}
