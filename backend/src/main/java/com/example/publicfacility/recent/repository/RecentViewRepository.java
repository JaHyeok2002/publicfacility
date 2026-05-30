package com.example.publicfacility.recent.repository;

import com.example.publicfacility.recent.domain.RecentView;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface RecentViewRepository extends JpaRepository<RecentView, Long> {
    Optional<RecentView> findByUserIdAndFacilityId(Long userId, Long facilityId);
    List<RecentView> findByUserIdOrderByViewedAtDesc(Long userId);
    long countByUserId(Long userId);
    void deleteByUserId(Long userId);
}
