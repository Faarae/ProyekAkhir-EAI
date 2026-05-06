# Prompt Dokumen: Sistem Informasi Manajemen Rumah Sakit Berbasis Microservice
## RSU Sumatera — Yayasan Kesehatan Sumatera

---

## Konteks Sistem

Kamu adalah seorang **Software Architect** yang merancang Sistem Informasi Manajemen Rumah Sakit (SIMRS) untuk **RSU Sumatera**, milik sebuah yayasan kesehatan. Sistem ini dibangun di atas arsitektur **microservice** untuk memisahkan tanggung jawab antar domain bisnis: pelayanan klinis rumah sakit, distribusi obat di apotek, dan pengelolaan keuangan/pembayaran.

Setiap service berjalan secara **independen**, berkomunikasi melalui **REST API** atau **message broker (event-driven)**, dan memiliki **database tersendiri** (Database per Service pattern).

---

## Alur Bisnis Utama (Sequence Flow)

Berikut adalah alur end-to-end yang harus didukung oleh sistem:

```
Pasien
  │
  ├─[1]─► Admin Service       : Registrasi & Verifikasi Asuransi
  │           │
  │           ├─[2]─► Medical Service   : Inisiasi Antrean & Jadwal Dokter
  │                       │
  │                       ├─[3]─► Pharmacy Service  : Input EMR & Kirim E-Prescription
  │                                   │
  │                                   ├─[4]─► (internal) Validasi Resep & Cek Stok
  │                                   │           │
  │                                   │        [alt: Stok Menipis]
  │                                   │           └─► Stock Alert & Procurement Order
  │                                   │
  │                                   ├─[5]─► Payment Service : Kirim Biaya Obat & Tindakan
  │                                               │
  │                                               ├─[6]─► (internal) Kalkulasi Billing & Pajak
  │
  ├─[7]─► Payment Service     : Pembayaran (Tunai / QRIS / Debit)
  │
  └─[8]─◄ Payment Service     : Cetak Struk & Laporan (response ke Pasien)
```

---

## Definisi Microservices

### 1. Admin Service *(Pusat Kendali Data)*

**Tanggung Jawab:** Mengelola data fundamental yayasan — identitas pasien, pengguna sistem, jadwal dokter, dan verifikasi asuransi.

**Modul Fungsional:**

| Modul | Deskripsi |
|---|---|
| Master Data Pasien | CRUD identitas pasien: nama, NIK, nomor rekam medis (No. RM) |
| User Management | Pengaturan hak akses untuk role: `admin`, `dokter`, `apoteker` |
| Antrean & Penjadwalan | Sinkronisasi jadwal praktik dokter dengan kedatangan pasien |
| Verifikasi Asuransi | Pengecekan status kepesertaan BPJS atau asuransi swasta |

**Entitas Data:**
- `Pasien` — id, nik, nama, no_rm, tanggal_lahir, alamat
- `User` — id, username, role, poliklinik_id
- `JadwalDokter` — id, dokter_id, hari, jam_mulai, jam_selesai, poliklinik_id
- `Poliklinik` — id, nama, lantai

**Event yang Dipublikasikan:**
- `pasien.terdaftar` → dikonsumsi oleh Medical Service
- `antrean.dibuat` → dikonsumsi oleh Medical Service

---

### 2. Medical Service *(Layanan Klinis)*

**Tanggung Jawab:** Mengelola seluruh data medis yang bersifat rahasia dan sensitif — rekam medis elektronik (EMR), diagnosis, tindakan, dan penerbitan resep elektronik.

**Modul Fungsional:**

| Modul | Deskripsi |
|---|---|
| Input Rekam Medis (EMR) | Pencatatan riwayat penyakit, keluhan, dan pemeriksaan fisik (tensi, BB, dll.) |
| Diagnosis Engine | Pemilihan kode penyakit berdasarkan standar **ICD-10** |
| E-Prescription (Resep Elektronik) | Input obat, dosis, frekuensi oleh dokter — langsung diteruskan ke Pharmacy Service |
| Tindakan Medis | Pencatatan prosedur klinis (contoh: jahit luka, injeksi, infus) |

**Entitas Data:**
- `Pemeriksaan` — id, pasien_id, dokter_id, tanggal, tekanan_darah, berat_badan, keluhan
- `Diagnosa` — id, pemeriksaan_id, kode_icd10, deskripsi
- `Tindakan` — id, pemeriksaan_id, nama_tindakan, biaya
- `Resep` — id, pemeriksaan_id, dokter_id, status (`PENDING` / `DIPROSES` / `SELESAI`)

**Event yang Dipublikasikan:**
- `resep.diterbitkan` → dikonsumsi oleh Pharmacy Service
- `tindakan.dicatat` → dikonsumsi oleh Payment Service

---

### 3. Pharmacy Service *(Manajemen Obat & Stok)*

**Tanggung Jawab:** Mengelola logistik dan keamanan distribusi obat — mulai dari validasi resep dokter, pengelolaan stok, hingga pemesanan ke supplier eksternal.

**Modul Fungsional:**

| Modul | Deskripsi |
|---|---|
| Inventory Control | Pelacakan stok masuk (dari supplier) dan stok keluar (ke pasien) |
| Validation & Dispensing | Verifikasi resep dari dokter sebelum obat disiapkan — mencegah salah dosis |
| Stock Alert | Notifikasi otomatis jika stok obat di bawah batas minimum (`min_stok`) |
| Procurement (Order Obat) | Pembuatan surat pesanan obat ke distributor atau vendor eksternal |

**Entitas Data:**
- `Obat` — id, nama, satuan, harga_satuan, min_stok
- `Stok` — id, obat_id, jumlah, lokasi_rak, tanggal_kadaluarsa
- `Supplier` — id, nama, kontak, alamat
- `PesananObat` — id, supplier_id, status (`DRAFT` / `DIKIRIM` / `DITERIMA`), total_harga

**Event yang Dipublikasikan:**
- `obat.dispensed` → dikonsumsi oleh Payment Service (untuk kalkulasi harga obat)
- `stok.menipis` → memicu proses Procurement internal

**Event yang Dikonsumsi:**
- `resep.diterbitkan` ← dari Medical Service

---

### 4. Payment Service *(Billing & Finansial)*

**Tanggung Jawab:** Titik akhir transaksi — mengagregasi seluruh biaya dari layanan klinis dan apotek, menghitung tagihan akhir, memproses pembayaran, dan menghasilkan laporan keuangan.

**Modul Fungsional:**

| Modul | Deskripsi |
|---|---|
| Billing Aggregator | Mengambil biaya konsultasi (Medical Service) & harga obat (Pharmacy Service) secara otomatis |
| Kalkulator Diskon / Pajak | Menghitung biaya akhir setelah potongan asuransi atau penambahan PPN 11% |
| Payment Gateway Interface | Menangani metode bayar: **Tunai**, **Debit**, **QRIS** |
| Reporting | Pembuatan laporan pendapatan harian dan bulanan |

**Entitas Data:**
- `Invoice` — id, pasien_id, total_biaya, status (`UNPAID` / `PAID`), tanggal
- `Transaksi` — id, invoice_id, metode_bayar, jumlah_bayar, timestamp
- `MetodePembayaran` — id, nama (`TUNAI` / `DEBIT` / `QRIS`), konfigurasi_gateway
- `LaporanKeuangan` — id, periode, total_pendapatan, total_transaksi

**Event yang Dikonsumsi:**
- `obat.dispensed` ← dari Pharmacy Service
- `tindakan.dicatat` ← dari Medical Service

---

## Aturan Komunikasi Antar Service

```
┌─────────────────────────────────────────────────────────┐
│                    YAYASAN SUMATERA                     │
│                                                         │
│  ┌───────────┐   REST    ┌───────────────┐              │
│  │   Admin   │──────────►│    Medical    │              │
│  │  Service  │           │    Service    │              │
│  └───────────┘           └──────┬────────┘              │
│                                 │  Event: resep.diterbitkan
│                                 ▼                       │
│                          ┌──────────────┐               │
│                          │   Pharmacy   │               │
│                          │   Service    │               │
│                          └──────┬───────┘               │
│                                 │  Event: obat.dispensed │
│                                 ▼                       │
│                          ┌──────────────┐               │
│                          │   Payment    │               │
│                          │   Service    │               │
│                          └──────────────┘               │
└─────────────────────────────────────────────────────────┘
```

**Aturan:**
1. Setiap service **TIDAK BOLEH** mengakses database service lain secara langsung.
2. Komunikasi **sinkron** (REST API) digunakan untuk operasi yang membutuhkan respons langsung (contoh: cek ketersediaan jadwal).
3. Komunikasi **asinkron** (Event / Message Broker) digunakan untuk notifikasi lintas service (contoh: resep diterbitkan → apotek memproses).
4. Setiap service memiliki **API Gateway**-nya sendiri dengan autentikasi token (JWT).

---

## Tugas yang Harus Dikerjakan

Berdasarkan spesifikasi di atas, kerjakan salah satu atau lebih dari tugas berikut:

### Tugas A — Desain API Endpoint
Rancang endpoint REST API untuk **satu service** pilihan kamu. Sertakan:
- Method HTTP (`GET`, `POST`, `PUT`, `DELETE`)
- Path dan parameter
- Contoh request body (JSON)
- Contoh response sukses dan error

### Tugas B — Desain Skema Database
Rancang skema database (ERD atau DDL SQL) untuk **satu service** pilihan kamu. Perhatikan:
- Relasi antar entitas
- Tipe data yang tepat
- Index dan foreign key

### Tugas C — Implementasi Sequence
Jelaskan atau implementasikan alur lengkap dari **Pasien datang hingga menerima struk** menggunakan pseudocode atau diagram sequence, mencakup semua 4 service.

### Tugas D — Event-Driven Design
Rancang skema **event/message** yang dikirim antar service. Sertakan:
- Nama event
- Payload struktur (JSON)
- Service pengirim dan penerima
- Kondisi trigger

---

## Kriteria Evaluasi

| Kriteria | Bobot |
|---|---|
| Pemahaman prinsip microservice (loose coupling, single responsibility) | 30% |
| Kelengkapan dan konsistensi desain entitas data | 25% |
| Kejelasan alur komunikasi antar service | 25% |
| Kualitas dokumentasi dan penjelasan teknis | 20% |

---

## Catatan Penting

> - Sistem ini dimiliki oleh **yayasan** (bukan korporat swasta), sehingga aspek **kepatuhan regulasi** (BPJS, data rekam medis sesuai Permenkes) harus dipertimbangkan.
> - Data rekam medis bersifat **rahasia** dan hanya boleh diakses oleh tenaga medis yang berwenang.
> - Seluruh transaksi keuangan harus **tercatat dan dapat diaudit** (audit trail).
> - Sistem harus mendukung **skalabilitas horizontal** karena volume pasien dapat meningkat signifikan.
