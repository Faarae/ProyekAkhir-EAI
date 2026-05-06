package com.rsususumatera.admin.service;

import com.rsususumatera.admin.dto.request.LoginRequest;
import com.rsususumatera.admin.dto.response.LoginResponse;

public interface AuthService {
    LoginResponse login(LoginRequest request);
}
