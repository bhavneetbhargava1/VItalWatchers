/* ********************************
Project Phase II
Group 7 (MySQL)
This SQL Script was tested on
MySQL Workbench and hosted on IntelliJ.
To run, simply load this script file and execute while you have
a MySQL connection active.
******************************** */

-- ***************************
-- Part A: Database Schema Creation
-- ***************************

-- DATABASE: VitalWatchers
CREATE DATABASE VitalWatchers;
USE VitalWatchers;

-- TABLE: PATIENTS
-- Purpose: Stores details of patients including personal information and health status.
CREATE TABLE PATIENTS (
                          Patient_ID           INT AUTO_INCREMENT NOT NULL,
                          First_name           VARCHAR(50)        NOT NULL,
                          Last_name            VARCHAR(50)        NOT NULL,
                          Age                  INT                NOT NULL CHECK (Age > 0 AND Age <= 120),
                          Patient_phone_num    VARCHAR(15)        DEFAULT 'Not Provided',
                          Medical_history      VARCHAR(100)       DEFAULT 'No history provided',
                          Patient_status       VARCHAR(20)        NOT NULL CHECK (Patient_status IN ('Healthy', 'Sick', 'Under Treatment')),
                          Patient_address      VARCHAR(100)       NOT NULL,
                          Gender               VARCHAR(10)        NOT NULL CHECK (Gender IN ('Male', 'Female')),
                          Email                VARCHAR(100)       NOT NULL,
                          PRIMARY KEY (Patient_ID),
                          UNIQUE (Email, Patient_phone_num),
                          UNIQUE (Patient_address),
                          UNIQUE (Patient_ID, Patient_address)
);



-- TABLE: PROVIDERS
-- Purpose: Stores provider information, including contact details
CREATE TABLE PROVIDERS (
                           Provider_ID          INT AUTO_INCREMENT NOT NULL,
                           First_name           VARCHAR(50)        NOT NULL,
                           Last_name            VARCHAR(50)        NOT NULL,
                           Provider_phone_no    VARCHAR(15)        NOT NULL,
                           PRIMARY KEY (Provider_ID)
);

-- TABLE: HEALTH_SUMMARY
-- Purpose: Records health summaries for patients, including vital signs and provider notes.
CREATE TABLE HEALTH_SUMMARY (
                                Health_Summary_ID    INT AUTO_INCREMENT NOT NULL,
                                Patient_ID           INT                NOT NULL,
                                Date                 DATE               NOT NULL,
                                Vital_signs          VARCHAR(100)       DEFAULT 'No vitals',
                                Treatments           VARCHAR(100)       DEFAULT 'No treatments',
                                Provider_notes       VARCHAR(100)       DEFAULT 'No notes provided',
                                Provider_ID          INT                DEFAULT NULL,
                                PRIMARY KEY (Health_Summary_ID),
                                FOREIGN KEY (Patient_ID) REFERENCES PATIENTS(Patient_ID)
                                    ON DELETE CASCADE
                                    ON UPDATE CASCADE,
                                FOREIGN KEY (Provider_ID) REFERENCES PROVIDERS(Provider_ID)
                                    ON DELETE SET NULL
                                    ON UPDATE CASCADE
);

-- VITALS table
-- Purpose: Stores patient vital information, including blood pressure, heart rate, body temperature,
--          oxygen saturation, and breathing rate. Each entry is timestamped and linked to a device.
CREATE TABLE VITALS (
                        VITAL_ID            INT AUTO_INCREMENT NOT NULL,
                        PATIENT_ID          INT                NOT NULL,
                        BLOOD_PRESSURE      DECIMAL(5, 2)      NOT NULL CHECK (BLOOD_PRESSURE > 40 AND BLOOD_PRESSURE < 250),
                        HEART_RATE          DECIMAL(5, 2)      NOT NULL CHECK (HEART_RATE > 30 AND HEART_RATE < 200),
                        BODY_TEMPERATURE    DECIMAL(5, 2)      DEFAULT 98.6 NOT NULL CHECK (BODY_TEMPERATURE > 95 AND BODY_TEMPERATURE < 108),
                        OXYGEN_SATURATION   DECIMAL(5, 2)      DEFAULT 100 NOT NULL CHECK (OXYGEN_SATURATION > 80 AND OXYGEN_SATURATION <= 100),
                        BREATHING_RATE      DECIMAL(5, 2)      DEFAULT 16 NOT NULL CHECK (BREATHING_RATE > 10 AND BREATHING_RATE < 40),
                        TIME_STAMP          DATETIME           NOT NULL,
                        D_TRIGGER           INT                NOT NULL,
                        PRIMARY KEY (VITAL_ID),
                        FOREIGN KEY (PATIENT_ID) REFERENCES PATIENTS(Patient_ID)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);

-- VITAL_THRESHOLDS table
-- Purpose: Stores threshold ranges for each vital category (e.g., blood pressure, heart rate)
--          to define normal and abnormal levels for alerts.
CREATE TABLE VITAL_THRESHOLDS (
                                  Thresholds_ID     INT AUTO_INCREMENT NOT NULL,
                                  Vital_category    VARCHAR(50)        NOT NULL,
                                  Vital_level       VARCHAR(50)        NOT NULL,
                                  Minimum_value     DECIMAL(5, 2)      NOT NULL,
                                  Maximum_value     DECIMAL(5, 2)      NOT NULL,
                                  PRIMARY KEY (Thresholds_ID),
                                  UNIQUE (Thresholds_ID, Vital_level),
                                  UNIQUE (Vital_category, Vital_level)
);


DELIMITER //

CREATE TRIGGER trg_check_vitals
    AFTER INSERT ON VITALS
    FOR EACH ROW
BEGIN
    DECLARE min_bp, max_bp, min_hr, max_hr, min_temp, max_temp, min_oxy, max_oxy, min_breath, max_breath DECIMAL(5,2);

    -- Retrieve general thresholds for each vital category with the 'Normal' level
    SELECT Minimum_value, Maximum_value INTO min_bp, max_bp
    FROM VITAL_THRESHOLDS
    WHERE Vital_category = 'Blood Pressure' AND Vital_level = 'Normal';

    SELECT Minimum_value, Maximum_value INTO min_hr, max_hr
    FROM VITAL_THRESHOLDS
    WHERE Vital_category = 'Heart Rate' AND Vital_level = 'Normal';

    SELECT Minimum_value, Maximum_value INTO min_temp, max_temp
    FROM VITAL_THRESHOLDS
    WHERE Vital_category = 'Body Temperature' AND Vital_level = 'Normal';

    SELECT Minimum_value, Maximum_value INTO min_oxy, max_oxy
    FROM VITAL_THRESHOLDS
    WHERE Vital_category = 'Oxygen Saturation' AND Vital_level = 'Normal';

    SELECT Minimum_value, Maximum_value INTO min_breath, max_breath
    FROM VITAL_THRESHOLDS
    WHERE Vital_category = 'Breathing Rate' AND Vital_level = 'Normal';

    -- Check each vital and insert alerts if they exceed general thresholds
    IF NEW.BLOOD_PRESSURE < min_bp OR NEW.BLOOD_PRESSURE > max_bp THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.D_TRIGGER);
    END IF;

    IF NEW.HEART_RATE < min_hr OR NEW.HEART_RATE > max_hr THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.D_TRIGGER);
    END IF;

    IF NEW.BODY_TEMPERATURE < min_temp OR NEW.BODY_TEMPERATURE > max_temp THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.D_TRIGGER);
    END IF;

    IF NEW.OXYGEN_SATURATION < min_oxy OR NEW.OXYGEN_SATURATION > max_oxy THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.D_TRIGGER);
    END IF;

    IF NEW.BREATHING_RATE < min_breath OR NEW.BREATHING_RATE > max_breath THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.D_TRIGGER);
    END IF;
END;

DELIMITER ;


-- PATCH_DEVICE table
-- Purpose: Tracks wearable patch devices for each patient, including device status,
--          associated thresholds, and patient address for monitoring.
CREATE TABLE PATCH_DEVICE (
                              Device_ID            INT AUTO_INCREMENT NOT NULL,
                              Patient_ID           INT                NOT NULL,
                              Vital_Status         VARCHAR(20),
                              Patch_Status         VARCHAR(20)        NOT NULL CHECK (Patch_Status IN ('Active', 'Inactive', 'Maintenance')),
                              Patient_add          VARCHAR(100)       NOT NULL,
                              Thresholds_ID        INT                DEFAULT NULL,
                              PRIMARY KEY (Device_ID),
                              FOREIGN KEY (Patient_ID) REFERENCES PATIENTS(Patient_ID)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE,
                              FOREIGN KEY (Thresholds_ID) REFERENCES VITAL_THRESHOLDS(Thresholds_ID)
                                  ON DELETE SET NULL
                                  ON UPDATE CASCADE
);



-- ALERTS table
-- Purpose: Records alerts generated for patients based on abnormal vital signs,
--          including alert type, timestamp, and resolution status.
CREATE TABLE ALERTS (
                        ALERT_ID            INT AUTO_INCREMENT NOT NULL,
                        PATIENT_ID          INT                NOT NULL,
                        ALERT_TYPE          VARCHAR(10)        NOT NULL CHECK (ALERT_TYPE IN ('LOW', 'MEDIUM', 'HIGH', 'NORMAL', 'CRITICAL', 'ELEVATED')),
                        TIME_STAMP          DATETIME           NOT NULL,
                        RESOLVED            CHAR(1)            NOT NULL DEFAULT 'F',
                        DEVICE_ID           INT                NOT NULL,
                        PRIMARY KEY (ALERT_ID),
                        FOREIGN KEY (PATIENT_ID) REFERENCES PATIENTS(Patient_ID)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE,
                        FOREIGN KEY (DEVICE_ID) REFERENCES PATCH_DEVICE(Device_ID)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);



-- EMERGENCY_DISPATCH table
-- Purpose: Manages dispatch records for emergency alerts, capturing details such as dispatch
--          time, arrival time, status, and associated patient details.
CREATE TABLE EMERGENCY_DISPATCH (
                                    Dispatch_ID        INT AUTO_INCREMENT NOT NULL,
                                    Patient_ID         INT                NOT NULL,
                                    Alert_ID           INT                NOT NULL,
                                    Dispatch_time      DATETIME           DEFAULT NULL,
                                    Arrival_time       DATETIME           DEFAULT NULL,
                                    Status             VARCHAR(20)        NOT NULL CHECK (Status IN ('Pending', 'Dispatched', 'Arrived', 'Resolved')),
                                    Notes              TEXT,
                                    Patient_address    VARCHAR(100)       NOT NULL,
                                    PRIMARY KEY (Dispatch_ID),
                                    FOREIGN KEY (Patient_ID, Patient_address) REFERENCES PATIENTS(Patient_ID, Patient_address)
                                        ON DELETE CASCADE
                                        ON UPDATE CASCADE,
                                    FOREIGN KEY (Alert_ID) REFERENCES ALERTS(Alert_ID)
                                        ON DELETE CASCADE
                                        ON UPDATE CASCADE
);


-- MESSAGES table
-- Purpose: Stores messages related to patient health status, sent by providers, with each
--          message linked to a provider and timestamped.
CREATE TABLE MESSAGES (
                          Message_ID         INT AUTO_INCREMENT NOT NULL,
                          Message_Content    TEXT               NOT NULL,
                          Time_Sent          DATETIME           NOT NULL,
                          Sender_ID          INT                DEFAULT NULL,
                          PRIMARY KEY (Message_ID),
                          FOREIGN KEY (Sender_ID) REFERENCES PROVIDERS(Provider_ID)
                              ON DELETE SET NULL
                              ON UPDATE CASCADE
);

-- USER_AUTHORIZATION table
-- Purpose: Manages user access to the system, including their email, phone number,
--          unique access code, and activation status.
CREATE TABLE USER_AUTHORIZATION (
                                    User_ID            INT AUTO_INCREMENT NOT NULL,
                                    Email              VARCHAR(100)       NOT NULL,
                                    Patient_phone_num  VARCHAR(15)        NOT NULL,
                                    User_code          VARCHAR(10)        NOT NULL,
                                    Activation         BOOLEAN            DEFAULT FALSE,
                                    PRIMARY KEY (User_ID),
                                    FOREIGN KEY (Email, Patient_phone_num) REFERENCES PATIENTS(Email, Patient_phone_num)
                                        ON DELETE CASCADE
                                        ON UPDATE CASCADE
);

-- TEST_RESULTS table
-- Purpose: Logs test results for patients, linking them with alerts and providers,
--          including test outcome and date.
CREATE TABLE TEST_RESULTS (
                              Test_Result_ID     INT AUTO_INCREMENT NOT NULL,
                              Patient_ID         INT                NOT NULL,
                              Provider_ID        INT                DEFAULT NULL,
                              Alert_ID           INT                DEFAULT NULL,
                              Result             VARCHAR(100)       DEFAULT 'Pending',
                              Test_date          DATE               NOT NULL,
                              PRIMARY KEY (Test_Result_ID),
                              FOREIGN KEY (Patient_ID) REFERENCES PATIENTS(Patient_ID)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE,
                              FOREIGN KEY (Provider_ID) REFERENCES PROVIDERS(Provider_ID)
                                  ON DELETE SET NULL
                                  ON UPDATE CASCADE,
                              FOREIGN KEY (Alert_ID) REFERENCES ALERTS(Alert_ID)
                                  ON DELETE SET NULL
                                  ON UPDATE CASCADE
);


