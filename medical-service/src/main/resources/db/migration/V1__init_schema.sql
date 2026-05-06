-- Flyway Migration V1__init_schema.sql for Medical Service

CREATE TABLE IF NOT EXISTS pemeriksaan (
    id UUID PRIMARY KEY,
    pasien_id UUID NOT NULL,
    dokter_id UUID NOT NULL,
    antrean_id UUID,
    tanggal DATE NOT NULL,
    tekanan_darah VARCHAR(20),
    berat_badan DECIMAL(5,2),
    tinggi_badan DECIMAL(5,2),
    suhu_tubuh DECIMAL(5,2),
    keluhan_utama TEXT,
    catatan_dokter TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS diagnosa (
    id UUID PRIMARY KEY,
    pemeriksaan_id UUID NOT NULL REFERENCES pemeriksaan(id) ON DELETE CASCADE,
    kode_icd10 VARCHAR(10) NOT NULL,
    deskripsi VARCHAR(255),
    is_primer BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS tindakan (
    id UUID PRIMARY KEY,
    pemeriksaan_id UUID NOT NULL REFERENCES pemeriksaan(id) ON DELETE CASCADE,
    nama_tindakan VARCHAR(100) NOT NULL,
    biaya DECIMAL(12,2),
    keterangan VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS resep (
    id UUID PRIMARY KEY,
    pemeriksaan_id UUID NOT NULL REFERENCES pemeriksaan(id) ON DELETE CASCADE,
    dokter_id UUID NOT NULL,
    pasien_id UUID NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS resep_detail (
    id UUID PRIMARY KEY,
    resep_id UUID NOT NULL REFERENCES resep(id) ON DELETE CASCADE,
    nama_obat VARCHAR(100) NOT NULL,
    dosis VARCHAR(50),
    frekuensi VARCHAR(50),
    jumlah INTEGER,
    keterangan VARCHAR(255)
);

CREATE INDEX idx_pemeriksaan_pasien ON pemeriksaan(pasien_id);
CREATE INDEX idx_pemeriksaan_dokter ON pemeriksaan(dokter_id);
CREATE INDEX idx_pemeriksaan_tanggal ON pemeriksaan(tanggal);
CREATE INDEX idx_resep_pemeriksaan ON resep(pemeriksaan_id);
CREATE INDEX idx_resep_pasien ON resep(pasien_id);
