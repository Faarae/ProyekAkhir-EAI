# 🏥 RSU SUMATERA - Sistem Informasi Manajemen Rumah Sakit
## Spring Boot Microservice Architecture - Full Implementation

---

## 📌 QUICK START GUIDE

### Prerequisites Checklist:
- ✅ Java 17 JDK installed (`java -version`)
- ✅ Maven 3.9+ installed (`mvn -version`)
- ✅ Docker & Docker Compose installed (`docker -version`)
- ✅ MySQL 8.0+ installed OR use Docker

### Clone & Navigate:
```bash
cd ProyekAkhir-EAI
```

---

## 🚀 DEPLOYMENT OPTIONS

### **Option 1: Full Docker Compose (Recommended - One Command)**
```bash
# Build all services
docker-compose build

# Start all services

### **Option 2: Local Maven Development**

#### Terminal 1 - Start Infrastructure (MySQL + RabbitMQ):
```bash
docker-compose up mysql rabbitmq -d
# Wait 30 seconds for services to start
```

#### Terminal 2 - Admin Service:
```bash
cd admin-service
mvn clean package -DskipTests
mvn spring-boot:run
# Access: http://localhost:8081/swagger-ui.html
```

#### Terminal 3 - Medical Service:
```bash
cd medical-service
mvn clean package -DskipTests
mvn spring-boot:run
# Access: http://localhost:8082/swagger-ui.html
```

#### Terminal 4 - Pharmacy Service:
```bash
cd pharmacy-service
mvn clean package -DskipTests
mvn spring-boot:run
# Access: http://localhost:8083/swagger-ui.html
```

#### Terminal 5 - Payment Service:
```bash
cd payment-service
mvn clean package -DskipTests
mvn spring-boot:run
# Access: http://localhost:8084/swagger-ui.html
```

### **Option 3: Kubernetes Deployment**
```bash
# Build and push Docker images to registry
docker-compose build
docker tag admin-service:latest yourusername/admin-service:latest
# ... tag others ...
docker push yourusername/admin-service:latest

# Deploy to Kubernetes (create k8s deployment files)
kubectl apply -f k8s/
```

---

## 📋 PROJECT STRUCTURE

```
ProyekAkhir-EAI/
├── admin-service/                    ✅ COMPLETE
│   ├── src/main/java/.../admin/
│   │   ├── entity/        (5 entities)
│   │   ├── repository/    (5 repos)
│   │   ├── service/       (2 services)
│   │   ├── controller/    (2 controllers)
│   │   ├── dto/
│   │   ├── config/
│   │   ├── exception/
│   │   ├── event/
│   │   └── security/
│   ├── pom.xml            ✅
│   ├── Dockerfile         ✅
│   └── README.md
│
├── medical-service/                  🔧 PARTIALLY COMPLETE
│   ├── src/main/java/.../medical/   (Entity, Config, App class created)
│   ├── pom.xml                       ✅
│   ├── Dockerfile                    ✅
│   └── db/migration/V1__init.sql    ✅
│
├── pharmacy-service/                 🔧 PARTIALLY COMPLETE
│   ├── src/main/java/.../pharmacy/  (Entity, Config, App class created)
│   ├── pom.xml                       ✅
│   ├── Dockerfile                    ✅
│   └── db/migration/V1__init.sql    ✅
│
├── payment-service/                  🔧 PARTIALLY COMPLETE
│   ├── src/main/java/.../payment/   (Entity, Config, App class created)
│   ├── pom.xml                       ✅
│   ├── Dockerfile                    ✅
│   └── db/migration/V1__init.sql    ✅
│
├── docker-compose.yml                ✅ COMPLETE
├── init-db.sql                       ✅ COMPLETE
├── PROJECT_IMPLEMENTATION_GUIDE.md   ✅ COMPLETE
└── README.md                         ✅ THIS FILE
```

---

## 🔐 AUTHENTICATION

### Login Endpoint:
```bash
POST /api/v1/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "admin123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzUxMiJ9...",
    "username": "admin",
    "namaLengkap": "Administrator",
    "role": "ADMIN",
    "expiresIn": 86400000
  },
  "timestamp": "2026-05-01T10:00:00",
  "path": "/api/v1/auth/login"
}
```

### Use Token for Protected Endpoints:
```bash
GET /api/v1/pasien
Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...
```

---

## 📊 API DOCUMENTATION

All services expose Swagger UI documentation:

| Service | Swagger UI | Port |
|---------|-----------|------|
| Admin | http://localhost:8081/swagger-ui.html | 8081 |
| Medical | http://localhost:8082/swagger-ui.html | 8082 |
| Pharmacy | http://localhost:8083/swagger-ui.html | 8083 |
| Payment | http://localhost:8084/swagger-ui.html | 8084 |

---

## 🗄️ DATABASE SCHEMA

### Admin Service (db_admin):
- `users` - System users with roles
- `pasien` - Patient records
- `poliklinik` - Medical departments
- `jadwal_dokter` - Doctor schedules
- `antrean` - Patient queue

### Medical Service (db_medical):
- `pemeriksaan` - Medical examinations
- `diagnosa` - Diagnoses (ICD-10)
- `tindakan` - Medical procedures
- `resep` - E-prescriptions
- `resep_detail` - Prescription items

### Pharmacy Service (db_pharmacy):
- `obat` - Medicine inventory
- `stok` - Stock tracking
- `supplier` - Vendors
- `pesanan_obat` - Purchase orders
- `dispensing_resep` - Prescription processing

### Payment Service (db_payment):
- `invoice` - Billing invoices
- `transaksi` - Payment transactions
- `laporan_keuangan` - Financial reports

---

## 🔄 EVENT-DRIVEN FLOW

### RabbitMQ Message Broker:

```
Admin Service publishes:
├─ pasien.terdaftar      → Medical Service listens
└─ antrean.dibuat        → (optional)

Medical Service publishes:
├─ resep.diterbitkan     → Pharmacy Service listens
└─ tindakan.dicatat      → Payment Service listens

Pharmacy Service publishes:
├─ obat.dispensed        → Payment Service listens
└─ stok.menipis          → Pharmacy auto-triggers

Payment Service publishes:
└─ (future events)
```

---

## 🧪 TESTING

### Run All Tests:
```bash
# Root level (all services)
mvn test

# Specific service
cd admin-service
mvn test
```

### Generate Coverage Report:
```bash
mvn clean test jacoco:report
# Report: target/site/jacoco/index.html
```

---

## 📊 MONITORING & LOGS

### View Logs:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f admin-service

# Real-time tail
docker-compose logs -f --tail=50 medical-service
```

### RabbitMQ Management UI:
```
URL: http://localhost:15672
Username: guest
Password: guest
```

### Database Connection:
```
Host: localhost
Port: 3306
Database: db_admin (or db_medical, db_pharmacy, db_payment)
Username: root
Password: root

# Connect via mysql CLI:
mysql -h localhost -u root -proot db_admin
```

---

## 🔧 TROUBLESHOOTING

### Services won't start:
```bash
# Check if ports are in use
lsof -i :8081
lsof -i :8082
lsof -i :8083
lsof -i :8084

# Kill existing processes
kill -9 <PID>

# Clear Docker volumes
docker-compose down -v
docker-compose up --build
```

### Database connection failed:
```bash
# Check MySQL is running
docker ps | grep mysql

# Check RabbitMQ is running
docker ps | grep rabbitmq

# Restart infrastructure
docker-compose restart mysql rabbitmq
```

### Migration failed:
```bash
# Clear Flyway history and retry
docker-compose exec mysql mysql -u root -proot db_admin \
  -e "DROP TABLE IF EXISTS flyway_schema_history;"
docker-compose restart admin-service
```

### Port already in use:
```bash
# Use different ports in docker-compose.yml
# Or stop conflicting services:
docker-compose down
lsof -i :3306
kill -9 <PID>
```

---

## 📚 TECH STACK DETAILS

| Layer | Technology | Version |
|-------|-----------|---------|
| **Language** | Java | 17 LTS |
| **Framework** | Spring Boot | 3.2.5 |
| **Build Tool** | Maven | 3.9+ |
| **Database** | MySQL | 8.0 |
| **ORM** | Spring Data JPA + Hibernate | Latest |
| **Migration** | Flyway | 9+ (with MySQL support) |
| **Auth** | JWT (jjwt) | 0.12.3 |
| **Message Broker** | RabbitMQ | 3.12 |
| **API Docs** | SpringDoc OpenAPI | 2.3.0 |
| **Security** | Spring Security | 3.2.5 |
| **Testing** | JUnit 5 + Mockito | Latest |
| **Containerization** | Docker | Latest |
| **Orchestration** | Docker Compose | 3.8 |

---

## 💾 BACKUP & RESTORE

### Backup Database:
```bash
docker-compose exec mysql mysqldump -u root -proot db_admin > backup_admin.sql
docker-compose exec mysql mysqldump -u root -proot db_medical > backup_medical.sql
docker-compose exec mysql mysqldump -u root -proot db_pharmacy > backup_pharmacy.sql
docker-compose exec mysql mysqldump -u root -proot db_payment > backup_payment.sql
```

### Restore Database:
```bash
docker-compose exec -T mysql mysql -u root -proot db_admin < backup_admin.sql
```

---

## 🎯 NEXT STEPS - COMPLETING THE IMPLEMENTATION

### Phase 2 - Complete Remaining Services:

The following still need implementation:

#### Medical Service:
```java
// TODO: Create these classes
- PemeriksaanEntity, DiagnosaEntity, TindakanEntity, ResepEntity
- PemeriksaanRepository, ResepRepository
- PemeriksaanService, ResepService (interfaces + impls)
- PemeriksaanController, ResepController
- CreatePemeriksaanRequest, CreateResepRequest DTOs
- ResepEventPublisher (publishes events to RabbitMQ)
- ResepEventListener (consumes events)
```

#### Pharmacy Service:
```java
// TODO: Create these classes
- ObatEntity, StokEntity, SupplierEntity, PesananObatEntity
- ObatRepository, StokRepository, SupplierRepository, PesananRepository
- ObatService, StokService, SupplierService, PesananService
- ObatController, StokController, SupplierController, PesananController
- ResepEventListener (consumes resep.diterbitkan from Medical)
- ObatDispensingEventPublisher (publishes obat.dispensed)
- Stock alert logic (auto-trigger procurement when low)
```

#### Payment Service:
```java
// TODO: Create these classes
- InvoiceEntity, TransaksiEntity, LaporanKeuanganEntity
- InvoiceRepository, TransaksiRepository, LaporanRepository
- InvoiceService, TransaksiService, LaporanService
- InvoiceController, TransaksiController, LaporanController
- TindakanEventListener (consumes from Medical Service)
- ObatDispensingEventListener (consumes from Pharmacy Service)
- InvoiceAggregator (combines biaya from multiple services)
- PaymentGatewayIntegration (Tunai, Debit, QRIS)
```

---

## 📞 SUPPORT & DOCUMENTATION

- **Project Docs:** `PROJECT_IMPLEMENTATION_GUIDE.md`
- **Prompt Microservice:** `prompt-microservice-RSUSumatera.md`
- **Code Generation:** `prompt-codegen-RSUSumatera-SpringBoot.md`
- **Service Files:** `service.xml`, `Service-RSUSumatera.txt`

---

## 📝 LICENSE & ATTRIBUTION

**Project:** RSU Sumatera - Sistem Informasi Manajemen Rumah Sakit
**Version:** 1.0.0
**Created:** 2026
**Type:** Open Source Educational Project
**License:** MIT

---

## ✅ COMPLETION STATUS

```
✅ Admin Service      - COMPLETE (100%)
   - All entities, repos, services, controllers
   - Security & JWT authentication
   - Event publishing to RabbitMQ
   - Flyway database migration
   - Unit tests

🔧 Medical Service    - FOUNDATION READY (20%)
   - Entities & database schema
   - pom.xml & Docker config
   - Application ready for development

🔧 Pharmacy Service   - FOUNDATION READY (20%)
   - Entities & database schema
   - pom.xml & Docker config
   - Application ready for development

🔧 Payment Service    - FOUNDATION READY (20%)
   - Entities & database schema
   - pom.xml & Docker config
   - Application ready for development

✅ Infrastructure     - COMPLETE (100%)
   - Docker Compose orchestration
   - PostgreSQL initialization script
   - RabbitMQ configuration
   - Network connectivity setup

Overall: 50% Complete - Ready for Phase 2 Development
```

---

## 🎓 LEARNING RESOURCES

### Spring Boot Microservices:
- https://spring.io/projects/spring-boot
- https://spring.io/projects/spring-cloud

### JWT Authentication:
- https://jwt.io/
- https://github.com/jwtk/jjwt

### Event-Driven Architecture:
- https://www.rabbitmq.com/tutorials
- https://spring.io/projects/spring-amqp

### Docker & Containerization:
- https://docs.docker.com/
- https://docs.docker.com/compose/

---

**Happy Coding! 🚀**

For questions or issues, refer to the comprehensive implementation guide or contact the development team.
