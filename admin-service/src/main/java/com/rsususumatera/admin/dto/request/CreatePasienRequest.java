package com.rsususumatera.admin.dto.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreatePasienRequest {
    
    @NotBlank(message = "NIK wajib diisi")
    @Size(min = 16, max = 16, message = "NIK harus 16 digit")
    private String nik;
    
    @NotBlank(message = "Nama wajib diisi")
    @Size(max = 100, message = "Nama maksimal 100 karakter")
    private String nama;
    
    @NotNull(message = "Tanggal lahir wajib diisi")
    @Past(message = "Tanggal lahir harus di masa lalu")
    private LocalDate tanggalLahir;
    
    @NotNull(message = "Jenis kelamin wajib diisi")
    private String jenisKelamin;
    
    @Size(max = 255, message = "Alamat maksimal 255 karakter")
    private String alamat;
    
    @Size(max = 15, message = "No telp maksimal 15 karakter")
    private String noTelp;
    
    private Boolean statusBpjs = false;
    
    @Size(max = 20, message = "No BPJS maksimal 20 karakter")
    private String noBpjs;
}
