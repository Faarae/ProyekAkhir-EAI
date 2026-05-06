package com.rsususumatera.admin.service.impl;

import com.rsususumatera.admin.dto.request.CreatePasienRequest;
import com.rsususumatera.admin.dto.request.UpdatePasienRequest;
import com.rsususumatera.admin.dto.response.PasienResponse;
import com.rsususumatera.admin.entity.Pasien;
import com.rsususumatera.admin.event.publisher.PasienEventPublisher;
import com.rsususumatera.admin.exception.ResourceNotFoundException;
import com.rsususumatera.admin.repository.PasienRepository;
import com.rsususumatera.admin.service.PasienService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class PasienServiceImpl implements PasienService {
    
    private final PasienRepository pasienRepository;
    private final PasienEventPublisher eventPublisher;
    
    @Override
    @Transactional
    public PasienResponse createPasien(CreatePasienRequest request) {
        log.info("Creating new pasien with NIK: {}", request.getNik());
        
        // Check if NIK already exists
        if (pasienRepository.findByNik(request.getNik()).isPresent()) {
            throw new RuntimeException("Pasien dengan NIK " + request.getNik() + " sudah terdaftar");
        }
        
        // Generate No. RM
        String noRm = generateNoRm();
        
        Pasien pasien = Pasien.builder()
            .nik(request.getNik())
            .nama(request.getNama())
            .noRm(noRm)
            .tanggalLahir(request.getTanggalLahir())
            .jenisKelamin(Pasien.JenisKelamin.valueOf(request.getJenisKelamin().toUpperCase()))
            .alamat(request.getAlamat())
            .noTelp(request.getNoTelp())
            .statusBpjs(request.getStatusBpjs() != null ? request.getStatusBpjs() : false)
            .noBpjs(request.getNoBpjs())
            .createdAt(LocalDateTime.now())
            .updatedAt(LocalDateTime.now())
            .build();
        
        Pasien saved = pasienRepository.save(pasien);
        log.info("Pasien created successfully with ID: {}", saved.getId());
        
        // Publish event
        eventPublisher.publishPasienTerdaftar(saved);
        
        return mapToPasienResponse(saved);
    }
    
    @Override
    public PasienResponse getPasienById(UUID id) {
        Pasien pasien = pasienRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Pasien tidak ditemukan dengan ID: " + id));
        return mapToPasienResponse(pasien);
    }
    
    @Override
    public PasienResponse getPasienByNik(String nik) {
        Pasien pasien = pasienRepository.findByNik(nik)
            .orElseThrow(() -> new ResourceNotFoundException("Pasien tidak ditemukan dengan NIK: " + nik));
        return mapToPasienResponse(pasien);
    }
    
    @Override
    public PasienResponse getPasienByNoRm(String noRm) {
        Pasien pasien = pasienRepository.findByNoRm(noRm)
            .orElseThrow(() -> new ResourceNotFoundException("Pasien tidak ditemukan dengan No. RM: " + noRm));
        return mapToPasienResponse(pasien);
    }
    
    @Override
    public Page<PasienResponse> getAllPasien(Pageable pageable) {
        return pasienRepository.findAll(pageable)
            .map(this::mapToPasienResponse);
    }
    
    @Override
    @Transactional
    public PasienResponse updatePasien(UUID id, UpdatePasienRequest request) {
        Pasien pasien = pasienRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Pasien tidak ditemukan dengan ID: " + id));
        
        if (request.getNama() != null) {
            pasien.setNama(request.getNama());
        }
        if (request.getAlamat() != null) {
            pasien.setAlamat(request.getAlamat());
        }
        if (request.getNoTelp() != null) {
            pasien.setNoTelp(request.getNoTelp());
        }
        if (request.getStatusBpjs() != null) {
            pasien.setStatusBpjs(request.getStatusBpjs());
        }
        if (request.getNoBpjs() != null) {
            pasien.setNoBpjs(request.getNoBpjs());
        }
        
        pasien.setUpdatedAt(LocalDateTime.now());
        
        Pasien updated = pasienRepository.save(pasien);
        return mapToPasienResponse(updated);
    }
    
    @Override
    @Transactional
    public void deletePasien(UUID id) {
        Pasien pasien = pasienRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Pasien tidak ditemukan dengan ID: " + id));
        pasienRepository.delete(pasien);
        log.info("Pasien deleted with ID: {}", id);
    }
    
    private String generateNoRm() {
        // Format: RSU-YYYY-XXXXX
        long count = pasienRepository.count() + 1;
        int year = LocalDateTime.now().getYear();
        return String.format("RSU-%d-%05d", year, count);
    }
    
    private PasienResponse mapToPasienResponse(Pasien pasien) {
        return PasienResponse.builder()
            .id(pasien.getId())
            .nik(pasien.getNik())
            .nama(pasien.getNama())
            .noRm(pasien.getNoRm())
            .tanggalLahir(pasien.getTanggalLahir())
            .jenisKelamin(pasien.getJenisKelamin() != null ? pasien.getJenisKelamin().toString() : null)
            .alamat(pasien.getAlamat())
            .noTelp(pasien.getNoTelp())
            .statusBpjs(pasien.getStatusBpjs())
            .noBpjs(pasien.getNoBpjs())
            .createdAt(pasien.getCreatedAt())
            .updatedAt(pasien.getUpdatedAt())
            .build();
    }
}
