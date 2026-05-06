package com.rsususumatera.admin.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "antrean", indexes = {
    @Index(name = "idx_pasien_id", columnList = "pasien_id"),
    @Index(name = "idx_jadwal_id", columnList = "jadwal_id"),
    @Index(name = "idx_tanggal", columnList = "tanggal")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Antrean {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(name = "pasien_id", nullable = false)
    private UUID pasienId;
    
    @Column(name = "jadwal_id", nullable = false)
    private UUID jadwalId;
    
    @Column(name = "nomor_antrean", nullable = false)
    private Integer nomorAntrean;
    
    @Column(nullable = false)
    private LocalDate tanggal;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatusAntrean status = StatusAntrean.MENUNGGU;
    
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column(nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    public enum StatusAntrean {
        MENUNGGU, DIPANGGIL, SELESAI, BATAL
    }
}
