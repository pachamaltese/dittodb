DROP DATABASE IF EXISTS nycflights;
CREATE ROLE travis WITH LOGIN CREATEDB PASSWORD '*V7y5N2r';
CREATE DATABASE nycflights OWNER travis;
GRANT ALL PRIVILEGES ON DATABASE postgres TO travis;
