package com.example.publicfacility.favorite.repository;

import com.example.publicfacility.favorite.domain.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    boolean existsByUserIdAndFacilityId(Long userId, Long facilityId);
    Optional<Favorite> findByUserIdAndFacilityId(Long userId, Long facilityId);
    List<Favorite> findByUserId(Long userId);
    long countByUserId(Long userId);
    void deleteByUserIdAndFacilityId(Long userId, Long facilityId);
    void deleteByUserId(Long userId);
}
