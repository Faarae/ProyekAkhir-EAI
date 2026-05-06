-- Flyway Migration V1__init_schema.sql for Payment Service

CREATE TABLE IF NOT EXISTS invoice (
    id UUID PRIMARY KEY,
    nomor_invoice VARCHAR(30) UNIQUE NOT NULL,
    pasien_id UUID NOT NULL,
    pemeriksaan_id UUID,
    biaya_konsultasi DECIMAL(12,2) DEFAULT 0,
    biaya_tindakan DECIMAL(12,2) DEFAULT 0,
    biaya_obat DECIMAL(12,2) DEFAULT 0,
    subtotal DECIMAL(12,2),
    diskon_asuransi DECIMAL(12,2) DEFAULT 0,
    pajak DECIMAL(12,2) DEFAULT 0,
    total_akhir DECIMAL(12,2),
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transaksi (
    id UUID PRIMARY KEY,
    invoice_id UUID NOT NULL REFERENCES invoice(id) ON DELETE CASCADE,
    metode_pembayaran VARCHAR(20) NOT NULL,
    jumlah_bayar DECIMAL(12,2),
    kembalian DECIMAL(12,2) DEFAULT 0,
    referensi_gateway VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS laporan_keuangan (
    id UUID PRIMARY KEY,
    periode VARCHAR(7) NOT NULL,
    total_pendapatan DECIMAL(12,2),
    total_transaksi INTEGER,
    total_pasien INTEGER,
    generated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_invoice_nomor ON invoice(nomor_invoice);
CREATE INDEX idx_invoice_pasien ON invoice(pasien_id);
CREATE INDEX idx_invoice_status ON invoice(status);
CREATE INDEX idx_transaksi_invoice ON transaksi(invoice_id);
CREATE INDEX idx_laporan_periode ON laporan_keuangan(periode);
