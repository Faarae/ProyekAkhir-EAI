package com.rsususumatera.admin.service;

import com.rsususumatera.admin.dto.request.CreatePasienRequest;
import com.rsususumatera.admin.dto.request.UpdatePasienRequest;
import com.rsususumatera.admin.dto.response.PasienResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.util.UUID;

public interface PasienService {
    PasienResponse createPasien(CreatePasienRequest request);
    PasienResponse getPasienById(UUID id);
    PasienResponse getPasienByNik(String nik);
    PasienResponse getPasienByNoRm(String noRm);
    Page<PasienResponse> getAllPasien(Pageable pageable);
    PasienResponse updatePasien(UUID id, UpdatePasienRequest request);
    void deletePasien(UUID id);
}
