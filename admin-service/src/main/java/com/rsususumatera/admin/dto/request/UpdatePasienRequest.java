package com.rsususumatera.admin.dto.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdatePasienRequest {
    
    @Size(max = 100, message = "Nama maksimal 100 karakter")
    private String nama;
    
    @Size(max = 255, message = "Alamat maksimal 255 karakter")
    private String alamat;
    
    @Size(max = 15, message = "No telp maksimal 15 karakter")
    private String noTelp;
    
    private Boolean statusBpjs;
    
    @Size(max = 20, message = "No BPJS maksimal 20 karakter")
    private String noBpjs;
}
