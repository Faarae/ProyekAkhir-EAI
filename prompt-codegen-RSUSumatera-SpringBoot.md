# Prompt: Generate Full Microservice Code — RSU Sumatera
## Stack: Spring Boot (Java) | 4 Services | Full Project Structure

---

## Instruksi Utama

Kamu adalah **Senior Java Backend Engineer** yang berpengalaman dalam arsitektur microservice. Tugasmu adalah membuat **full project code** untuk Sistem Informasi Manajemen RSU Sumatera menggunakan **Spring Boot**.

Buat **4 project Spring Boot terpisah** (masing-masing service adalah repo independen). Setiap project harus **langsung bisa dijalankan** (`mvn spring-boot:run`) tanpa konfigurasi tambahan.

---

## Tech Stack & Versi

```
Java              : 17 (LTS)
Spring Boot       : 3.2.x
Build Tool        : Maven
Database          : PostgreSQL (masing-masing service DB sendiri)
ORM               : Spring Data JPA + Hibernate
Migration         : Flyway
Communication     : REST (OpenFeign) + RabbitMQ (event-driven)
Security          : Spring Security + JWT (jjwt 0.12.x)
Validation        : spring-boot-starter-validation
Dokumentasi API   : SpringDoc OpenAPI 3 (Swagger UI)
Testing           : JUnit 5 + Mockito
Containerisasi    : Docker + docker-compose.yml
```

---

## Struktur Project Per Service

Setiap service harus menggunakan struktur package berikut:

```
{service-name}/
├── src/
│   ├── main/
│   │   ├── java/com/rsususumatera/{service}/
│   │   │   ├── config/
│   │   │   │   ├── SecurityConfig.java
│   │   │   │   ├── RabbitMQConfig.java        ← jika relevan
│   │   │   │   └── OpenAPIConfig.java
│   │   │   ├── controller/
│   │   │   │   └── {Entity}Controller.java
│   │   │   ├── service/
│   │   │   │   ├── {Entity}Service.java        ← interface
│   │   │   │   └── impl/{Entity}ServiceImpl.java
│   │   │   ├── repository/
│   │   │   │   └── {Entity}Repository.java
│   │   │   ├── entity/
│   │   │   │   └── {Entity}.java
│   │   │   ├── dto/
│   │   │   │   ├── request/{Entity}Request.java
│   │   │   │   └── response/{Entity}Response.java
│   │   │   ├── event/
│   │   │   │   ├── publisher/{Event}Publisher.java
│   │   │   │   └── listener/{Event}Listener.java
│   │   │   ├── exception/
│   │   │   │   ├── GlobalExceptionHandler.java
│   │   │   │   ├── ResourceNotFoundException.java
│   │   │   │   └── BusinessException.java
│   │   │   ├── mapper/
│   │   │   │   └── {Entity}Mapper.java         ← MapStruct atau manual
│   │   │   └── {ServiceName}Application.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       └── db/migration/
│   │           └── V1__init_schema.sql
│   └── test/
│       └── java/com/rsususumatera/{service}/
│           ├── controller/{Entity}ControllerTest.java
│           └── service/{Entity}ServiceTest.java
├── Dockerfile
└── pom.xml
```

---

## Detail Per Service

---

### SERVICE 1 — Admin Service
**Port:** `8081`
**Database:** `db_admin`
**Group ID:** `com.rsususumatera.admin`

#### Entitas & Spesifikasi Tabel

```java
// Pasien.java
@Entity @Table(name = "pasien")
- id          : UUID (PK, generated)
- nik         : String(16), unique, not null
- nama        : String(100), not null
- noRm        : String(20), unique, not null  ← format: RSU-YYYY-XXXXX
- tanggalLahir: LocalDate
- jenisKelamin: Enum(LAKI_LAKI, PEREMPUAN)
- alamat      : String(255)
- noTelp      : String(15)
- statusBpjs  : Boolean, default false
- noBpjs      : String(20), nullable
- createdAt   : LocalDateTime
- updatedAt   : LocalDateTime

// User.java
@Entity @Table(name = "users")
- id          : UUID (PK)
- username    : String(50), unique
- password    : String (BCrypt hashed)
- namaLengkap : String(100)
- role        : Enum(ADMIN, DOKTER, APOTEKER)
- poliklinikId: UUID, nullable
- isActive    : Boolean, default true
- createdAt   : LocalDateTime

// Poliklinik.java
@Entity @Table(name = "poliklinik")
- id          : UUID (PK)
- nama        : String(100)   ← contoh: "Poli Umum", "Poli Jantung"
- lantai      : Integer
- isActive    : Boolean

// JadwalDokter.java
@Entity @Table(name = "jadwal_dokter")
- id          : UUID (PK)
- dokterId    : UUID (FK → users)
- poliklinikId: UUID (FK → poliklinik)
- hari        : Enum(SENIN, SELASA, RABU, KAMIS, JUMAT, SABTU)
- jamMulai    : LocalTime
- jamSelesai  : LocalTime
- kuotaPasien : Integer, default 20
- isActive    : Boolean

// Antrean.java
@Entity @Table(name = "antrean")
- id          : UUID (PK)
- pasienId    : UUID (FK → pasien)
- jadwalId    : UUID (FK → jadwal_dokter)
- nomorAntrean: Integer
- tanggal     : LocalDate
- status      : Enum(MENUNGGU, DIPANGGIL, SELESAI, BATAL)
- createdAt   : LocalDateTime
```

#### Endpoint yang Harus Dibuat

```
POST   /api/v1/auth/login                    ← return JWT token
POST   /api/v1/auth/register                 ← register user baru

GET    /api/v1/pasien                        ← list semua pasien (pageable)
POST   /api/v1/pasien                        ← daftarkan pasien baru
GET    /api/v1/pasien/{id}                   ← detail pasien by ID
GET    /api/v1/pasien/nik/{nik}              ← cari pasien by NIK
PUT    /api/v1/pasien/{id}                   ← update data pasien
DELETE /api/v1/pasien/{id}                   ← soft delete

GET    /api/v1/poliklinik                    ← list poliklinik aktif
POST   /api/v1/poliklinik                    ← tambah poliklinik

GET    /api/v1/jadwal                        ← list semua jadwal dokter
GET    /api/v1/jadwal/dokter/{dokterId}      ← jadwal per dokter
POST   /api/v1/jadwal                        ← buat jadwal baru

GET    /api/v1/antrean/hari-ini              ← antrean hari ini
POST   /api/v1/antrean                       ← buat antrean baru
PUT    /api/v1/antrean/{id}/panggil          ← update status → DIPANGGIL
PUT    /api/v1/antrean/{id}/selesai          ← update status → SELESAI

POST   /api/v1/asuransi/verifikasi           ← cek status BPJS pasien
```

#### Event yang Dipublish ke RabbitMQ

```json
// Exchange: admin.exchange | Routing Key: pasien.terdaftar
{
  "eventType": "PASIEN_TERDAFTAR",
  "timestamp": "2026-05-01T10:00:00",
  "payload": {
    "pasienId": "uuid",
    "noRm": "RSU-2026-00001",
    "nama": "Budi Santoso",
    "statusBpjs": true
  }
}

// Exchange: admin.exchange | Routing Key: antrean.dibuat
{
  "eventType": "ANTREAN_DIBUAT",
  "timestamp": "2026-05-01T10:05:00",
  "payload": {
    "antreanId": "uuid",
    "pasienId": "uuid",
    "dokterId": "uuid",
    "nomorAntrean": 5,
    "tanggal": "2026-05-01"
  }
}
```

---

### SERVICE 2 — Medical Service
**Port:** `8082`
**Database:** `db_medical`
**Group ID:** `com.rsususumatera.medical`

#### Entitas & Spesifikasi Tabel

```java
// Pemeriksaan.java
@Entity @Table(name = "pemeriksaan")
- id             : UUID (PK)
- pasienId       : UUID (disimpan lokal, bukan FK ke DB lain)
- dokterId       : UUID
- antreanId      : UUID
- tanggal        : LocalDate
- tekananDarah   : String(20)   ← format: "120/80"
- beratBadan     : BigDecimal   ← kg
- tinggiBadan    : BigDecimal   ← cm
- suhuTubuh      : BigDecimal   ← celcius
- keluhanUtama   : String(500)
- catatanDokter  : String(1000)
- status         : Enum(DRAFT, SELESAI)
- createdAt      : LocalDateTime

// Diagnosa.java
@Entity @Table(name = "diagnosa")
- id             : UUID (PK)
- pemeriksaanId  : UUID (FK → pemeriksaan)
- kodeIcd10      : String(10)   ← contoh: "J06.9"
- deskripsi      : String(255)
- isPrimer       : Boolean       ← diagnosa utama atau penyerta

// Tindakan.java
@Entity @Table(name = "tindakan")
- id             : UUID (PK)
- pemeriksaanId  : UUID (FK → pemeriksaan)
- namaTindakan   : String(100)
- biaya          : BigDecimal
- keterangan     : String(255)

// Resep.java
@Entity @Table(name = "resep")
- id             : UUID (PK)
- pemeriksaanId  : UUID (FK → pemeriksaan)
- dokterId       : UUID
- pasienId       : UUID
- status         : Enum(PENDING, DIPROSES, SELESAI, DITOLAK)
- createdAt      : LocalDateTime

// ResepDetail.java
@Entity @Table(name = "resep_detail")
- id             : UUID (PK)
- resepId        : UUID (FK → resep)
- namaObat       : String(100)
- dosis          : String(50)    ← contoh: "500mg"
- frekuensi      : String(50)    ← contoh: "3x sehari"
- jumlah         : Integer
- keterangan     : String(255)
```

#### Endpoint yang Harus Dibuat

```
POST   /api/v1/pemeriksaan                          ← mulai sesi pemeriksaan
GET    /api/v1/pemeriksaan/{id}                     ← detail pemeriksaan
GET    /api/v1/pemeriksaan/pasien/{pasienId}        ← riwayat pemeriksaan pasien
PUT    /api/v1/pemeriksaan/{id}/selesai             ← finalisasi rekam medis

POST   /api/v1/pemeriksaan/{id}/diagnosa            ← tambah diagnosa (ICD-10)
GET    /api/v1/diagnosa/icd10?q={keyword}           ← search kode ICD-10

POST   /api/v1/pemeriksaan/{id}/tindakan            ← catat tindakan medis
GET    /api/v1/pemeriksaan/{id}/tindakan            ← list tindakan per pemeriksaan

POST   /api/v1/resep                                ← buat resep elektronik baru
GET    /api/v1/resep/{id}                           ← detail resep
GET    /api/v1/resep/pemeriksaan/{pemeriksaanId}    ← resep per pemeriksaan
PUT    /api/v1/resep/{id}/status                    ← update status resep
```

#### Event yang Dipublish ke RabbitMQ

```json
// Exchange: medical.exchange | Routing Key: resep.diterbitkan
{
  "eventType": "RESEP_DITERBITKAN",
  "timestamp": "2026-05-01T10:30:00",
  "payload": {
    "resepId": "uuid",
    "pasienId": "uuid",
    "dokterId": "uuid",
    "pemeriksaanId": "uuid",
    "items": [
      { "namaObat": "Amoxicillin", "dosis": "500mg", "frekuensi": "3x sehari", "jumlah": 15 }
    ]
  }
}

// Exchange: medical.exchange | Routing Key: tindakan.dicatat
{
  "eventType": "TINDAKAN_DICATAT",
  "timestamp": "2026-05-01T10:35:00",
  "payload": {
    "pemeriksaanId": "uuid",
    "pasienId": "uuid",
    "tindakan": [
      { "namaTindakan": "Jahit Luka", "biaya": 150000 }
    ],
    "totalBiayaTindakan": 150000
  }
}
```

---

### SERVICE 3 — Pharmacy Service
**Port:** `8083`
**Database:** `db_pharmacy`
**Group ID:** `com.rsususumatera.pharmacy`

#### Entitas & Spesifikasi Tabel

```java
// Obat.java
@Entity @Table(name = "obat")
- id          : UUID (PK)
- kodeObat    : String(20), unique    ← format: OBT-XXXXX
- nama        : String(100)
- jenisObat   : Enum(GENERIK, PATEN, HERBAL)
- satuan      : String(20)            ← "Tablet", "Kapsul", "ml"
- hargaSatuan : BigDecimal
- minStok     : Integer, default 10
- isActive    : Boolean

// Stok.java
@Entity @Table(name = "stok")
- id               : UUID (PK)
- obatId           : UUID (FK → obat)
- jumlah           : Integer
- lokasiRak        : String(20)
- tanggalKadaluarsa: LocalDate
- noBatch          : String(50)
- updatedAt        : LocalDateTime

// Supplier.java
@Entity @Table(name = "supplier")
- id      : UUID (PK)
- nama    : String(100)
- kontak  : String(15)
- email   : String(100)
- alamat  : String(255)
- isActive: Boolean

// PesananObat.java
@Entity @Table(name = "pesanan_obat")
- id          : UUID (PK)
- supplierId  : UUID (FK → supplier)
- status      : Enum(DRAFT, DIKIRIM, DITERIMA, DIBATALKAN)
- totalHarga  : BigDecimal
- catatan     : String(500)
- createdAt   : LocalDateTime
- updatedAt   : LocalDateTime

// PesananObatDetail.java
@Entity @Table(name = "pesanan_obat_detail")
- id          : UUID (PK)
- pesananId   : UUID (FK → pesanan_obat)
- obatId      : UUID (FK → obat)
- jumlah      : Integer
- hargaSatuan : BigDecimal
- subtotal    : BigDecimal

// DispensingResep.java   ← tracking resep yang diproses apotek
@Entity @Table(name = "dispensing_resep")
- id          : UUID (PK)
- resepId     : UUID  ← dari Medical Service (external ID)
- pasienId    : UUID
- status      : Enum(MENUNGGU, DIVALIDASI, DISIAPKAN, DISERAHKAN, DITOLAK)
- totalHarga  : BigDecimal
- catatanFarmasist: String(255)
- createdAt   : LocalDateTime
```

#### Endpoint yang Harus Dibuat

```
GET    /api/v1/obat                              ← list obat (pageable + search)
POST   /api/v1/obat                              ← tambah obat baru
GET    /api/v1/obat/{id}                         ← detail obat
PUT    /api/v1/obat/{id}                         ← update data obat
GET    /api/v1/obat/stok-menipis                 ← list obat di bawah minStok

GET    /api/v1/stok/{obatId}                     ← cek stok per obat
POST   /api/v1/stok/masuk                        ← input stok masuk dari supplier
POST   /api/v1/stok/keluar                       ← keluarkan stok (dispensing)

GET    /api/v1/supplier                          ← list supplier
POST   /api/v1/supplier                          ← tambah supplier
PUT    /api/v1/supplier/{id}                     ← update supplier

GET    /api/v1/pesanan                           ← list pesanan obat
POST   /api/v1/pesanan                           ← buat pesanan baru ke supplier
PUT    /api/v1/pesanan/{id}/kirim                ← update status → DIKIRIM
PUT    /api/v1/pesanan/{id}/terima               ← terima pesanan + update stok otomatis

GET    /api/v1/dispensing                        ← list antrian resep masuk
GET    /api/v1/dispensing/{id}                   ← detail dispensing
PUT    /api/v1/dispensing/{id}/validasi          ← farmasist validasi resep
PUT    /api/v1/dispensing/{id}/serahkan          ← obat diserahkan ke pasien
```

#### Event yang Dikonsumsi dari RabbitMQ

```
Queue: pharmacy.resep.queue
Binding: medical.exchange → resep.diterbitkan
Action: Buat record DispensingResep baru dengan status MENUNGGU
```

#### Event yang Dipublish ke RabbitMQ

```json
// Exchange: pharmacy.exchange | Routing Key: obat.dispensed
{
  "eventType": "OBAT_DISPENSED",
  "timestamp": "2026-05-01T11:00:00",
  "payload": {
    "dispensingId": "uuid",
    "resepId": "uuid",
    "pasienId": "uuid",
    "items": [
      { "namaObat": "Amoxicillin", "jumlah": 15, "hargaSatuan": 2000, "subtotal": 30000 }
    ],
    "totalHargaObat": 30000
  }
}

// Exchange: pharmacy.exchange | Routing Key: stok.menipis  
{
  "eventType": "STOK_MENIPIS",
  "timestamp": "2026-05-01T11:05:00",
  "payload": {
    "obatId": "uuid",
    "namaObat": "Amoxicillin 500mg",
    "stokSekarang": 5,
    "minStok": 10
  }
}
```

---

### SERVICE 4 — Payment Service
**Port:** `8084`
**Database:** `db_payment`
**Group ID:** `com.rsususumatera.payment`

#### Entitas & Spesifikasi Tabel

```java
// Invoice.java
@Entity @Table(name = "invoice")
- id                : UUID (PK)
- nomorInvoice      : String(30), unique   ← format: INV-YYYYMMDD-XXXXX
- pasienId          : UUID
- pemeriksaanId     : UUID
- biayaKonsultasi   : BigDecimal, default 0
- biayaTindakan     : BigDecimal, default 0
- biayaObat         : BigDecimal, default 0
- subtotal          : BigDecimal           ← sum dari 3 biaya
- diskonAsuransi    : BigDecimal, default 0
- pajak             : BigDecimal, default 0  ← PPN 11%
- totalAkhir        : BigDecimal
- status            : Enum(DRAFT, UNPAID, PAID, CANCELLED)
- createdAt         : LocalDateTime
- updatedAt         : LocalDateTime

// Transaksi.java
@Entity @Table(name = "transaksi")
- id            : UUID (PK)
- invoiceId     : UUID (FK → invoice)
- metodePembayaran: Enum(TUNAI, DEBIT, QRIS)
- jumlahBayar   : BigDecimal
- kembalian     : BigDecimal, default 0
- referensiGateway: String(100), nullable  ← transaction ID dari QRIS/debit
- status        : Enum(PENDING, SUCCESS, FAILED)
- createdAt     : LocalDateTime

// LaporanKeuangan.java
@Entity @Table(name = "laporan_keuangan")
- id                : UUID (PK)
- periode           : String(7)            ← format: "2026-05"
- totalPendapatan   : BigDecimal
- totalTransaksi    : Integer
- totalPasien       : Integer
- generatedAt       : LocalDateTime
```

#### Endpoint yang Harus Dibuat

```
GET    /api/v1/invoice                          ← list semua invoice (pageable)
GET    /api/v1/invoice/{id}                     ← detail invoice
GET    /api/v1/invoice/pasien/{pasienId}        ← invoice per pasien
GET    /api/v1/invoice/nomor/{nomorInvoice}     ← cari by nomor invoice
POST   /api/v1/invoice/generate/{pemeriksaanId} ← generate invoice dari pemeriksaan
PUT    /api/v1/invoice/{id}/cancel              ← batalkan invoice

POST   /api/v1/transaksi/bayar                  ← proses pembayaran
GET    /api/v1/transaksi/{invoiceId}            ← detail transaksi per invoice
POST   /api/v1/transaksi/qris/callback          ← webhook dari payment gateway QRIS

GET    /api/v1/laporan/harian?tanggal={date}    ← laporan pendapatan harian
GET    /api/v1/laporan/bulanan?bulan={yyyy-MM}  ← laporan pendapatan bulanan
POST   /api/v1/laporan/generate/{periode}       ← generate laporan manual
```

#### Event yang Dikonsumsi dari RabbitMQ

```
Queue: payment.tindakan.queue
Binding: medical.exchange → tindakan.dicatat
Action: Buat/update Invoice, isi biayaTindakan

Queue: payment.obat.queue
Binding: pharmacy.exchange → obat.dispensed
Action: Update Invoice, isi biayaObat, hitung totalAkhir
```

---

## Konfigurasi Global

### application.yml (template per service)

```yaml
server:
  port: ${PORT:808X}                    ← ganti sesuai service

spring:
  application:
    name: {service-name}-service
  datasource:
    url: jdbc:postgresql://localhost:5432/db_{service}
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:postgres}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: validate                ← pakai Flyway untuk migration
    show-sql: false
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        format_sql: true
  flyway:
    enabled: true
    locations: classpath:db/migration
  rabbitmq:
    host: ${RABBITMQ_HOST:localhost}
    port: 5672
    username: ${RABBITMQ_USER:guest}
    password: ${RABBITMQ_PASS:guest}

jwt:
  secret: ${JWT_SECRET:rsu-sumatera-secret-key-2026}
  expiration: 86400000                  ← 24 jam dalam ms

springdoc:
  api-docs:
    path: /api-docs
  swagger-ui:
    path: /swagger-ui.html
```

### pom.xml Dependencies Wajib

```xml
<!-- Semua service harus include: -->
<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
  </dependency>
  <dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <scope>runtime</scope>
  </dependency>
  <dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-core</artifactId>
  </dependency>
  <dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.12.3</version>
  </dependency>
  <dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.12.3</version>
    <scope>runtime</scope>
  </dependency>
  <dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.3.0</version>
  </dependency>
  <dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <optional>true</optional>
  </dependency>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
  </dependency>
</dependencies>
```

### docker-compose.yml (root level, jalankan semua service)

```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: postgres
    volumes:
      - ./init-db.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"

  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"
      - "15672:15672"    ← RabbitMQ management UI

  admin-service:
    build: ./admin-service
    ports:
      - "8081:8081"
    depends_on: [postgres, rabbitmq]
    environment:
      DB_USERNAME: postgres
      DB_PASSWORD: postgres
      RABBITMQ_HOST: rabbitmq

  medical-service:
    build: ./medical-service
    ports:
      - "8082:8082"
    depends_on: [postgres, rabbitmq]

  pharmacy-service:
    build: ./pharmacy-service
    ports:
      - "8083:8083"
    depends_on: [postgres, rabbitmq]

  payment-service:
    build: ./payment-service
    ports:
      - "8084:8084"
    depends_on: [postgres, rabbitmq]
```

---

## Standar Kode yang Harus Diikuti

### 1. Response Format — Wajib Seragam di Semua Service

```java
// Selalu gunakan wrapper ini untuk semua response
@Data
@Builder
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private LocalDateTime timestamp;
    private String path;

    // Static factory methods:
    public static <T> ApiResponse<T> ok(T data, String message) { ... }
    public static <T> ApiResponse<T> created(T data) { ... }
    public static <T> ApiResponse<T> error(String message) { ... }
}

// Contoh respons sukses:
// {
//   "success": true,
//   "message": "Pasien berhasil didaftarkan",
//   "data": { ... },
//   "timestamp": "2026-05-01T10:00:00",
//   "path": "/api/v1/pasien"
// }
```

### 2. Global Exception Handler

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    // Handle: ResourceNotFoundException → 404
    // Handle: BusinessException → 400
    // Handle: MethodArgumentNotValidException → 422 (validasi)
    // Handle: AccessDeniedException → 403
    // Handle: Exception → 500
}
```

### 3. Security — JWT Filter

```java
// JwtAuthenticationFilter.java
// - Extract token dari header: Authorization: Bearer {token}
// - Validate token dan set SecurityContext
// - Public endpoints (tanpa auth):
//   POST /api/v1/auth/login
//   GET  /swagger-ui/**
//   GET  /api-docs/**
```

### 4. Validasi Request DTO

```java
// Semua request DTO harus menggunakan Bean Validation
public class CreatePasienRequest {
    @NotBlank(message = "NIK wajib diisi")
    @Size(min = 16, max = 16, message = "NIK harus 16 digit")
    private String nik;

    @NotBlank(message = "Nama wajib diisi")
    @Size(max = 100)
    private String nama;

    @NotNull(message = "Tanggal lahir wajib diisi")
    @Past(message = "Tanggal lahir harus di masa lalu")
    private LocalDate tanggalLahir;
    // dst...
}
```

### 5. RabbitMQ Publisher & Listener Pattern

```java
// Publisher
@Service
@RequiredArgsConstructor
public class ResepEventPublisher {
    private final RabbitTemplate rabbitTemplate;
    private final ObjectMapper objectMapper;

    public void publishResepDiterbitkan(ResepEvent event) {
        rabbitTemplate.convertAndSend(
            "medical.exchange",
            "resep.diterbitkan",
            objectMapper.writeValueAsString(event)
        );
    }
}

// Listener
@Component
@RequiredArgsConstructor
public class ResepEventListener {
    @RabbitListener(queues = "pharmacy.resep.queue")
    public void handleResepDiterbitkan(String message) {
        ResepEvent event = objectMapper.readValue(message, ResepEvent.class);
        // proses event...
    }
}
```

---

## Urutan Generate Kode

Generate kode dalam urutan ini agar dependency terpenuhi:

```
1. admin-service      → tidak bergantung service lain
2. medical-service    → konsumsi event dari admin (opsional)
3. pharmacy-service   → konsumsi event dari medical
4. payment-service    → konsumsi event dari medical + pharmacy
5. docker-compose.yml + init-db.sql (buat semua database sekaligus)
```

---

## Checklist Output

Pastikan setiap service menghasilkan file berikut:

- [ ] `pom.xml` — lengkap dengan semua dependency
- [ ] `application.yml` + `application-dev.yml`
- [ ] `V1__init_schema.sql` — Flyway migration
- [ ] Semua `@Entity` class dengan Lombok annotation
- [ ] Semua `Repository` interface (extend JpaRepository)
- [ ] Semua `Service` interface + `ServiceImpl` class
- [ ] Semua `Controller` class dengan `@RestController`
- [ ] Semua `Request` DTO + `Response` DTO
- [ ] `SecurityConfig.java` + `JwtUtil.java` + `JwtAuthenticationFilter.java`
- [ ] `RabbitMQConfig.java` (declare exchange, queue, binding)
- [ ] `GlobalExceptionHandler.java`
- [ ] `Dockerfile`
- [ ] Minimal 1 unit test per service (`ServiceTest.java`)
