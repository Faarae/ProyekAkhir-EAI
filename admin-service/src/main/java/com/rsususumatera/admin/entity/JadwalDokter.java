package com.rsususumatera.admin.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalTime;
import java.util.UUID;

@Entity
@Table(name = "jadwal_dokter", indexes = {
    @Index(name = "idx_dokter_id", columnList = "dokter_id"),
    @Index(name = "idx_poliklinik_id", columnList = "poliklinik_id")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class JadwalDokter {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(name = "dokter_id", nullable = false)
    private UUID dokterId;
    
    @Column(name = "poliklinik_id", nullable = false)
    private UUID poliklinikId;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private HariKerja hari;
    
    @Column(name = "jam_mulai", nullable = false)
    private LocalTime jamMulai;
    
    @Column(name = "jam_selesai", nullable = false)
    private LocalTime jamSelesai;
    
    @Column(name = "kuota_pasien", nullable = false)
    private Integer kuotaPasien = 20;
    
    @Column(nullable = false)
    private Boolean isActive = true;

    public enum HariKerja {
        SENIN, SELASA, RABU, KAMIS, JUMAT, SABTU
    }
}
