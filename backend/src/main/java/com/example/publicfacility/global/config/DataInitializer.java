package com.example.publicfacility.global.config;

import com.example.publicfacility.user.domain.User;
import com.example.publicfacility.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDateTime;

@Configuration
@RequiredArgsConstructor
public class DataInitializer {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Bean
    public CommandLineRunner initData() {
        return args -> {
            if (!userRepository.existsByEmail("user@test.com")) {
                userRepository.save(User.builder()
                        .email("user@test.com")
                        .password(passwordEncoder.encode("1234"))
                        .nickname("자혁")
                        .createdAt(LocalDateTime.now())
                        .build());
            }
            if (!userRepository.existsByEmail("admin@test.com")) {
                userRepository.save(User.builder()
                        .email("admin@test.com")
                        .password(passwordEncoder.encode("1234"))
                        .nickname("관리자")
                        .createdAt(LocalDateTime.now())
                        .build());
            }
        };
    }
}
