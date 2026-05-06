-- Flyway Migration V1__init_schema.sql
-- Initial schema for Admin Service

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    poliklinik_id UUID,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pasien (
    id UUID PRIMARY KEY,
    nik VARCHAR(16) UNIQUE NOT NULL,
    nama VARCHAR(100) NOT NULL,
    no_rm VARCHAR(20) UNIQUE NOT NULL,
    tanggal_lahir DATE,
    jenis_kelamin VARCHAR(20),
    alamat VARCHAR(255),
    no_telp VARCHAR(15),
    status_bpjs BOOLEAN DEFAULT FALSE,
    no_bpjs VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS poliklinik (
    id UUID PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    lantai INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS jadwal_dokter (
    id UUID PRIMARY KEY,
    dokter_id UUID NOT NULL,
    poliklinik_id UUID NOT NULL,
    hari VARCHAR(20) NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    kuota_pasien INTEGER DEFAULT 20,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (poliklinik_id) REFERENCES poliklinik(id)
);

CREATE TABLE IF NOT EXISTS antrean (
    id UUID PRIMARY KEY,
    pasien_id UUID NOT NULL,
    jadwal_id UUID NOT NULL,
    nomor_antrean INTEGER NOT NULL,
    tanggal DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'MENUNGGU',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (pasien_id) REFERENCES pasien(id),
    FOREIGN KEY (jadwal_id) REFERENCES jadwal_dokter(id)
);

-- Create indexes
CREATE INDEX idx_nik ON pasien(nik);
CREATE INDEX idx_no_rm ON pasien(no_rm);
CREATE INDEX idx_dokter_id ON jadwal_dokter(dokter_id);
CREATE INDEX idx_poliklinik_id ON jadwal_dokter(poliklinik_id);
CREATE INDEX idx_pasien_id ON antrean(pasien_id);
CREATE INDEX idx_jadwal_id ON antrean(jadwal_id);
CREATE INDEX idx_tanggal ON antrean(tanggal);
