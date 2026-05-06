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
public class LoginRequest {
    
    @NotBlank(message = "Username wajib diisi")
    private String username;
    
    @NotBlank(message = "Password wajib diisi")
    private String password;
}
