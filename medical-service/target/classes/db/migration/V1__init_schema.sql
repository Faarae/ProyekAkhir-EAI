-- Flyway Migration V1__init_schema.sql for Medical Service

CREATE TABLE IF NOT EXISTS pemeriksaan (
    id CHAR(36) PRIMARY KEY COMMENT 'Examination ID (UUID)',
    pasien_id CHAR(36) NOT NULL COMMENT 'Patient ID',
    dokter_id CHAR(36) NOT NULL COMMENT 'Doctor ID',
    antrean_id CHAR(36) NULL COMMENT 'Queue ID',
    tanggal DATE NOT NULL COMMENT 'Examination date',
    tekanan_darah VARCHAR(20) NULL COMMENT 'Blood pressure (e.g. 120/80)',
    berat_badan DECIMAL(5,2) NULL COMMENT 'Weight in kg',
    tinggi_badan DECIMAL(5,2) NULL COMMENT 'Height in cm',
    suhu_tubuh DECIMAL(5,2) NULL COMMENT 'Body temperature in celsius',
    keluhan_utama TEXT NULL COMMENT 'Main complaint',
    catatan_dokter TEXT NULL COMMENT 'Doctor notes',
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT' COMMENT 'Status: DRAFT, SELESAI',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp',
    KEY idx_pemeriksaan_pasien (pasien_id),
    KEY idx_pemeriksaan_dokter (dokter_id),
    KEY idx_pemeriksaan_tanggal (tanggal),
    ENGINE=InnoDB,
    DEFAULT CHARSET=utf8mb4,
    COLLATE=utf8mb4_unicode_ci
) COMMENT='Medical examination table';

CREATE TABLE IF NOT EXISTS diagnosa (
    id CHAR(36) PRIMARY KEY COMMENT 'Diagnosis ID (UUID)',
    pemeriksaan_id CHAR(36) NOT NULL COMMENT 'Examination ID (FK to pemeriksaan)',
    kode_icd10 VARCHAR(10) NOT NULL COMMENT 'ICD-10 code',
    deskripsi VARCHAR(255) NULL COMMENT 'Diagnosis description',
    is_primer TINYINT(1) DEFAULT 0 COMMENT 'Primary diagnosis flag',
    FOREIGN KEY (pemeriksaan_id) REFERENCES pemeriksaan(id) ON DELETE CASCADE,
    ENGINE=InnoDB,
    DEFAULT CHARSET=utf8mb4,
    COLLATE=utf8mb4_unicode_ci
) COMMENT='Diagnosis table';

CREATE TABLE IF NOT EXISTS tindakan (
    id CHAR(36) PRIMARY KEY COMMENT 'Action ID (UUID)',
    pemeriksaan_id CHAR(36) NOT NULL COMMENT 'Examination ID (FK to pemeriksaan)',
    nama_tindakan VARCHAR(100) NOT NULL COMMENT 'Action name',
    biaya DECIMAL(12,2) NULL COMMENT 'Cost',
    keterangan VARCHAR(255) NULL COMMENT 'Notes',
    FOREIGN KEY (pemeriksaan_id) REFERENCES pemeriksaan(id) ON DELETE CASCADE,
    ENGINE=InnoDB,
    DEFAULT CHARSET=utf8mb4,
    COLLATE=utf8mb4_unicode_ci
) COMMENT='Medical actions table';

CREATE TABLE IF NOT EXISTS resep (
    id CHAR(36) PRIMARY KEY COMMENT 'Prescription ID (UUID)',
    pemeriksaan_id CHAR(36) NOT NULL COMMENT 'Examination ID (FK to pemeriksaan)',
    dokter_id CHAR(36) NOT NULL COMMENT 'Doctor ID',
    pasien_id CHAR(36) NOT NULL COMMENT 'Patient ID',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT 'Status: PENDING, DIPROSES, SELESAI, DITOLAK',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp',
    FOREIGN KEY (pemeriksaan_id) REFERENCES pemeriksaan(id) ON DELETE CASCADE,
    KEY idx_resep_pasien (pasien_id),
    ENGINE=InnoDB,
    DEFAULT CHARSET=utf8mb4,
    COLLATE=utf8mb4_unicode_ci
) COMMENT='Prescription table';

CREATE TABLE IF NOT EXISTS resep_detail (
    id CHAR(36) PRIMARY KEY COMMENT 'Prescription detail ID (UUID)',
    resep_id CHAR(36) NOT NULL COMMENT 'Prescription ID (FK to resep)',
    nama_obat VARCHAR(100) NOT NULL COMMENT 'Medicine name',
    dosis VARCHAR(50) NULL COMMENT 'Dosage',
    frekuensi VARCHAR(50) NULL COMMENT 'Frequency',
    jumlah INTEGER NULL COMMENT 'Quantity',
    keterangan VARCHAR(255) NULL COMMENT 'Notes',
    FOREIGN KEY (resep_id) REFERENCES resep(id) ON DELETE CASCADE,
    ENGINE=InnoDB,
    DEFAULT CHARSET=utf8mb4,
    COLLATE=utf8mb4_unicode_ci
) COMMENT='Prescription details table';
