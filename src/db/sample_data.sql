USE VitalWatchers;

-- Insert sample data into PATIENTS table
INSERT INTO PATIENTS (First_name, Last_name, Age, Patient_phone_num, Medical_history, Status, Patient_address, Gender, Email)
VALUES
    ('John', 'Doe', 45, '555-1234', 'None', 'Healthy', '123 Main St', 'Male', 'john.doe@example.com'),
    ('Jane', 'Smith', 34, '555-5678', 'Asthma', 'Under Treatment', '456 Elm St', 'Female', 'jane.smith@example.com'),
    ('Alice', 'Johnson', 29, '555-8765', 'Diabetes', 'Sick', '789 Maple Ave', 'Female', 'alice.johnson@example.com'),
    ('Robert', 'Brown', 58, '555-4321', 'High Blood Pressure', 'Under Treatment', '101 Oak St', 'Male', 'robert.brown@example.com'),
    ('Linda', 'Davis', 65, '555-6543', 'Heart Disease', 'Sick', '202 Pine St', 'Female', 'linda.davis@example.com'),
    ('Michael', 'Wilson', 37, '555-2345', 'None', 'Healthy', '303 Cedar Ave', 'Male', 'michael.wilson@example.com'),
    ('Emily', 'Clark', 23, '555-7890', 'None', 'Healthy', '404 Birch Rd', 'Female', 'emily.clark@example.com'),
    ('David', 'Martinez', 40, '555-3456', 'Asthma', 'Under Treatment', '505 Maple St', 'Male', 'david.martinez@example.com'),
    ('Jessica', 'Lee', 30, '555-5679', 'None', 'Healthy', '606 Palm Dr', 'Female', 'jessica.lee@example.com'),
    ('Daniel', 'Taylor', 50, '555-6789', 'Diabetes', 'Sick', '707 Spruce St', 'Male', 'daniel.taylor@example.com');

-- Insert sample data into PROVIDERS table
INSERT INTO PROVIDERS (First_name, Last_name, Provider_phone_no)
VALUES
    ('Dr. Adam', 'Carter', '555-1122'),
    ('Dr. Emily', 'Parker', '555-3344'),
    ('Dr. Michael', 'White', '555-5566'),
    ('Dr. Sarah', 'Green', '555-7788'),
    ('Dr. Laura', 'Collins', '555-9900'),
    ('Dr. Robert', 'Scott', '555-2233'),
    ('Dr. Linda', 'Brown', '555-4455'),
    ('Dr. James', 'Wilson', '555-6677'),
    ('Dr. Maria', 'Rodriguez', '555-8899'),
    ('Dr. Andrew', 'Kim', '555-0011');

-- Insert sample data into HEALTH_SUMMARY table
INSERT INTO HEALTH_SUMMARY (Patient_ID, Date, Vital_signs, Treatments, Provider_notes, Provider_ID)
VALUES
    (1, '2024-10-01', 'Normal', 'Daily medication', 'Stable', 1),
    (2, '2024-10-02', 'Elevated blood pressure', 'Dietary changes', 'Monitor regularly', 2),
    (3, '2024-10-03', 'Normal', 'None', 'No issues', 3),
    (4, '2024-10-04', 'High blood pressure', 'Medication', 'Monitor closely', 4),
    (5, '2024-10-05', 'Low oxygen', 'Oxygen therapy', 'Improving', 5),
    (6, '2024-10-06', 'Normal', 'None', 'Stable', 6),
    (7, '2024-10-07', 'High heart rate', 'Exercise adjustments', 'Needs follow-up', 7),
    (8, '2024-10-08', 'Normal', 'None', 'No concerns', 8),
    (9, '2024-10-09', 'High blood pressure', 'Medication', 'Monitor closely', 9),
    (10, '2024-10-10', 'Elevated heart rate', 'Dietary changes', 'Improving', 10);

-- Insert sample data into VITALS table
INSERT INTO VITALS (PATIENT_ID, BLOOD_PRESSURE, HEART_RATE, BODY_TEMPERATURE, OXYGEN_SATURATION, BREATHING_RATE, TIME_STAMP, DEVICE_ID)
VALUES
    (1, 120.5, 80.0, 98.6, 98.0, 16.0, '2024-10-01 08:00:00', 1),
    (2, 140.0, 85.0, 98.2, 96.0, 18.0, '2024-10-02 09:00:00', 2),
    (3, 110.0, 78.0, 98.4, 97.0, 17.0, '2024-10-03 07:30:00', 1),
    (4, 135.0, 90.0, 98.3, 95.0, 19.0, '2024-10-04 10:00:00', 2),
    (5, 125.0, 82.0, 98.1, 94.0, 15.0, '2024-10-05 11:00:00', 3),
    (6, 119.0, 79.0, 98.5, 98.5, 16.0, '2024-10-06 08:45:00', 1),
    (7, 138.0, 92.0, 98.6, 92.0, 18.0, '2024-10-07 07:00:00', 3),
    (8, 118.0, 81.0, 98.2, 96.0, 17.0, '2024-10-08 06:30:00', 4),
    (9, 123.0, 80.0, 98.7, 97.0, 16.5, '2024-10-09 08:15:00', 2),
    (10, 135.0, 88.0, 98.3, 95.0, 18.5, '2024-10-10 09:30:00', 4);

-- Insert sample data into ALERTS table
INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
VALUES
    (1, 'HIGH', '2024-10-04 10:00:00', 'F', 1),
    (2, 'LOW', '2024-10-05 11:30:00', 'T', 2),
    (3, 'MEDIUM', '2024-10-06 08:45:00', 'F', 1),
    (4, 'HIGH', '2024-10-07 07:00:00', 'F', 3),
    (5, 'LOW', '2024-10-08 06:30:00', 'T', 4),
    (6, 'MEDIUM', '2024-10-09 08:15:00', 'F', 2),
    (7, 'HIGH', '2024-10-10 09:30:00', 'F', 4),
    (8, 'MEDIUM', '2024-10-11 08:00:00', 'T', 1),
    (9, 'LOW', '2024-10-12 09:30:00', 'F', 2),
    (10, 'HIGH', '2024-10-13 10:30:00', 'F', 3);

-- Insert sample data into VITAL_THRESHOLDS table
INSERT INTO VITAL_THRESHOLDS (Patient_ID, Provider_ID, Vital_type, Minimum_value, Maximum_value, Time_stamp)
VALUES
    (1, 1, 'Blood Pressure', 80.0, 140.0, '2024-10-01 08:00:00'),
    (2, 2, 'Heart Rate', 60.0, 100.0, '2024-10-02 09:00:00'),
    (3, 3, 'Body Temperature', 97.0, 99.0, '2024-10-03 07:30:00'),
    (4, 4, 'Oxygen Saturation', 90.0, 100.0, '2024-10-04 10:00:00'),
    (5, 5, 'Breathing Rate', 12.0, 20.0, '2024-10-05 11:00:00'),
    (6, 6, 'Blood Pressure', 80.0, 140.0, '2024-10-06 08:45:00'),
    (7, 7, 'Heart Rate', 60.0, 100.0, '2024-10-07 07:00:00'),
    (8, 8, 'Body Temperature', 97.0, 99.0, '2024-10-08 06:30:00'),
    (9, 9, 'Oxygen Saturation', 90.0, 100.0, '2024-10-09 08:15:00'),
    (10, 10, 'Breathing Rate', 12.0, 20.0, '2024-10-10 09:30:00');

-- Insert sample data into EMERGENCY_DISPATCH table
INSERT INTO EMERGENCY_DISPATCH (Patient_ID, Alert_ID, Dispatch_time, Arrival_time, Status, Notes, Patient_address)
VALUES
    (1, 1, '2024-10-04 10:05:00', '2024-10-04 10:30:00', 'Arrived', 'Emergency handled', '123 Main St'),
    (2, 2, '2024-10-05 11:35:00', NULL, 'Pending', 'Awaiting dispatch', '456 Elm St'),
    (3, 3, '2024-10-06 08:15:00', '2024-10-06 08:45:00', 'Arrived', 'Patient stabilized', '789 Maple Ave'),
    (4, 4, '2024-10-07 07:20:00', '2024-10-07 07:45:00', 'Arrived', 'Patient transported to ER', '101 Oak St'),
    (5, 5, '2024-10-08 06:00:00', '2024-10-08 06:25:00', 'Arrived', 'Patient received oxygen therapy', '202 Pine St'),
    (6, 6, '2024-10-09 09:45:00', NULL, 'Pending', 'Dispatch in progress', '303 Cedar Ave'),
    (7, 7, '2024-10-10 09:00:00', '2024-10-10 09:30:00', 'Arrived', 'Patient received medication', '404 Birch Rd'),
    (8, 8, '2024-10-11 08:20:00', NULL, 'Pending', 'Dispatch delayed due to traffic', '505 Maple St'),
    (9, 9, '2024-10-12 07:15:00', '2024-10-12 07:50:00', 'Arrived', 'Patient stabilized on scene', '606 Palm Dr'),
    (10, 10, '2024-10-13 10:10:00', '2024-10-13 10:40:00', 'Arrived', 'Patient transported to hospital', '707 Spruce St');

-- Insert sample data into MESSAGES table
INSERT INTO MESSAGES (Message_Content, Time_Sent, Sender_ID)
VALUES
    ('Patient showing signs of improvement.', '2024-10-01 09:00:00', 1),
    ('Schedule follow-up for blood pressure check.', '2024-10-02 10:00:00', 2),
    ('Patient requires new prescription for diabetes.', '2024-10-03 11:30:00', 3),
    ('Alert triggered for elevated heart rate.', '2024-10-04 08:45:00', 4),
    ('Update on patient condition needed.', '2024-10-05 09:15:00', 5),
    ('Patient stable, no new symptoms.', '2024-10-06 10:30:00', 6),
    ('Blood test results show normal levels.', '2024-10-07 11:00:00', 7),
    ('Patient requires emergency check.', '2024-10-08 08:00:00', 8),
    ('Confirm patient appointment for next week.', '2024-10-09 07:45:00', 9),
    ('Request additional test for oxygen saturation.', '2024-10-10 09:30:00', 10);

-- Insert sample data into USER_AUTHORIZATION table
INSERT INTO USER_AUTHORIZATION (Patient_ID, User_code, Activation)
VALUES
    (1, 'A1234', TRUE),
    (2, 'B5678', FALSE),
    (3, 'C9101', TRUE),
    (4, 'D1123', TRUE),
    (5, 'E1415', FALSE),
    (6, 'F1617', TRUE),
    (7, 'G1819', FALSE),
    (8, 'H2021', TRUE),
    (9, 'I2223', TRUE),
    (10, 'J2425', FALSE);

-- Insert sample data into TEST_RESULTS table
INSERT INTO TEST_RESULTS (Patient_ID, Provider_ID, Alert_ID, Result, Test_date)
VALUES
    (1, 1, 1, 'Positive', '2024-10-01'),
    (2, 2, 2, 'Negative', '2024-10-02'),
    (3, 3, 3, 'Pending', '2024-10-03'),
    (4, 4, 4, 'Positive', '2024-10-04'),
    (5, 5, 5, 'Negative', '2024-10-05'),
    (6, 6, 6, 'Inconclusive', '2024-10-06'),
    (7, 7, 7, 'Pending', '2024-10-07'),
    (8, 8, 8, 'Positive', '2024-10-08'),
    (9, 9, 9, 'Negative', '2024-10-09'),
    (10, 10, 10, 'Inconclusive', '2024-10-10');

-- Insert sample data into PATCH_DEVICE table
INSERT INTO PATCH_DEVICE (Patient_ID, Vital_Status, Patch_Status, Thresholds_ID)
VALUES
    (1, 'Normal', 'Active', 1),
    (2, 'Critical', 'Inactive', 2),
    (3, 'Warning', 'Maintenance', 3),
    (4, 'Normal', 'Active', 4),
    (5, 'Critical', 'Inactive', 5),
    (6, 'Warning', 'Maintenance', 6),
    (7, 'Normal', 'Active', 7),
    (8, 'Warning', 'Inactive', 8),
    (9, 'Critical', 'Active', 9),
    (10, 'Normal', 'Maintenance', 10);

;


