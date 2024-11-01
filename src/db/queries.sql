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


-- Query 7: Create non-trivial SQL query that uses two tables in FROM clause
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


