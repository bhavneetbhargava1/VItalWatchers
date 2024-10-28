# ***Vital Watchers Database Schema***

This project contains the database schema for the **Vital Watchers** system, designed to track and monitor patient health data, emergency dispatches, test results, and vital thresholds. The schema is built using **MySQL** and includes various tables, constraints, triggers, and foreign key relationships to ensure data integrity, optimize relational connections, and minimize redundancy.

---

## ***Project Overview***

The **Vital Watchers** database schema supports the following core functionalities:

- **Patient Information Management**: Stores details about each patient, including personal information, medical history, and contact details.
- **Provider Management**: Stores details about healthcare providers who interact with patients or manage their health data.
- **Vital Monitoring**: Records and monitors key vitals like blood pressure, heart rate, body temperature, oxygen saturation, and breathing rate.
- **Alerts and Emergency Dispatches**: Tracks alerts triggered by abnormal vitals and manages emergency dispatches associated with specific alerts.
- **Test Results and Authorization**: Manages lab test results and tracks user authorization details related to patient records.
- **Device and Patch Management**: Monitors the operational status of devices/patches used to track patient vitals and stores related threshold parameters for critical monitoring.

---

## ***Database Schema and Table Descriptions***

### **1. Patients Table**

Stores core data for each patient, including name, age, phone number, medical history, and address.

- **Key Attributes**:
    - `Patient_ID`: Primary key.
    - `First_name`, `Last_name`, `Age`, `Gender`: Personal details.
    - `Patient_phone_num`, `Email`: Contact details.
    - `Medical_history`, `Status`, `Patient_address`: Medical details.
- **Constraints**:
    - `CHECK` constraints to validate age range, gender, and patient status.

### **2. Providers Table**

Stores details about healthcare providers who interact with patients or manage their data.

- **Key Attributes**:
    - `Provider_ID`: Primary key.
    - `First_name`, `Last_name`, `Provider_phone_no`: Provider details.

### **3. Health Summary Table**

Records information related to the patient's health summary, including vital signs, treatments, and provider notes.

- **Key Attributes**:
    - `Health_Summary_ID`: Primary key.
    - `Patient_ID`, `Provider_ID`: Foreign keys linking to `PATIENTS` and `PROVIDERS`.
    - `Vital_signs`, `Treatments`, `Provider_notes`: Summary details.
- **Constraints**:
    - Foreign key constraints with `ON DELETE CASCADE` and `ON UPDATE CASCADE`.

### **4. Vitals Table**

Tracks the patient's vital signs, such as blood pressure, heart rate, body temperature, oxygen saturation, and breathing rate.

- **Key Attributes**:
    - `VITAL_ID`: Primary key.
    - `PATIENT_ID`: Foreign key linking to `PATIENTS`.
    - Various vitals, including `BLOOD_PRESSURE`, `HEART_RATE`, `BODY_TEMPERATURE`, etc.
- **Constraints**:
    - `CHECK` constraints to validate realistic ranges for each vital.

### **5. Alerts Table**

Stores alerts triggered by abnormal patient vitals and flags if the alert has been resolved.

- **Key Attributes**:
    - `ALERT_ID`: Primary key.
    - `PATIENT_ID`: Foreign key linking to `PATIENTS`.
    - `ALERT_TYPE`, `TIME_STAMP`, `RESOLVED`: Alert details.
- **Constraints**:
    - `CHECK` constraint to validate alert types (`LOW`, `MEDIUM`, `HIGH`).

### **6. Vital Thresholds Table**

Defines threshold values for each vital, used to trigger alerts when thresholds are breached.

- **Key Attributes**:
    - `Thresholds_ID`: Primary key.
    - `Patient_ID`, `Provider_ID`: Foreign keys linking to `PATIENTS` and `PROVIDERS`.
    - `Vital_type`, `Minimum_value`, `Maximum_value`, `Time_stamp`: Threshold settings.
- **Constraints**:
    - `CHECK` constraints on `Minimum_value`.
    - Trigger to ensure `Maximum_value` is greater than `Minimum_value`.

### **7. Emergency Dispatch Table**

Tracks emergency dispatch information, including dispatch and arrival times, status, and notes.

- **Key Attributes**:
    - `Dispatch_ID`: Primary key.
    - `Patient_ID`, `Alert_ID`: Foreign keys linking to `PATIENTS` and `ALERTS`.
    - `Dispatch_time`, `Arrival_time`, `Status`, `Notes`, `Patient_address`: Dispatch details.
- **Constraints**:
    - `CHECK` constraint on `Status` (e.g., `Pending`, `Dispatched`, `Arrived`, `Resolved`).

### **8. Messages Table**

Stores messages sent by providers, including the message content and sender information.

- **Key Attributes**:
    - `Message_ID`: Primary key.
    - `Sender_ID`: Foreign key linking to `PROVIDERS`.
    - `Message_Content`, `Time_Sent`: Message details.

### **9. User Authorization Table**

Tracks authorization details for users linked to patients, handling activation status and unique user codes.

- **Key Attributes**:
    - `User_ID`: Primary key.
    - `Patient_ID`: Foreign key linking to `PATIENTS`.
    - `User_code`, `Activation`: Authorization details.

### **10. Test Results Table**

Records results of medical tests performed on patients, with links to the provider and any associated alert.

- **Key Attributes**:
    - `Test_Result_ID`: Primary key.
    - `Patient_ID`, `Provider_ID`, `Alert_ID`: Foreign keys linking to `PATIENTS`, `PROVIDERS`, and `ALERTS`.
    - `Result`, `Test_date`: Test result details.
- **Constraints**:
    - Default `Result` set to `Pending`.

### **11. Patch Device Table**

Tracks the status of devices or patches used to monitor patient vitals.

- **Key Attributes**:
    - `Device_ID`: Primary key.
    - `Patient_ID`, `Thresholds_ID`: Foreign keys linking to `PATIENTS` and `VITAL_THRESHOLDS`.
    - `Vital_Status`, `Patch_Status`: Device operational status.

---

## ***Key Features and Constraints***

1. **Foreign Key Relationships**: Each table includes foreign keys to create strong relational links between entities, ensuring referential integrity across the schema.

2. **CHECK Constraints**: Key fields, such as `Age`, `Vital ranges`, `Status`, and `Alert types`, are validated using `CHECK` constraints to prevent invalid data entries.

3. **Triggers**: A trigger is used in the `VITAL_THRESHOLDS` table to ensure `Maximum_value` is always greater than `Minimum_value` due to MySQL’s limitation on cross-column `CHECK` constraints.

4. **ON DELETE/ON UPDATE Actions**: Foreign keys are designed with `ON DELETE` and `ON UPDATE` actions to handle cascading deletions and updates, preserving data integrity when rows in referenced tables are modified.

---
