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
                          Gender               VARCHAR(10)        NOT NULL CHECK (Gender IN ('Male', 'Female')),
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

-- Vital Thresholds table
CREATE TABLE VITAL_THRESHOLDS (
                                  Thresholds_ID     INT AUTO_INCREMENT NOT NULL,
                                  Vital_category    VARCHAR(50)        NOT NULL,
                                  Vital_level       VARCHAR(50)        NOT NULL,
                                  Minimum_value     DECIMAL(5, 2)      NOT NULL,
                                  Maximum_value     DECIMAL(5, 2)      NOT NULL,
                                  PRIMARY KEY (Thresholds_ID),
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
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.DEVICE_ID);
    END IF;

    IF NEW.HEART_RATE < min_hr OR NEW.HEART_RATE > max_hr THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.DEVICE_ID);
    END IF;

    IF NEW.BODY_TEMPERATURE < min_temp OR NEW.BODY_TEMPERATURE > max_temp THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.DEVICE_ID);
    END IF;

    IF NEW.OXYGEN_SATURATION < min_oxy OR NEW.OXYGEN_SATURATION > max_oxy THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.DEVICE_ID);
    END IF;

    IF NEW.BREATHING_RATE < min_breath OR NEW.BREATHING_RATE > max_breath THEN
        INSERT INTO ALERTS (PATIENT_ID, ALERT_TYPE, TIME_STAMP, RESOLVED, DEVICE_ID)
        VALUES (NEW.PATIENT_ID, 'HIGH', NEW.TIME_STAMP, 'F', NEW.DEVICE_ID);
    END IF;
END;

DELIMITER ;


-- Emergency Dispatch table
CREATE TABLE EMERGENCY_DISPATCH (
                                    Dispatch_ID        INT AUTO_INCREMENT NOT NULL,
                                    Patient_ID         INT                NOT NULL,
                                    Alert_ID           INT                NOT NULL,
                                    Dispatch_time      DATETIME           NOT NULL,
                                    Arrival_time       DATETIME           DEFAULT NULL,
                                    Status             VARCHAR(20)        NOT NULL CHECK (Status IN ('Pending', 'Dispatched', 'Arrived', 'Resolved')),
                                    Notes              TEXT,
                                    Patient_address    VARCHAR(100)       NOT NULL,
                                    PRIMARY KEY (Dispatch_ID),
                                    FOREIGN KEY (Patient_ID) REFERENCES PATIENTS(Patient_ID)
                                        ON DELETE CASCADE
                                        ON UPDATE CASCADE,
                                    FOREIGN KEY (Alert_ID) REFERENCES ALERTS(Alert_ID)
                                        ON DELETE CASCADE
                                        ON UPDATE CASCADE
);

-- Messages table
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

-- User Authorization table
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

-- Test Results table
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

-- Patch Device table
CREATE TABLE PATCH_DEVICE (
                              Device_ID            INT AUTO_INCREMENT NOT NULL,
                              Patient_ID           INT                NOT NULL,
                              Vital_Status         VARCHAR(20)        NOT NULL CHECK (Vital_Status IN ('Normal', 'Critical', 'Warning')),
                              Patch_Status         VARCHAR(20)        NOT NULL CHECK (Patch_Status IN ('Active', 'Inactive', 'Maintenance')),
                              Patient_add          VARCHAR(100)       NOT NULL,
                              Thresholds_ID        INT                DEFAULT NULL,
                              PRIMARY KEY (Device_ID),
                              FOREIGN KEY (Patient_ID, Patient_add) REFERENCES PATIENTS(Patient_ID, Patient_address)
                                  ON DELETE CASCADE
                                  ON UPDATE CASCADE,
                              FOREIGN KEY (Thresholds_ID) REFERENCES VITAL_THRESHOLDS(Thresholds_ID)
                                  ON DELETE SET NULL
                                  ON UPDATE CASCADE
);