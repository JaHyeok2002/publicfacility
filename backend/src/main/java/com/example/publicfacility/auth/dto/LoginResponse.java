package com.example.publicfacility.auth.dto;

public record LoginResponse(
        String accessToken,
        String tokenType,
        LoginUser user
) {
    public record LoginUser(Long id, String email, String nickname) {}
}
