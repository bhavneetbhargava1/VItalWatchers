USE VitalWatchers;

-- Query 1: Triple Table Join
-- Purpose: Retrieve patient details, their health summary, and provider notes.
-- Summary of Result: This query returns the Patient ID, full name, date of their latest health summary,
--                    and any provider notes associated with that summary.

SELECT p.Patient_ID, CONCAT(p.First_name, ' ', p.Last_name) AS Patient_Name, h.Date, h.Provider_notes
FROM PATIENTS p
         JOIN HEALTH_SUMMARY h ON p.Patient_ID = h.Patient_ID
         JOIN PROVIDERS pr ON h.Provider_ID = pr.Provider_ID;

-- SQL Query 2: Nested Query with IN operator and GROUP BY clause
-- Purpose: Retrieve active patch devices monitoring patients with critical health conditions,
--          grouping by device and health condition.
-- Summary of Result: Displays Device ID, patch status, patient name, critical health condition,
--                    provider notes, and provider's name if available.

SELECT
    pd.Device_ID,
    pd.Patch_Status,
    CONCAT(p.First_name, ' ', p.Last_name) AS Patient_Name,
    hs.Vital_signs AS Health_Condition,
    MAX(hs.Provider_notes) AS Provider_Notes,
    CONCAT(pr.First_name, ' ', pr.Last_name) AS Provider_Name
FROM
    PATCH_DEVICE pd
        JOIN PATIENTS p ON pd.Patient_ID = p.Patient_ID
        JOIN HEALTH_SUMMARY hs ON pd.Patient_ID = hs.Patient_ID
        LEFT JOIN PROVIDERS pr ON hs.Provider_ID = pr.Provider_ID
WHERE
    pd.Patch_Status = 'Active'
  AND hs.Vital_signs IN (
    SELECT Vital_signs
    FROM HEALTH_SUMMARY
    WHERE Vital_signs IN ('High blood pressure', 'High heart rate')
)
GROUP BY
    pd.Device_ID, pd.Patch_Status, p.Patient_ID, hs.Vital_signs, pr.Provider_ID;


-- SQL Query 3: Correlated Nested Query with Proper Aliasing
-- Purpose: Retrieve patients who are 'Under Treatment' or 'Sick' and have an unresolved high-level alert with an active patch device.
-- Summary of Result: This query returns a list of patients who are either 'Under Treatment' or 'Sick'
--                    and have a high-level alert that is unresolved, with their patch device status as active.
SELECT DISTINCT
    p.First_name,
    p.Last_name,
    p.Status,
    a.ALERT_TYPE,
    a.TIME_STAMP
FROM
    PATIENTS AS p
        JOIN ALERTS AS a ON p.Patient_ID = a.PATIENT_ID
WHERE
    p.Status IN ('Under Treatment', 'Sick')
  AND a.ALERT_TYPE = 'HIGH'
  AND a.RESOLVED = 'F'
  AND EXISTS (
    SELECT 1
    FROM PATCH_DEVICE AS pd
    WHERE pd.Patient_ID = p.Patient_ID
      AND pd.Patch_Status = 'Active'
)
ORDER BY
    a.TIME_STAMP DESC;

-- Query 4: Uses a FULL OUTER JOIN
-- purpose: This query retrieves a list of all patients along with the status of any associated patch devices.
-- This includes patients who may not have a patch device and patch devices that may not be assigned to any patient.
-- Summary of result: It shows each patient’s ID, first name, and last name, along with their associated Patch_Status and Vital_Status.

SELECT pname.Patient_ID,
       pname.First_name,
       pname.Last_name,
       pd.Patch_Status,
       pd.Vital_Status
FROM PATIENTS pname
LEFT JOIN PATCH_DEVICE pd ON pname.Patient_ID = pd.Patient_ID

UNION
SELECT pname.Patient_ID,
       pname.First_name,
       pname.Last_name,
       pd.Patch_Status,
       pd.Vital_Status
FROM PATIENTS pname
RIGHT JOIN PATCH_DEVICE pd ON pname.Patient_ID = pd.Patient_ID;


-- Query 7: Create non-trivial SQL query that uses four tables in FROM clause
-- Purpose: This query retrieves a list of patients who have received recent alerts,
--          along with details about the specific alert and the associated provider.
-- Summary of Result: It shows the Patient's name, alert type, time of the alert, provider's name,
--          and any associated notes for monitoring purposes.

SELECT
    PATIENTS.First_name AS Patient_First_Name,
    PATIENTS.Last_name AS Patient_Last_Name,
    ALERTS.Alert_type AS Alert_Type,
    ALERTS.Time_stamp AS Alert_Time,
    PROVIDERS.First_name AS Provider_First_Name,
    PROVIDERS.Last_name AS Provider_Last_Name,
    HEALTH_SUMMARY.Provider_notes AS Provider_Notes
FROM
    PATIENTS
        JOIN
    ALERTS ON PATIENTS.Patient_ID = ALERTS.Patient_ID
        JOIN
    HEALTH_SUMMARY ON PATIENTS.Patient_ID = HEALTH_SUMMARY.Patient_ID
        JOIN
    PROVIDERS ON HEALTH_SUMMARY.Provider_ID = PROVIDERS.Provider_ID
WHERE
    ALERTS.Resolved = 'F';


-- Query 8: Create non-trivial SQL query using nine tables in FROM clause
-- Purpose: This query retrieves detailed patient information related to their patch devices and vital signs, as well
--          as associated alerts and healthcare provider interactions. It aggregates data to analyze each patient's health status
--          and the responsiveness of the healthcare system. The goal is to provide a comprehensive overview of the patient’s medical
--          situation and related activities.
-- Summary of Result: The query returns the unique Patient_ID along with the full Patient_Name and Medical_history. It includes current
--          readings from the patch device, vital signs such as Blood Pressure, Heart Rate, and Oxygen Saturation, as well as aggregated
--          counts of alerts, emergency dispatches, and provider messages. Additionally, it provides average blood pressure readings, minimum
--          oxygen saturation, and counts of test results and resolved alerts, offering a view of the patient's healthcare journey.
SELECT
    PATCH_DEVICE.Patient_ID,
    CONCAT(PATIENTS.First_name, ' ', PATIENTS.Last_name) as Patient_Name,
    PATIENTS.Medical_history,
    PATCH_DEVICE.Vital_Status as Device_Reading,
    PATCH_DEVICE.Patch_Status,
    VITALS.BLOOD_PRESSURE,
    VITALS.HEART_RATE,
    VITALS.OXYGEN_SATURATION,
    COUNT(DISTINCT ALERTS.Alert_ID) as Total_Alerts,
    COUNT(DISTINCT EMERGENCY_DISPATCH.Dispatch_time) as Emergency_Dispatches,
    COUNT(DISTINCT MESSAGES.Message_Content) as Provider_Messages,
    AVG(VITALS.BLOOD_PRESSURE) as Avg_BP,
    MIN(VITALS.OXYGEN_SATURATION) as Min_O2,
    COUNT(DISTINCT TEST_RESULTS.Result) as Test_Count,
    GROUP_CONCAT(DISTINCT TEST_RESULTS.Result) as Test_Outcomes,
    COUNT(DISTINCT PROVIDERS.Provider_ID) as Providers_Involved,
    SUM(ALERTS.RESOLVED = 'T') as Resolved_Alerts
FROM PATCH_DEVICE
         JOIN PATIENTS ON PATCH_DEVICE.Patient_ID = PATIENTS.Patient_ID
         JOIN VITALS ON PATIENTS.Patient_ID = VITALS.PATIENT_ID
         LEFT JOIN ALERTS ON PATCH_DEVICE.Patient_ID = ALERTS.PATIENT_ID
         LEFT JOIN EMERGENCY_DISPATCH ON ALERTS.Alert_ID = EMERGENCY_DISPATCH.Alert_ID
         LEFT JOIN MESSAGES ON PATIENTS.Patient_ID = MESSAGES.Sender_ID
         LEFT JOIN TEST_RESULTS ON PATIENTS.Patient_ID = TEST_RESULTS.Patient_ID
         LEFT JOIN HEALTH_SUMMARY ON PATIENTS.Patient_ID = HEALTH_SUMMARY.Patient_ID
         LEFT JOIN PROVIDERS ON HEALTH_SUMMARY.Provider_ID = PROVIDERS.Provider_ID
GROUP BY
    PATCH_DEVICE.Patient_ID,
    PATIENTS.First_name,
    PATIENTS.Last_name,
    PATIENTS.Medical_history,
    PATCH_DEVICE.Vital_Status,
    PATCH_DEVICE.Patch_Status,
    VITALS.BLOOD_PRESSURE,
    VITALS.HEART_RATE,
    VITALS.OXYGEN_SATURATION
HAVING COUNT(DISTINCT ALERTS.Alert_ID) > 0
ORDER BY
    COUNT(DISTINCT EMERGENCY_DISPATCH.Dispatch_time) DESC,
    MIN(VITALS.OXYGEN_SATURATION) ASC;
