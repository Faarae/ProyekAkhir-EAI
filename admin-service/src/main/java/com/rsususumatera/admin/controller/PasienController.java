package com.rsususumatera.admin.controller;

import com.rsususumatera.admin.dto.request.CreatePasienRequest;
import com.rsususumatera.admin.dto.request.UpdatePasienRequest;
import com.rsususumatera.admin.dto.response.ApiResponse;
import com.rsususumatera.admin.dto.response.PasienResponse;
import com.rsususumatera.admin.service.PasienService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/pasien")
@RequiredArgsConstructor
@Tag(name = "Pasien", description = "Manage pasien data")
@SecurityRequirement(name = "Bearer")
public class PasienController {
    
    private final PasienService pasienService;
    
    @PostMapping
    @Operation(summary = "Register new pasien")
    public ResponseEntity<ApiResponse<PasienResponse>> createPasien(
            @Valid @RequestBody CreatePasienRequest request) {
        PasienResponse response = pasienService.createPasien(request);
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(ApiResponse.created(response));
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Get pasien by ID")
    public ResponseEntity<ApiResponse<PasienResponse>> getPasien(@PathVariable UUID id) {
        PasienResponse response = pasienService.getPasienById(id);
        return ResponseEntity.ok(ApiResponse.ok(response, "Pasien retrieved successfully"));
    }
    
    @GetMapping("/nik/{nik}")
    @Operation(summary = "Get pasien by NIK")
    public ResponseEntity<ApiResponse<PasienResponse>> getPasienByNik(@PathVariable String nik) {
        PasienResponse response = pasienService.getPasienByNik(nik);
        return ResponseEntity.ok(ApiResponse.ok(response, "Pasien retrieved successfully"));
    }
    
    @GetMapping("/no-rm/{noRm}")
    @Operation(summary = "Get pasien by No. RM")
    public ResponseEntity<ApiResponse<PasienResponse>> getPasienByNoRm(@PathVariable String noRm) {
        PasienResponse response = pasienService.getPasienByNoRm(noRm);
        return ResponseEntity.ok(ApiResponse.ok(response, "Pasien retrieved successfully"));
    }
    
    @GetMapping
    @Operation(summary = "Get all pasien (pageable)")
    public ResponseEntity<ApiResponse<Page<PasienResponse>>> getAllPasien(Pageable pageable) {
        Page<PasienResponse> response = pasienService.getAllPasien(pageable);
        return ResponseEntity.ok(ApiResponse.ok(response, "Pasien list retrieved successfully"));
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Update pasien data")
    public ResponseEntity<ApiResponse<PasienResponse>> updatePasien(
            @PathVariable UUID id,
            @Valid @RequestBody UpdatePasienRequest request) {
        PasienResponse response = pasienService.updatePasien(id, request);
        return ResponseEntity.ok(ApiResponse.ok(response, "Pasien updated successfully"));
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete pasien")
    public ResponseEntity<ApiResponse<Void>> deletePasien(@PathVariable UUID id) {
        pasienService.deletePasien(id);
        return ResponseEntity.ok(ApiResponse.ok(null, "Pasien deleted successfully"));
    }
}
