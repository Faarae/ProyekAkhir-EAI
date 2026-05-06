-- Flyway Migration V1__init_schema.sql
-- Initial schema for Admin Service

CREATE TABLE IF NOT EXISTS users (
    id CHAR(36) PRIMARY KEY COMMENT 'User ID (UUID)',
    username VARCHAR(50) UNIQUE NOT NULL COMMENT 'Username for login',
    password VARCHAR(255) NOT NULL COMMENT 'Hashed password',
    nama_lengkap VARCHAR(100) NOT NULL COMMENT 'Full name',
    role VARCHAR(20) NOT NULL COMMENT 'User role: ADMIN, DOKTER, APOTEKER',
    poliklinik_id CHAR(36) NULL COMMENT 'Associated clinic ID',
    is_active TINYINT(1) DEFAULT 1 COMMENT 'Account active status',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User accounts table';

CREATE TABLE IF NOT EXISTS pasien (
    id CHAR(36) PRIMARY KEY COMMENT 'Patient ID (UUID)',
    nik VARCHAR(16) UNIQUE NOT NULL COMMENT 'National ID (NIK)',
    nama VARCHAR(100) NOT NULL COMMENT 'Patient full name',
    no_rm VARCHAR(20) UNIQUE NOT NULL COMMENT 'Medical record number (RM)',
    tanggal_lahir DATE NULL COMMENT 'Date of birth',
    jenis_kelamin VARCHAR(20) NULL COMMENT 'Gender: LAKI_LAKI, PEREMPUAN',
    alamat VARCHAR(255) NULL COMMENT 'Address',
    no_telp VARCHAR(15) NULL COMMENT 'Phone number',
    status_bpjs TINYINT(1) DEFAULT 0 COMMENT 'BPJS insurance status',
    no_bpjs VARCHAR(20) NULL COMMENT 'BPJS number',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Patient data table';

CREATE TABLE IF NOT EXISTS poliklinik (
    id CHAR(36) PRIMARY KEY COMMENT 'Clinic ID (UUID)',
    nama VARCHAR(100) NOT NULL COMMENT 'Clinic name',
    lantai INTEGER NOT NULL COMMENT 'Floor number',
    is_active TINYINT(1) DEFAULT 1 COMMENT 'Clinic active status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Clinic/Department table';

CREATE TABLE IF NOT EXISTS jadwal_dokter (
    id CHAR(36) PRIMARY KEY COMMENT 'Schedule ID (UUID)',
    dokter_id CHAR(36) NOT NULL COMMENT 'Doctor ID (FK to users)',
    poliklinik_id CHAR(36) NOT NULL COMMENT 'Clinic ID (FK to poliklinik)',
    hari VARCHAR(20) NOT NULL COMMENT 'Day of week: SENIN, SELASA, RABU, KAMIS, JUMAT, SABTU',
    jam_mulai TIME NOT NULL COMMENT 'Schedule start time',
    jam_selesai TIME NOT NULL COMMENT 'Schedule end time',
    kuota_pasien INTEGER DEFAULT 20 COMMENT 'Patient quota per day',
    is_active TINYINT(1) DEFAULT 1 COMMENT 'Schedule active status',
    FOREIGN KEY (poliklinik_id) REFERENCES poliklinik(id),
    KEY idx_dokter_id (dokter_id),
    KEY idx_poliklinik_id (poliklinik_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Doctor schedule table';

CREATE TABLE IF NOT EXISTS antrean (
    id CHAR(36) PRIMARY KEY COMMENT 'Queue ID (UUID)',
    pasien_id CHAR(36) NOT NULL COMMENT 'Patient ID (FK to pasien)',
    jadwal_id CHAR(36) NOT NULL COMMENT 'Schedule ID (FK to jadwal_dokter)',
    nomor_antrean INTEGER NOT NULL COMMENT 'Queue number',
    tanggal DATE NOT NULL COMMENT 'Queue date',
    status VARCHAR(20) NOT NULL DEFAULT 'MENUNGGU' COMMENT 'Queue status: MENUNGGU, DIPANGGIL, SELESAI, BATAL',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp',
    FOREIGN KEY (pasien_id) REFERENCES pasien(id),
    FOREIGN KEY (jadwal_id) REFERENCES jadwal_dokter(id),
    KEY idx_pasien_id (pasien_id),
    KEY idx_jadwal_id (jadwal_id),
    KEY idx_tanggal (tanggal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Patient queue table';