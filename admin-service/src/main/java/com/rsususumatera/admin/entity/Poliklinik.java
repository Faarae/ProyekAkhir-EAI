package com.rsususumatera.admin.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.UUID;

@Entity
@Table(name = "poliklinik")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Poliklinik {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(nullable = false, length = 100)
    private String nama;
    
    @Column(nullable = false)
    private Integer lantai;
    
    @Column(nullable = false)
    private Boolean isActive = true;
}
