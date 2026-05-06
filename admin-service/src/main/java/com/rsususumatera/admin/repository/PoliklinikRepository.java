package com.rsususumatera.admin.repository;

import com.rsususumatera.admin.entity.Poliklinik;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.UUID;

@Repository
public interface PoliklinikRepository extends JpaRepository<Poliklinik, UUID> {
    List<Poliklinik> findAllByIsActiveTrue();
}
