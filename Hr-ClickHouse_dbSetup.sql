-- Create database
DROP DATABASE IF EXISTS hr;
CREATE DATABASE hr;

-- Use the database
USE hr;

-- Creating tables with Nullable types
CREATE TABLE hr.regions (
    region_id UInt32,
    region_name Nullable(String)
) ENGINE = MergeTree()
ORDER BY region_id;

CREATE TABLE hr.countries (
    country_id String,
    country_name Nullable(String),
    region_id UInt32
) ENGINE = MergeTree()
ORDER BY country_id;

CREATE TABLE hr.locations (
    location_id UInt32,
    street_address Nullable(String),
    postal_code Nullable(String),
    city String,
    state_province Nullable(String),
    country_id String
) ENGINE = MergeTree()
ORDER BY location_id;

CREATE TABLE hr.departments (
    department_id UInt32,
    department_name String,
    manager_id Nullable(UInt32), 
    location_id UInt32
) ENGINE = MergeTree()
ORDER BY department_id;

CREATE TABLE hr.jobs (
    job_id String,
    job_title String,
    min_salary Nullable(Decimal(8, 0)),
    max_salary Nullable(Decimal(8, 0)) 
) ENGINE = MergeTree()
ORDER BY job_id;

CREATE TABLE hr.employees (
    employee_id UInt32,
    first_name Nullable(String),
    last_name Nullable(String),
    email Nullable(String),
    phone_number Nullable(String),
    hire_date Date,
    job_id String,
    salary Nullable(Decimal(8, 2)),    
    commission_pct Nullable(Decimal(2, 2)),
    manager_id Nullable(UInt32), 
    department_id Nullable(UInt32)
) ENGINE = MergeTree()
ORDER BY employee_id;

CREATE TABLE hr.job_history (
    employee_id UInt32,
    start_date Date,
    end_date Nullable(Date), 
    job_id String,
    department_id Nullable(UInt32) 
) ENGINE = MergeTree()
ORDER BY (employee_id, start_date);

-- Creating view
CREATE VIEW hr.emp_details_view AS 
SELECT 
    e.employee_id,
    e.job_id,
    e.manager_id,
    e.department_id,
    d.location_id,
    l.country_id,
    e.first_name,
    e.last_name,
    e.salary,
    e.commission_pct,
    d.department_name,
    j.job_title,
    l.city,
    l.state_province,
    c.country_name,
    r.region_name
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.locations l ON d.location_id = l.location_id
JOIN hr.countries c ON l.country_id = c.country_id
JOIN hr.regions r ON c.region_id = r.region_id
JOIN hr.jobs j ON e.job_id = j.job_id;
