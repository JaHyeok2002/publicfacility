package com.example.publicfacility.auth.service;

import com.example.publicfacility.auth.dto.LoginRequest;
import com.example.publicfacility.auth.dto.LoginResponse;
import com.example.publicfacility.auth.dto.SignupRequest;
import com.example.publicfacility.auth.jwt.JwtTokenProvider;
import com.example.publicfacility.global.exception.CustomException;
import com.example.publicfacility.user.domain.User;
import com.example.publicfacility.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    @Transactional
    public void signup(SignupRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new CustomException(HttpStatus.CONFLICT, "이미 가입된 이메일입니다.");
        }
        User user = User.builder()
                .email(request.email())
                .password(passwordEncoder.encode(request.password()))
                .nickname(request.nickname())
                .createdAt(LocalDateTime.now())
                .build();
        userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.email())
                .orElseThrow(() -> new CustomException(HttpStatus.UNAUTHORIZED, "이메일 또는 비밀번호가 올바르지 않습니다."));
        if (!passwordEncoder.matches(request.password(), user.getPassword())) {
            throw new CustomException(HttpStatus.UNAUTHORIZED, "이메일 또는 비밀번호가 올바르지 않습니다.");
        }
        String token = jwtTokenProvider.createToken(user.getId(), user.getEmail());
        return new LoginResponse(
                token,
                "Bearer",
                new LoginResponse.LoginUser(user.getId(), user.getEmail(), user.getNickname())
        );
    }
}
