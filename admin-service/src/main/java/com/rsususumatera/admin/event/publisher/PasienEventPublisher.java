package com.rsususumatera.admin.event.publisher;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.rsususumatera.admin.config.RabbitMQConfig;
import com.rsususumatera.admin.entity.Pasien;
import com.rsususumatera.admin.event.PasienTerdaftarEvent;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;
import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
@Slf4j
public class PasienEventPublisher {
    
    private final RabbitTemplate rabbitTemplate;
    private final ObjectMapper objectMapper;
    
    public void publishPasienTerdaftar(Pasien pasien) {
        try {
            PasienTerdaftarEvent event = PasienTerdaftarEvent.builder()
                .eventType("PASIEN_TERDAFTAR")
                .timestamp(LocalDateTime.now())
                .payload(PasienTerdaftarEvent.PasienPayload.builder()
                    .pasienId(pasien.getId())
                    .noRm(pasien.getNoRm())
                    .nama(pasien.getNama())
                    .statusBpjs(pasien.getStatusBpjs())
                    .build())
                .build();
            
            String message = objectMapper.writeValueAsString(event);
            rabbitTemplate.convertAndSend(
                RabbitMQConfig.ADMIN_EXCHANGE,
                RabbitMQConfig.PASIEN_ROUTING_KEY,
                message
            );
            
            log.info("Published pasien.terdaftar event for pasien ID: {}", pasien.getId());
        } catch (Exception e) {
            log.error("Error publishing pasien.terdaftar event", e);
        }
    }
}
