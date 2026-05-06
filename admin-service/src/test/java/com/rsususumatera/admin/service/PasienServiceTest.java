package com.rsususumatera.admin.service;

import com.rsususumatera.admin.dto.request.CreatePasienRequest;
import com.rsususumatera.admin.dto.response.PasienResponse;
import com.rsususumatera.admin.entity.Pasien;
import com.rsususumatera.admin.repository.PasienRepository;
import com.rsususumatera.admin.service.impl.PasienServiceImpl;
import com.rsususumatera.admin.event.publisher.PasienEventPublisher;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.time.LocalDate;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class PasienServiceTest {
    
    @Mock
    private PasienRepository pasienRepository;
    
    @Mock
    private PasienEventPublisher eventPublisher;
    
    @InjectMocks
    private PasienServiceImpl pasienService;
    
    private CreatePasienRequest createRequest;
    private Pasien pasienEntity;
    
    @BeforeEach
    public void setUp() {
        createRequest = CreatePasienRequest.builder()
            .nik("1234567890123456")
            .nama("Budi Santoso")
            .tanggalLahir(LocalDate.of(1990, 1, 1))
            .jenisKelamin("LAKI_LAKI")
            .alamat("Jl. Merdeka No. 1")
            .noTelp("081234567890")
            .statusBpjs(true)
            .noBpjs("0000123456789")
            .build();
        
        pasienEntity = Pasien.builder()
            .id(UUID.randomUUID())
            .nik("1234567890123456")
            .nama("Budi Santoso")
            .noRm("RSU-2026-00001")
            .tanggalLahir(LocalDate.of(1990, 1, 1))
            .jenisKelamin(Pasien.JenisKelamin.LAKI_LAKI)
            .alamat("Jl. Merdeka No. 1")
            .noTelp("081234567890")
            .statusBpjs(true)
            .noBpjs("0000123456789")
            .build();
    }
    
    @Test
    public void testCreatePasien_Success() {
        // Arrange
        when(pasienRepository.findByNik(createRequest.getNik())).thenReturn(java.util.Optional.empty());
        when(pasienRepository.count()).thenReturn(0L);
        when(pasienRepository.save(any(Pasien.class))).thenReturn(pasienEntity);
        
        // Act
        PasienResponse response = pasienService.createPasien(createRequest);
        
        // Assert
        assertNotNull(response);
        assertEquals(pasienEntity.getNik(), response.getNik());
        assertEquals(pasienEntity.getNama(), response.getNama());
        verify(pasienRepository, times(1)).save(any(Pasien.class));
        verify(eventPublisher, times(1)).publishPasienTerdaftar(any(Pasien.class));
    }
    
    @Test
    public void testGetPasienById_Success() {
        // Arrange
        when(pasienRepository.findById(pasienEntity.getId())).thenReturn(java.util.Optional.of(pasienEntity));
        
        // Act
        PasienResponse response = pasienService.getPasienById(pasienEntity.getId());
        
        // Assert
        assertNotNull(response);
        assertEquals(pasienEntity.getId(), response.getId());
    }
}
