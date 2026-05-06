package com.rsususumatera.admin.repository;

import com.rsususumatera.admin.entity.Antrean;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface AntreanRepository extends JpaRepository<Antrean, UUID> {
    List<Antrean> findAllByTanggal(LocalDate tanggal);
    List<Antrean> findAllByPasienId(UUID pasienId);
    Page<Antrean> findAll(Pageable pageable);
}
