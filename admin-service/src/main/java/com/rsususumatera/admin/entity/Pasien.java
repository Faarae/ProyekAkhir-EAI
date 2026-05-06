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
@Table(name = "pasien", indexes = {
    @Index(name = "idx_nik", columnList = "nik", unique = true),
    @Index(name = "idx_no_rm", columnList = "no_rm", unique = true)
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Pasien {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(unique = true, nullable = false, length = 16)
    private String nik;
    
    @Column(nullable = false, length = 100)
    private String nama;
    
    @Column(name = "no_rm", unique = true, nullable = false, length = 20)
    private String noRm;
    
    @Column(nullable = true)
    private LocalDate tanggalLahir;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = true)
    private JenisKelamin jenisKelamin;
    
    @Column(nullable = true, length = 255)
    private String alamat;
    
    @Column(nullable = true, length = 15)
    private String noTelp;
    
    @Column(nullable = false)
    private Boolean statusBpjs = false;
    
    @Column(nullable = true, length = 20)
    private String noBpjs;
    
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column(nullable = false)
    private LocalDateTime updatedAt = LocalDateTime.now();

    public enum JenisKelamin {
        LAKI_LAKI, PEREMPUAN
    }
}
