package com.rsususumatera.admin.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import javax.crypto.SecretKey;
import java.util.Date;

@Component
@Slf4j
public class JwtUtil {
    
    @Value("${jwt.secret:rsu-sumatera-secret-key-2026-admin-service}")
    private String jwtSecret;
    
    @Value("${jwt.expiration:86400000}")
    private long jwtExpiration;
    
    public String generateToken(String username, String role) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpiration);
        
        SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
        
        return Jwts.builder()
            .subject(username)
            .claim("role", role)
            .issuedAt(now)
            .expiration(expiryDate)
            .signWith(key, SignatureAlgorithm.HS512)
            .compact();
    }
    
    public String getUsernameFromToken(String token) {
        try {
            SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
            Claims claims = Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
            return claims.getSubject();
        } catch (Exception e) {
            log.error("Error getting username from token", e);
            return null;
        }
    }
    
    public String getRoleFromToken(String token) {
        try {
            SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
            Claims claims = Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
            return claims.get("role", String.class);
        } catch (Exception e) {
            log.error("Error getting role from token", e);
            return null;
        }
    }
    
    public boolean validateToken(String token) {
        try {
            SecretKey key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
            Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token);
            return true;
        } catch (Exception e) {
            log.error("Token validation failed", e);
            return false;
        }
    }
    
    public long getExpirationTime() {
        return jwtExpiration;
    }
}
