-- Initial database setup for all services
-- This file is executed by docker-compose to create all databases
-- MySQL 8.0 syntax

-- Create databases with proper charset
CREATE DATABASE IF NOT EXISTS db_admin CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS db_medical CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS db_pharmacy CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS db_payment CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
