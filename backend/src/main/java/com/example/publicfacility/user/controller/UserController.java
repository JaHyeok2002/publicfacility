package com.example.publicfacility.user.controller;

import com.example.publicfacility.facility.dto.FacilityResponse;
import com.example.publicfacility.global.response.MessageResponse;
import com.example.publicfacility.recent.service.RecentViewService;
import com.example.publicfacility.user.dto.MyPageResponse;
import com.example.publicfacility.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users/me")
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final RecentViewService recentViewService;

    @GetMapping
    public MyPageResponse me() {
        return userService.getMyPage(userService.requireCurrentUserId());
    }

    @DeleteMapping
    public MessageResponse deleteMe() {
        userService.deleteMe(userService.requireCurrentUserId());
        return new MessageResponse("회원 탈퇴가 완료되었습니다.");
    }

    @GetMapping("/recent-facilities")
    public List<FacilityResponse> recentFacilities() {
        Long userId = userService.requireCurrentUserId();
        return recentViewService.getRecentViews(userId);
    }
}
