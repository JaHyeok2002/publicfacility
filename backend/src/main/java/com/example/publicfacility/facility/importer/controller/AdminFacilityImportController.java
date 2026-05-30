package com.example.publicfacility.facility.importer.controller;

import com.example.publicfacility.global.config.AdminGuard;
import com.example.publicfacility.global.response.MessageResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/admin/facilities/import")
@RequiredArgsConstructor
public class AdminFacilityImportController {
    private static final String DEPRECATED_MESSAGE = "실시간 조회 방식으로 변경되어 import가 필요하지 않습니다.";
    private final AdminGuard adminGuard;

    @PostMapping("/toilets")
    public MessageResponse toilets() {
        adminGuard.checkAdmin();
        return new MessageResponse(DEPRECATED_MESSAGE);
    }

    @PostMapping("/shelters")
    public MessageResponse shelters() {
        adminGuard.checkAdmin();
        return new MessageResponse(DEPRECATED_MESSAGE);
    }

    @PostMapping("/wifi")
    public MessageResponse wifi() {
        adminGuard.checkAdmin();
        return new MessageResponse(DEPRECATED_MESSAGE);
    }

    @PostMapping("/all")
    public MessageResponse all() {
        adminGuard.checkAdmin();
        return new MessageResponse(DEPRECATED_MESSAGE);
    }
}
