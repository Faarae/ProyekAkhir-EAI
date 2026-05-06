package com.rsususumatera.admin.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PasienTerdaftarEvent {
    private String eventType = "PASIEN_TERDAFTAR";
    private LocalDateTime timestamp = LocalDateTime.now();
    private PasienPayload payload;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class PasienPayload {
        private UUID pasienId;
        private String noRm;
        private String nama;
        private Boolean statusBpjs;
    }
}
