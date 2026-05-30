package com.example.publicfacility.user.dto;

public record MyPageResponse(
        Long id,
        String email,
        String nickname,
        long favoriteCount,
        long recentViewCount
) {
}
