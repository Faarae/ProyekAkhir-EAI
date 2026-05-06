-- Initial database setup for all services
-- This file is executed by docker-compose to create all databases

-- Create databases
CREATE DATABASE IF NOT EXISTS db_admin;
CREATE DATABASE IF NOT EXISTS db_medical;
CREATE DATABASE IF NOT EXISTS db_pharmacy;
CREATE DATABASE IF NOT EXISTS db_payment;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE db_admin TO postgres;
GRANT ALL PRIVILEGES ON DATABASE db_medical TO postgres;
GRANT ALL PRIVILEGES ON DATABASE db_pharmacy TO postgres;
GRANT ALL PRIVILEGES ON DATABASE db_payment TO postgres;
