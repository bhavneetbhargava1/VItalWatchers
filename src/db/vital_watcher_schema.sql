CREATE DATABASE VitalWatchers;

USE VitalWatchers;

-- Patients table
CREATE TABLE PATIENTS (
                          Patient_ID           INT AUTO_INCREMENT NOT NULL,
                          First_name           VARCHAR(50)        NOT NULL,
                          Last_name            VARCHAR(50)        NOT NULL,
                          Age                  INT                NOT NULL CHECK (Age > 0 AND Age <= 120),
                          Patient_phone_num    VARCHAR(15)        DEFAULT 'Not Provided',
                          Medical_history      VARCHAR(100)       DEFAULT 'No history provided',
                          Status               VARCHAR(20)        NOT NULL CHECK (Status IN ('Healthy', 'Sick', 'Under Treatment')),
                          Patient_address      VARCHAR(100)       NOT NULL,
                          Gender               VARCHAR(10)        NOT NULL CHECK (Gender IN ('Male', 'Female', 'Other')),
                          Email                VARCHAR(100)       NOT NULL,
                          PRIMARY KEY (Patient_ID)
);

-- Providers table
CREATE TABLE PROVIDERS (
                           Provider_ID          INT AUTO_INCREMENT NOT NULL,
                           First_name           VARCHAR(50)        NOT NULL,
                           Last_name            VARCHAR(50)        NOT NULL,
                           Provider_phone_no    VARCHAR(15)        NOT NULL,
                           PRIMARY KEY (Provider_ID)
);

-- Health Summary table
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


-- Vitals table
CREATE TABLE VITALS (
                        VITAL_ID            INT AUTO_INCREMENT NOT NULL,
                        PATIENT_ID          INT                NOT NULL,
                        BLOOD_PRESSURE      DECIMAL(5, 2)      NOT NULL CHECK (BLOOD_PRESSURE > 40 AND BLOOD_PRESSURE < 250),
                        HEART_RATE          DECIMAL(5, 2)      NOT NULL CHECK (HEART_RATE > 30 AND HEART_RATE < 200),
                        BODY_TEMPERATURE    DECIMAL(5, 2)      DEFAULT 98.6 NOT NULL CHECK (BODY_TEMPERATURE > 95 AND BODY_TEMPERATURE < 108),
                        OXYGEN_SATURATION   DECIMAL(5, 2)      DEFAULT 100 NOT NULL CHECK (OXYGEN_SATURATION > 80 AND OXYGEN_SATURATION <= 100),
                        BREATHING_RATE      DECIMAL(5, 2)      DEFAULT 16 NOT NULL CHECK (BREATHING_RATE > 10 AND BREATHING_RATE < 40),
                        TIME_STAMP          DATETIME           NOT NULL,
                        DEVICE_ID           INT                NOT NULL,
                        PRIMARY KEY (VITAL_ID),
                        FOREIGN KEY (PATIENT_ID) REFERENCES PATIENTS(Patient_ID)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);

-- Alerts table
CREATE TABLE ALERTS (
                        ALERT_ID            INT AUTO_INCREMENT NOT NULL,
                        PATIENT_ID          INT                NOT NULL,
                        ALERT_TYPE          VARCHAR(10)        NOT NULL CHECK (ALERT_TYPE IN ('LOW', 'MEDIUM', 'HIGH')),
                        TIME_STAMP          DATETIME           NOT NULL,
                        RESOLVED            CHAR(1)            NOT NULL DEFAULT 'F',
                        DEVICE_ID           INT                NOT NULL,
                        PRIMARY KEY (ALERT_ID),
                        FOREIGN KEY (PATIENT_ID) REFERENCES PATIENTS(Patient_ID)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);
