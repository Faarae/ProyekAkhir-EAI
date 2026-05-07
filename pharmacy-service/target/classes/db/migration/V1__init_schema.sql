-- Flyway Migration V1__init_schema.sql for Pharmacy Service

CREATE TABLE IF NOT EXISTS obat (
    id CHAR(36) PRIMARY KEY COMMENT 'Medicine ID (UUID)',
    kode_obat VARCHAR(20) UNIQUE NOT NULL COMMENT 'Medicine code (OBT-XXXXX)',
    nama VARCHAR(100) NOT NULL COMMENT 'Medicine name',
    jenis_obat VARCHAR(20) NOT NULL COMMENT 'Medicine type: GENERIK, PATEN, HERBAL',
    satuan VARCHAR(20) NULL COMMENT 'Unit (Tablet, Kapsul, ml)',
    harga_satuan DECIMAL(12,2) NULL COMMENT 'Unit price',
    min_stok INTEGER DEFAULT 10 COMMENT 'Minimum stock level',
    is_active TINYINT(1) DEFAULT 1 COMMENT 'Active status',
    KEY idx_obat_kode (kode_obat)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Medicine table';

CREATE TABLE IF NOT EXISTS stok (
    id CHAR(36) PRIMARY KEY COMMENT 'Stock ID (UUID)',
    obat_id CHAR(36) NOT NULL COMMENT 'Medicine ID (FK to obat)',
    jumlah INTEGER NOT NULL COMMENT 'Quantity',
    lokasi_rak VARCHAR(20) NULL COMMENT 'Shelf location',
    tanggal_kadaluarsa DATE NULL COMMENT 'Expiration date',
    no_batch VARCHAR(50) NULL COMMENT 'Batch number',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp',
    FOREIGN KEY (obat_id) REFERENCES obat(id) ON DELETE CASCADE,
    KEY idx_stok_obat (obat_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Stock table';

CREATE TABLE IF NOT EXISTS supplier (
    id CHAR(36) PRIMARY KEY COMMENT 'Supplier ID (UUID)',
    nama VARCHAR(100) NOT NULL COMMENT 'Supplier name',
    kontak VARCHAR(15) NULL COMMENT 'Contact number',
    email VARCHAR(100) NULL COMMENT 'Email address',
    alamat VARCHAR(255) NULL COMMENT 'Address',
    is_active TINYINT(1) DEFAULT 1 COMMENT 'Active status'
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci 
COMMENT='Supplier table';

CREATE TABLE IF NOT EXISTS pesanan_obat (
    id CHAR(36) PRIMARY KEY COMMENT 'Purchase order ID (UUID)',
    supplier_id CHAR(36) NOT NULL COMMENT 'Supplier ID (FK to supplier)',
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT' COMMENT 'Status: DRAFT, DIKIRIM, DITERIMA, DIBATALKAN',
    total_harga DECIMAL(12,2) NULL COMMENT 'Total price',
    catatan TEXT NULL COMMENT 'Notes',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update timestamp',
    FOREIGN KEY (supplier_id) REFERENCES supplier(id) ON DELETE CASCADE,
    KEY idx_pesanan_supplier (supplier_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Purchase order table';

CREATE TABLE IF NOT EXISTS pesanan_obat_detail (
    id CHAR(36) PRIMARY KEY COMMENT 'Purchase order detail ID (UUID)',
    pesanan_id CHAR(36) NOT NULL COMMENT 'Purchase order ID (FK to pesanan_obat)',
    obat_id CHAR(36) NOT NULL COMMENT 'Medicine ID (FK to obat)',
    jumlah INTEGER NOT NULL COMMENT 'Quantity',
    harga_satuan DECIMAL(12,2) NULL COMMENT 'Unit price',
    subtotal DECIMAL(12,2) NULL COMMENT 'Subtotal',
    FOREIGN KEY (pesanan_id) REFERENCES pesanan_obat(id) ON DELETE CASCADE,
    FOREIGN KEY (obat_id) REFERENCES obat(id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Purchase order details table';

CREATE TABLE IF NOT EXISTS dispensing_resep (
    id CHAR(36) PRIMARY KEY COMMENT 'Dispensing ID (UUID)',
    resep_id CHAR(36) NOT NULL COMMENT 'Prescription ID (external)',
    pasien_id CHAR(36) NOT NULL COMMENT 'Patient ID',
    status VARCHAR(20) NOT NULL DEFAULT 'MENUNGGU' COMMENT 'Status: MENUNGGU, DIVALIDASI, DISIAPKAN, DISERAHKAN, DITOLAK',
    total_harga DECIMAL(12,2) NULL COMMENT 'Total price',
    catatan_farmasist VARCHAR(255) NULL COMMENT 'Pharmacist notes',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation timestamp',
    KEY idx_dispensing_resep (resep_id),
    KEY idx_dispensing_pasien (pasien_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
COMMENT='Prescription dispensing tracking table';
