package com.rsususumatera.admin.repository;

import com.rsususumatera.admin.entity.Pasien;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PasienRepository extends JpaRepository<Pasien, UUID> {
    Optional<Pasien> findByNik(String nik);
    Optional<Pasien> findByNoRm(String noRm);
    Page<Pasien> findAll(Pageable pageable);
}
