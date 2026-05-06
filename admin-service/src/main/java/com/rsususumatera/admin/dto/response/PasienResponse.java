package com.rsususumatera.admin.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PasienResponse {
    private UUID id;
    private String nik;
    private String nama;
    private String noRm;
    private LocalDate tanggalLahir;
    private String jenisKelamin;
    private String alamat;
    private String noTelp;
    private Boolean statusBpjs;
    private String noBpjs;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
