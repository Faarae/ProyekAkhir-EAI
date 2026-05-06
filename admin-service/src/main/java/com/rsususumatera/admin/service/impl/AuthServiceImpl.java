package com.rsususumatera.admin.service.impl;

import com.rsususumatera.admin.dto.request.LoginRequest;
import com.rsususumatera.admin.dto.response.LoginResponse;
import com.rsususumatera.admin.entity.User;
import com.rsususumatera.admin.exception.ResourceNotFoundException;
import com.rsususumatera.admin.repository.UserRepository;
import com.rsususumatera.admin.security.JwtUtil;
import com.rsususumatera.admin.service.AuthService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuthServiceImpl implements AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    
    @Override
    public LoginResponse login(LoginRequest request) {
        log.info("User login attempt: {}", request.getUsername());
        
        User user = userRepository.findByUsernameAndIsActiveTrue(request.getUsername())
            .orElseThrow(() -> new ResourceNotFoundException("User tidak ditemukan atau tidak aktif"));
        
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Username atau password salah");
        }
        
        String token = jwtUtil.generateToken(user.getUsername(), user.getRole().toString());
        long expiresIn = jwtUtil.getExpirationTime();
        
        log.info("User logged in successfully: {}", request.getUsername());
        
        return LoginResponse.builder()
            .token(token)
            .username(user.getUsername())
            .namaLengkap(user.getNamaLengkap())
            .role(user.getRole().toString())
            .expiresIn(expiresIn)
            .build();
    }
}
