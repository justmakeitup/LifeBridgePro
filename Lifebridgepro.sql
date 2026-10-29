CREATE DATABASE LifeBridgePro;

USE LifeBridgePro;

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 0),
    gender VARCHAR(10),
    phone VARCHAR(15) UNIQUE
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    consultation_fee DECIMAL(10,2) NOT NULL
        CHECK (consultation_fee >= 0)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY AUTO_INCREMENT,
    medicine_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0)
);

CREATE TABLE Bills (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

INSERT INTO Patients
(patient_name, age, gender, phone)
VALUES
('Aarav Sharma', 28, 'Male', '9000000001'),
('Diya Mukherjee', 24, 'Female', '9000000002'),
('Rahul Das', 45, 'Male', '9000000003'),
('Priya Sen', 32, 'Female', '9000000004'),
('Kabir Roy', 51, 'Male', '9000000005');

INSERT INTO Doctors
(doctor_name, specialization, consultation_fee)
VALUES
('Ananya Sen', 'Cardiology', 800),
('Arjun Roy', 'Neurology', 900),
('Meera Das', 'General Medicine', 500);

INSERT INTO Appointments
(patient_id, doctor_id, appointment_date, status)
VALUES
(1, 1, '2026-11-02', 'Scheduled'),
(2, 3, '2026-11-03', 'Completed'),
(3, 2, '2026-11-04', 'Scheduled'),
(4, 1, '2026-11-05', 'Completed'),
(5, 3, '2026-11-06', 'Cancelled');

INSERT INTO Medicines
(medicine_name, price, stock)
VALUES
('Paracetamol', 20, 100),
('Cetirizine', 30, 50),
('Vitamin C', 60, 40),
('Antacid', 45, 25),
('Cough Syrup', 90, 15);

INSERT INTO Bills
(patient_id, amount, payment_status)
VALUES
(1, 1200, 'Paid'),
(2, 500, 'Paid'),
(3, 1500, 'Pending'),
(4, 800, 'Pending'),
(5, 600, 'Paid');

-- Total number of patients
SELECT COUNT(*) AS total_patients FROM Patients;

-- Average doctor consultation fee
SELECT AVG(consultation_fee) AS average_fee FROM Doctors;

-- Most expensive medicine
SELECT MAX(price) AS highest_medicine_price FROM Medicines;

-- Total stock across all medicines
SELECT SUM(stock) AS total_stock FROM Medicines;

-- Convert patient names to uppercase
SELECT UPPER(patient_name) FROM Patients;

-- Valid insertion
INSERT INTO Patients
(patient_name, age, gender, phone)
VALUES ('Test Patient', 20, 'Male', '9000000099');

-- This should fail because the age is negative
INSERT INTO Patients
(patient_name, age, gender, phone)
VALUES ('Invalid Patient', -5, 'Male', '9000000088');

-- This should fail because the patient ID does not exist
INSERT INTO Bills (patient_id, amount)
VALUES (999, 500);

CREATE INDEX idx_patient_name
ON Patients(patient_name);

CREATE INDEX idx_appointment_date
ON Appointments(appointment_date);

SHOW INDEX FROM Patients;
SELECT
    A.appointment_id,
    P.patient_name,
    D.doctor_name,
    D.specialization,
    A.appointment_date,
    A.status
FROM Appointments A
JOIN Patients P ON A.patient_id = P.patient_id
JOIN Doctors D ON A.doctor_id = D.doctor_id;

SELECT
    P.patient_name,
    B.amount,
    B.payment_status
FROM Patients P
JOIN Bills B ON P.patient_id = B.patient_id;

-- Patients older than 30
SELECT * FROM Patients WHERE age > 30;

-- Medicines costing between 20 and 60
SELECT * FROM Medicines WHERE price BETWEEN 20 AND 60;

-- Appointments that are scheduled or completed
SELECT * FROM Appointments
WHERE status IN ('Scheduled', 'Completed');

-- Bills that are not paid
SELECT * FROM Bills
WHERE payment_status <> 'Paid';

-- Medicines with low stock
SELECT * FROM Medicines WHERE stock < 30;

SELECT *
FROM Doctors
WHERE consultation_fee > (
    SELECT AVG(consultation_fee)
    FROM Doctors
);

SELECT patient_name
FROM Patients
WHERE patient_id IN (
    SELECT patient_id
    FROM Bills
    WHERE amount > (
        SELECT AVG(amount) FROM Bills
    )
);

SELECT *
FROM Medicines
WHERE price > (
    SELECT AVG(price) FROM Medicines
);


