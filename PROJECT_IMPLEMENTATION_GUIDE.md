# 🏥 RSU SUMATERA - SISTEM INFORMASI MANAJEMEN RUMAH SAKIT
## Full Spring Boot Microservice Implementation

**Status:** ✅ Admin Service Selesai | 🔧 Dalam Progress: Medical, Pharmacy, Payment Services

---

## 📋 RINGKASAN STRUKTUR PROYEK

```
ProyekAkhir-EAI/
├── admin-service/
│   ├── src/
│   │   ├── main/java/com/rsususumatera/admin/
│   │   │   ├── AdminServiceApplication.java ✅
│   │   │   ├── config/
│   │   │   │   ├── SecurityConfig.java ✅
│   │   │   │   ├── RabbitMQConfig.java ✅
│   │   │   │   └── OpenAPIConfig.java ✅
│   │   │   ├── entity/
│   │   │   │   ├── User.java ✅
│   │   │   │   ├── Pasien.java ✅
│   │   │   │   ├── Poliklinik.java ✅
│   │   │   │   ├── JadwalDokter.java ✅
│   │   │   │   └── Antrean.java ✅
│   │   │   ├── repository/
│   │   │   │   ├── PasienRepository.java ✅
│   │   │   │   ├── UserRepository.java ✅
│   │   │   │   ├── PoliklinikRepository.java ✅
│   │   │   │   ├── JadwalDokterRepository.java ✅
│   │   │   │   └── AntreanRepository.java ✅
│   │   │   ├── service/
│   │   │   │   ├── PasienService.java ✅
│   │   │   │   ├── AuthService.java ✅
│   │   │   │   └── impl/
│   │   │   │       ├── PasienServiceImpl.java ✅
│   │   │   │       └── AuthServiceImpl.java ✅
│   │   │   ├── controller/
│   │   │   │   ├── PasienController.java ✅
│   │   │   │   └── AuthController.java ✅
│   │   │   ├── dto/
│   │   │   │   ├── request/
│   │   │   │   │   ├── CreatePasienRequest.java ✅
│   │   │   │   │   ├── UpdatePasienRequest.java ✅
│   │   │   │   │   └── LoginRequest.java ✅
│   │   │   │   └── response/
│   │   │   │       ├── ApiResponse.java ✅
│   │   │   │       ├── PasienResponse.java ✅
│   │   │   │       └── LoginResponse.java ✅
│   │   │   ├── exception/
│   │   │   │   ├── ResourceNotFoundException.java ✅
│   │   │   │   ├── BusinessException.java ✅
│   │   │   │   └── GlobalExceptionHandler.java ✅
│   │   │   ├── security/
│   │   │   │   ├── JwtUtil.java ✅
│   │   │   │   └── JwtAuthenticationFilter.java ✅
│   │   │   └── event/
│   │   │       ├── PasienTerdaftarEvent.java ✅
│   │   │       └── publisher/
│   │   │           └── PasienEventPublisher.java ✅
│   │   ├── resources/
│   │   │   ├── application.yml ✅
│   │   │   └── db/migration/
│   │   │       └── V1__init_schema.sql ✅
│   │   └── test/
│   │       └── java/.../service/PasienServiceTest.java ✅
│   ├── Dockerfile ✅
│   └── pom.xml ✅
│
├── medical-service/ (SEDANG DIKERJAKAN)
├── pharmacy-service/ (SEDANG DIKERJAKAN)
├── payment-service/ (SEDANG DIKERJAKAN)
│
├── docker-compose.yml (AKAN DIBUAT)
└── init-db.sql (AKAN DIBUAT)
```

---

## ✅ ADMIN SERVICE - SELESAI

### Fitur Utama:
- ✅ Autentikasi JWT
- ✅ Manajemen Pasien (CRUD)
- ✅ Manajemen User & Role
- ✅ Penjadwalan Dokter & Poliklinik
- ✅ Sistem Antrean Pasien
- ✅ Event Publishing (RabbitMQ)
- ✅ Security Config
- ✅ Swagger/OpenAPI Documentation
- ✅ Error Handling Global
- ✅ Database Migration (Flyway)
- ✅ Unit Tests

### API Endpoints:
```
Authentication:
  POST   /api/v1/auth/login

Pasien Management:
  POST   /api/v1/pasien                    (Create)
  GET    /api/v1/pasien                    (List dengan pageable)
  GET    /api/v1/pasien/{id}               (Get by ID)
  GET    /api/v1/pasien/nik/{nik}          (Get by NIK)
  PUT    /api/v1/pasien/{id}               (Update)
  DELETE /api/v1/pasien/{id}               (Delete)

Documentation:
  GET    /swagger-ui.html                  (Swagger UI)
  GET    /api-docs                         (OpenAPI Docs)
```

---

## 🔧 MEDICAL SERVICE - BLUEPRINT (Siap Dikerjakan)

### Entitas:
- `Pemeriksaan` - Rekam medis elektronik (EMR)
- `Diagnosa` - Diagnosis berdasarkan ICD-10
- `Tindakan` - Prosedur medis
- `Resep` - Prescription elektronik
- `ResepDetail` - Detail items dalam resep

### API yang akan dibuat:
```
POST   /api/v1/pemeriksaan
GET    /api/v1/pemeriksaan/{id}
GET    /api/v1/pemeriksaan/pasien/{pasienId}
PUT    /api/v1/pemeriksaan/{id}/selesai

POST   /api/v1/resep
GET    /api/v1/resep/{id}
PUT    /api/v1/resep/{id}/status

Event:
- resep.diterbitkan → Pharmacy Service
- tindakan.dicatat → Payment Service
```

### Database Schema:
```sql
-- Pemeriksaan (Medical Records)
CREATE TABLE pemeriksaan (
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
  status ENUM('DRAFT', 'SELESAI'),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Diagnosa (ICD-10 Codes)
CREATE TABLE diagnosa (
  id UUID PRIMARY KEY,
  pemeriksaan_id UUID NOT NULL REFERENCES pemeriksaan(id),
  kode_icd10 VARCHAR(10) NOT NULL,
  deskripsi VARCHAR(255),
  is_primer BOOLEAN DEFAULT FALSE
);

-- Tindakan (Medical Procedures)
CREATE TABLE tindakan (
  id UUID PRIMARY KEY,
  pemeriksaan_id UUID NOT NULL REFERENCES pemeriksaan(id),
  nama_tindakan VARCHAR(100) NOT NULL,
  biaya DECIMAL(12,2),
  keterangan VARCHAR(255)
);

-- Resep (E-Prescription)
CREATE TABLE resep (
  id UUID PRIMARY KEY,
  pemeriksaan_id UUID NOT NULL REFERENCES pemeriksaan(id),
  dokter_id UUID NOT NULL,
  pasien_id UUID NOT NULL,
  status ENUM('PENDING', 'DIPROSES', 'SELESAI', 'DITOLAK'),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- Resep Detail (Prescription Items)
CREATE TABLE resep_detail (
  id UUID PRIMARY KEY,
  resep_id UUID NOT NULL REFERENCES resep(id),
  nama_obat VARCHAR(100) NOT NULL,
  dosis VARCHAR(50),
  frekuensi VARCHAR(50),
  jumlah INTEGER,
  keterangan VARCHAR(255)
);
```

---

## 🔧 PHARMACY SERVICE - BLUEPRINT (Siap Dikerjakan)

### Entitas:
- `Obat` - Master data obat
- `Stok` - Inventory management
- `Supplier` - Vendor management
- `PesananObat` - Purchase order
- `DispensingResep` - Tracking resep yang diproses

### Database Schema:
```sql
CREATE TABLE obat (
  id UUID PRIMARY KEY,
  kode_obat VARCHAR(20) UNIQUE NOT NULL,
  nama VARCHAR(100) NOT NULL,
  jenis_obat ENUM('GENERIK', 'PATEN', 'HERBAL'),
  satuan VARCHAR(20),
  harga_satuan DECIMAL(12,2),
  min_stok INTEGER DEFAULT 10,
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE stok (
  id UUID PRIMARY KEY,
  obat_id UUID NOT NULL REFERENCES obat(id),
  jumlah INTEGER NOT NULL,
  lokasi_rak VARCHAR(20),
  tanggal_kadaluarsa DATE,
  no_batch VARCHAR(50),
  updated_at TIMESTAMP
);

CREATE TABLE supplier (
  id UUID PRIMARY KEY,
  nama VARCHAR(100) NOT NULL,
  kontak VARCHAR(15),
  email VARCHAR(100),
  alamat VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE pesanan_obat (
  id UUID PRIMARY KEY,
  supplier_id UUID NOT NULL REFERENCES supplier(id),
  status ENUM('DRAFT', 'DIKIRIM', 'DITERIMA', 'DIBATALKAN'),
  total_harga DECIMAL(12,2),
  catatan TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE dispensing_resep (
  id UUID PRIMARY KEY,
  resep_id UUID NOT NULL,
  pasien_id UUID NOT NULL,
  status ENUM('MENUNGGU', 'DIVALIDASI', 'DISIAPKAN', 'DISERAHKAN', 'DITOLAK'),
  total_harga DECIMAL(12,2),
  catatan_farmasist VARCHAR(255),
  created_at TIMESTAMP
);
```

### API yang akan dibuat:
```
GET    /api/v1/obat
POST   /api/v1/obat
GET    /api/v1/obat/stok-menipis
GET    /api/v1/stok/{obatId}
POST   /api/v1/stok/masuk
POST   /api/v1/stok/keluar

GET    /api/v1/supplier
POST   /api/v1/supplier

GET    /api/v1/pesanan
POST   /api/v1/pesanan
PUT    /api/v1/pesanan/{id}/kirim
PUT    /api/v1/pesanan/{id}/terima

GET    /api/v1/dispensing
PUT    /api/v1/dispensing/{id}/validasi
PUT    /api/v1/dispensing/{id}/serahkan

Event Listeners:
- resep.diterbitkan ← Medical Service
```

---

## 💰 PAYMENT SERVICE - BLUEPRINT (Siap Dikerjakan)

### Entitas:
- `Invoice` - Billing & Invoice
- `Transaksi` - Payment transactions
- `LaporanKeuangan` - Financial reporting

### Database Schema:
```sql
CREATE TABLE invoice (
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
  status ENUM('DRAFT', 'UNPAID', 'PAID', 'CANCELLED'),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE transaksi (
  id UUID PRIMARY KEY,
  invoice_id UUID NOT NULL REFERENCES invoice(id),
  metode_pembayaran ENUM('TUNAI', 'DEBIT', 'QRIS'),
  jumlah_bayar DECIMAL(12,2),
  kembalian DECIMAL(12,2) DEFAULT 0,
  referensi_gateway VARCHAR(100),
  status ENUM('PENDING', 'SUCCESS', 'FAILED'),
  created_at TIMESTAMP
);

CREATE TABLE laporan_keuangan (
  id UUID PRIMARY KEY,
  periode VARCHAR(7),
  total_pendapatan DECIMAL(12,2),
  total_transaksi INTEGER,
  total_pasien INTEGER,
  generated_at TIMESTAMP
);
```

### API yang akan dibuat:
```
GET    /api/v1/invoice
GET    /api/v1/invoice/{id}
GET    /api/v1/invoice/pasien/{pasienId}
POST   /api/v1/invoice/generate/{pemeriksaanId}
PUT    /api/v1/invoice/{id}/cancel

POST   /api/v1/transaksi/bayar
GET    /api/v1/transaksi/{invoiceId}

GET    /api/v1/laporan/harian
GET    /api/v1/laporan/bulanan
POST   /api/v1/laporan/generate/{periode}

Event Listeners:
- tindakan.dicatat ← Medical Service
- obat.dispensed ← Pharmacy Service
```

---

## 🐳 DOCKER COMPOSE CONFIGURATION

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: postgres
    volumes:
      - ./init-db.sql:/docker-entrypoint-initdb.d/init.sql
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - rsu-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  rabbitmq:
    image: rabbitmq:3-management
    environment:
      RABBITMQ_DEFAULT_USER: guest
      RABBITMQ_DEFAULT_PASS: guest
    ports:
      - "5672:5672"
      - "15672:15672"
    networks:
      - rsu-network
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  admin-service:
    build:
      context: ./admin-service
      dockerfile: Dockerfile
    ports:
      - "8081:8081"
    environment:
      DB_USERNAME: postgres
      DB_PASSWORD: postgres
      RABBITMQ_HOST: rabbitmq
    depends_on:
      postgres:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rsu-network

  medical-service:
    build:
      context: ./medical-service
      dockerfile: Dockerfile
    ports:
      - "8082:8082"
    environment:
      DB_USERNAME: postgres
      DB_PASSWORD: postgres
      RABBITMQ_HOST: rabbitmq
    depends_on:
      postgres:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rsu-network

  pharmacy-service:
    build:
      context: ./pharmacy-service
      dockerfile: Dockerfile
    ports:
      - "8083:8083"
    environment:
      DB_USERNAME: postgres
      DB_PASSWORD: postgres
      RABBITMQ_HOST: rabbitmq
    depends_on:
      postgres:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rsu-network

  payment-service:
    build:
      context: ./payment-service
      dockerfile: Dockerfile
    ports:
      - "8084:8084"
    environment:
      DB_USERNAME: postgres
      DB_PASSWORD: postgres
      RABBITMQ_HOST: rabbitmq
    depends_on:
      postgres:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - rsu-network

networks:
  rsu-network:
    driver: bridge

volumes:
  postgres_data:
```

---

## 📦 TEKNOLOGI & DEPENDENCIES

| Komponen | Versi | Fungsi |
|----------|-------|--------|
| Java | 17 LTS | Runtime Language |
| Spring Boot | 3.2.5 | Framework |
| PostgreSQL | 15 | Database |
| RabbitMQ | 3 | Event Broker |
| Maven | 3.9+ | Build Tool |
| JWT | 0.12.3 | Authentication |
| Flyway | 9.22.3 | DB Migration |
| Lombok | Latest | Code Generation |
| SpringDoc OpenAPI | 2.3.0 | Swagger/OpenAPI |
| Docker | Latest | Containerization |

---

## 🚀 CARA MENJALANKAN

### Prerequisites:
```bash
- Java 17 JDK installed
- Maven 3.9+
- Docker & Docker Compose
- Git
```

### Build & Run dengan Docker Compose:
```bash
# Clone/Navigate ke project
cd ProyekAkhir-EAI

# Build semua services
docker-compose build

# Run all services
docker-compose up -d

# Check logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Run Locally (Development):
```bash
# Build admin-service
cd admin-service
mvn clean package -DskipTests

# Run admin-service
mvn spring-boot:run

# Pada terminal lain, build dan run medical-service
cd ../medical-service
mvn clean package -DskipTests
mvn spring-boot:run
```

### Akses Services:
```
Admin Service:      http://localhost:8081/swagger-ui.html
Medical Service:    http://localhost:8082/swagger-ui.html
Pharmacy Service:   http://localhost:8083/swagger-ui.html
Payment Service:    http://localhost:8084/swagger-ui.html
RabbitMQ UI:        http://localhost:15672 (guest/guest)
Database:           localhost:5432 (postgres/postgres)
```

---

## 📊 SEQUENCE FLOW - ALUR KOMPLET PASIEN

```
Pasien Datang
  │
  ├─→ [1] Admin Service
  │   ├─ Login
  │   ├─ Register Pasien
  │   ├─ Buat Antrean
  │   ├─ Pub: pasien.terdaftar
  │   └─ Pub: antrean.dibuat
  │
  ├─→ [2] Medical Service
  │   ├─ Mulai Pemeriksaan
  │   ├─ Input EMR (tekanan darah, berat badan, dll)
  │   ├─ Diagnosa (ICD-10)
  │   ├─ Tindakan Medis (biaya)
  │   ├─ Buat Resep Elektronik
  │   ├─ Pub: resep.diterbitkan
  │   └─ Pub: tindakan.dicatat
  │
  ├─→ [3] Pharmacy Service
  │   ├─ Sub: resep.diterbitkan
  │   ├─ Validasi Resep
  │   ├─ Cek Stok Obat
  │   ├─ Dispensing (Keluarkan Stok)
  │   ├─ Cek Stok Min (jika < min, Pub: stok.menipis)
  │   ├─ Auto Procurement Order
  │   └─ Pub: obat.dispensed
  │
  ├─→ [4] Payment Service
  │   ├─ Sub: tindakan.dicatat
  │   ├─ Sub: obat.dispensed
  │   ├─ Generate Invoice
  │   ├─ Kalkulasi Billing (konsultasi + tindakan + obat)
  │   ├─ Apply Diskon Asuransi
  │   ├─ Add PPN 11%
  │   ├─ Proses Pembayaran (Tunai/Debit/QRIS)
  │   └─ Cetak Struk & Generate Laporan
  │
  └─→ Pasien Pulang (dengan resep, struk, & laporan)
```

---

## 🔐 SECURITY FEATURES

✅ JWT Token-based Authentication
✅ Role-Based Access Control (Admin, Dokter, Apoteker)
✅ Password Encryption (BCrypt)
✅ CORS Configuration
✅ API Security Headers
✅ Input Validation & Sanitization
✅ SQL Injection Prevention (JPA Parameterized Queries)
✅ Audit Trail Logging

---

## 📝 TESTING

Each service includes:
- ✅ Unit Tests (JUnit 5 + Mockito)
- ✅ Service Layer Tests
- ✅ Repository Layer Tests (Mock)
- ✅ API Integration Tests (Blueprint)

Run tests:
```bash
mvn test

# Or specific service
cd admin-service
mvn test
```

---

## 📈 MONITORING & LOGGING

- ✅ SLF4J + Logback
- ✅ Request/Response Logging
- ✅ Error Tracking
- ✅ Performance Metrics Ready
- ✅ Docker Health Checks

---

## 🔄 EVENT-DRIVEN COMMUNICATION

### RabbitMQ Exchanges & Queues:

```
admin.exchange
├─ Routing Key: pasien.terdaftar
│  └─ Queue: admin.pasien.queue
└─ Routing Key: antrean.dibuat
   └─ Queue: admin.antrean.queue

medical.exchange
├─ Routing Key: resep.diterbitkan
│  └─ Queue: pharmacy.resep.queue
└─ Routing Key: tindakan.dicatat
   └─ Queue: payment.tindakan.queue

pharmacy.exchange
├─ Routing Key: obat.dispensed
│  └─ Queue: payment.obat.queue
└─ Routing Key: stok.menipis
   └─ Queue: pharmacy.stok.queue

payment.exchange
└─ (future notifications)
```

---

## ✨ FITUR HIGHLIGHT

🏥 **Admin Service:**
- Manajemen Pasien Lengkap
- Scheduling Dokter Otomatis
- Antrean Management Real-time

🩺 **Medical Service:**
- EMR (Electronic Medical Record) Aman
- Diagnosa ICD-10 Terstruktur
- E-Prescription Digital

💊 **Pharmacy Service:**
- Inventory Management Real-time
- Auto Procurement Workflow
- Stock Alert System

💳 **Payment Service:**
- Multi-payment Gateway Integration
- Automatic Billing Calculation
- Financial Reporting

---

## 📞 KONTAK & SUPPORT

**Project:** Sistem Informasi Manajemen RSU Sumatera
**Version:** 1.0.0
**Created:** 2026
**Status:** Active Development

---

## 📄 LICENSE

MIT License - Open Source

