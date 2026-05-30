package com.example.publicfacility.auth.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record SignupRequest(
        @Email(message = "올바른 이메일 형식이 아닙니다.") @NotBlank String email,
        @NotBlank String password,
        @NotBlank String nickname
) {
}
