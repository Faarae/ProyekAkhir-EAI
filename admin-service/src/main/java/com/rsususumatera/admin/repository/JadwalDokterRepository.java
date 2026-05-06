package com.rsususumatera.admin.repository;

import com.rsususumatera.admin.entity.JadwalDokter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.UUID;

@Repository
public interface JadwalDokterRepository extends JpaRepository<JadwalDokter, UUID> {
    List<JadwalDokter> findAllByDokterId(UUID dokterId);
    List<JadwalDokter> findAllByIsActiveTrue();
}
