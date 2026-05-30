package com.example.publicfacility.facility.importer.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "public-data")
public class PublicDataProperties {
    private Source toilet = new Source();
    private Shelter shelter = new Shelter();
    private Source wifi = new Source();

    @Getter
    @Setter
    public static class Source {
        private String serviceKey;
        private String pageUrl;
        private String baseUrl;
    }

    @Getter
    @Setter
    public static class Shelter {
        private String pageUrl;
        private String csvPath;
    }
}
