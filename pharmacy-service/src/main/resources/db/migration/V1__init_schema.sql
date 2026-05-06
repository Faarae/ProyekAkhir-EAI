-- Flyway Migration V1__init_schema.sql for Pharmacy Service

CREATE TABLE IF NOT EXISTS obat (
    id UUID PRIMARY KEY,
    kode_obat VARCHAR(20) UNIQUE NOT NULL,
    nama VARCHAR(100) NOT NULL,
    jenis_obat VARCHAR(20) NOT NULL,
    satuan VARCHAR(20),
    harga_satuan DECIMAL(12,2),
    min_stok INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS stok (
    id UUID PRIMARY KEY,
    obat_id UUID NOT NULL REFERENCES obat(id) ON DELETE CASCADE,
    jumlah INTEGER NOT NULL,
    lokasi_rak VARCHAR(20),
    tanggal_kadaluarsa DATE,
    no_batch VARCHAR(50),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS supplier (
    id UUID PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    kontak VARCHAR(15),
    email VARCHAR(100),
    alamat VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS pesanan_obat (
    id UUID PRIMARY KEY,
    supplier_id UUID NOT NULL REFERENCES supplier(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    total_harga DECIMAL(12,2),
    catatan TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pesanan_obat_detail (
    id UUID PRIMARY KEY,
    pesanan_id UUID NOT NULL REFERENCES pesanan_obat(id) ON DELETE CASCADE,
    obat_id UUID NOT NULL REFERENCES obat(id),
    jumlah INTEGER NOT NULL,
    harga_satuan DECIMAL(12,2),
    subtotal DECIMAL(12,2)
);

CREATE TABLE IF NOT EXISTS dispensing_resep (
    id UUID PRIMARY KEY,
    resep_id UUID NOT NULL,
    pasien_id UUID NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'MENUNGGU',
    total_harga DECIMAL(12,2),
    catatan_farmasist VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_obat_kode ON obat(kode_obat);
CREATE INDEX idx_stok_obat ON stok(obat_id);
CREATE INDEX idx_pesanan_supplier ON pesanan_obat(supplier_id);
CREATE INDEX idx_dispensing_resep ON dispensing_resep(resep_id);
CREATE INDEX idx_dispensing_pasien ON dispensing_resep(pasien_id);
