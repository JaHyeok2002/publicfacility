package com.example.publicfacility.user.service;

import com.example.publicfacility.auth.jwt.CustomUserDetails;
import com.example.publicfacility.favorite.repository.FavoriteRepository;
import com.example.publicfacility.global.exception.CustomException;
import com.example.publicfacility.recent.repository.RecentViewRepository;
import com.example.publicfacility.user.domain.User;
import com.example.publicfacility.user.dto.MyPageResponse;
import com.example.publicfacility.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final FavoriteRepository favoriteRepository;
    private final RecentViewRepository recentViewRepository;

    @Transactional(readOnly = true)
    public MyPageResponse getMyPage(Long userId) {
        User user = getUserOrThrow(userId);
        return new MyPageResponse(
                user.getId(),
                user.getEmail(),
                user.getNickname(),
                favoriteRepository.countByUserId(userId),
                recentViewRepository.countByUserId(userId)
        );
    }

    @Transactional
    public void deleteMe(Long userId) {
        recentViewRepository.deleteByUserId(userId);
        favoriteRepository.deleteByUserId(userId);
        userRepository.deleteById(userId);
    }

    @Transactional(readOnly = true)
    public User getUserOrThrow(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(HttpStatus.UNAUTHORIZED, "인증 사용자 정보를 찾을 수 없습니다."));
    }

    public Long currentUserIdOrNull() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUserDetails principal)) {
            return null;
        }
        return principal.getUserId();
    }

    public Long requireCurrentUserId() {
        Long userId = currentUserIdOrNull();
        if (userId == null) {
            throw new CustomException(HttpStatus.UNAUTHORIZED, "인증이 필요합니다.");
        }
        return userId;
    }
}
