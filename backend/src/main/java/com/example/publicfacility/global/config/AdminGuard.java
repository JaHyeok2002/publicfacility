package com.example.publicfacility.global.config;

import com.example.publicfacility.global.exception.CustomException;
import com.example.publicfacility.user.domain.User;
import com.example.publicfacility.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AdminGuard {
    private final UserService userService;

    @Value("${admin.email:admin@test.com}")
    private String adminEmail;

    public void checkAdmin() {
        Long userId = userService.requireCurrentUserId();
        User user = userService.getUserOrThrow(userId);
        if (!adminEmail.equalsIgnoreCase(user.getEmail())) {
            throw new CustomException(HttpStatus.FORBIDDEN, "관리자만 접근 가능합니다.");
        }
    }
}
