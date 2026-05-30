package com.example.publicfacility.auth.controller;

import com.example.publicfacility.auth.dto.LoginRequest;
import com.example.publicfacility.auth.dto.LoginResponse;
import com.example.publicfacility.auth.dto.SignupRequest;
import com.example.publicfacility.auth.service.AuthService;
import com.example.publicfacility.global.response.MessageResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/signup")
    public MessageResponse signup(@Valid @RequestBody SignupRequest request) {
        authService.signup(request);
        return new MessageResponse("회원가입 성공");
    }

    @PostMapping("/login")
    public LoginResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }
}
