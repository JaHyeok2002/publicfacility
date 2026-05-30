package com.example.publicfacility.facility.repository;

import com.example.publicfacility.facility.domain.Facility;
import com.example.publicfacility.facility.domain.FacilityCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface FacilityRepository extends JpaRepository<Facility, Long> {
    List<Facility> findByCategory(FacilityCategory category);
    Optional<Facility> findByNameAndAddressAndCategory(String name, String address, FacilityCategory category);
}
