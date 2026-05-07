-- Flyway Migration V1__init_schema.sql for Payment Service

CREATE TABLE IF NOT EXISTS invoice (
    id CHAR(36) PRIMARY KEY COMMENT 'Invoice ID (UUID)',
    nomor_invoice VARCHAR(30) UNIQUE NOT NULL COMMENT 'Invoice number (INV-YYYYMMDD-XXXXX)',
    pasien_id CHAR(36) NOT NULL COMMENT 'Patient ID',
    pemeriksaan_id CHAR(36) NULL COMMENT 'Examination ID',
    biaya_konsultasi DECIMAL(12,2) DEFAULT 0 COMMENT 'Consultation fee',
    biaya_tindakan DECIMAL(12,2) DEFAULT 0 COMMENT 'Action fee',
    biaya_obat DECIMAL(12,2) DEFAULT 0 COMMENT 'Medicine fee',
    subtotal DECIMAL(12,2) NULL COMMENT 'Subtotal',
    diskon_asuransi DECIMAL(12,2) DEFAULT 0 COMMENT 'Insurance discount',
    pajak DECIMAL(12,2) DEFAULT 0 COMMENT 'Tax (11% PPN)',
    total_akhir DECIMAL(12,2) NULL COMMENT 'Final total',
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT' COMMENT 'Status: DRAFT, UNPAID, PAID, CANCELLED',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp',
    KEY idx_invoice_nomor (nomor_invoice),
    KEY idx_invoice_pasien (pasien_id),
    KEY idx_invoice_status (status)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Invoice table';

CREATE TABLE IF NOT EXISTS transaksi (
    id CHAR(36) PRIMARY KEY COMMENT 'Transaction ID (UUID)',
    invoice_id CHAR(36) NOT NULL COMMENT 'Invoice ID (FK to invoice)',
    metode_pembayaran VARCHAR(20) NOT NULL COMMENT 'Payment method: TUNAI, DEBIT, QRIS',
    jumlah_bayar DECIMAL(12,2) NULL COMMENT 'Amount paid',
    kembalian DECIMAL(12,2) DEFAULT 0 COMMENT 'Change',
    referensi_gateway VARCHAR(100) NULL COMMENT 'Gateway transaction ID',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT 'Status: PENDING, SUCCESS, FAILED',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    FOREIGN KEY (invoice_id) REFERENCES invoice(id) ON DELETE CASCADE,
    KEY idx_transaksi_invoice (invoice_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Transaction table';

CREATE TABLE IF NOT EXISTS laporan_keuangan (
    id CHAR(36) PRIMARY KEY COMMENT 'Report ID (UUID)',
    periode VARCHAR(7) NOT NULL COMMENT 'Period (YYYY-MM)',
    total_pendapatan DECIMAL(12,2) NULL COMMENT 'Total revenue',
    total_transaksi INTEGER NULL COMMENT 'Total transactions',
    total_pasien INTEGER NULL COMMENT 'Total patients',
    generated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Generation timestamp',
    KEY idx_laporan_periode (periode)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Financial report table';
