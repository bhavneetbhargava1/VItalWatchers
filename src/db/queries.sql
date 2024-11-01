USE VitalWatchers;

-- Query 1: Triple Table Join
-- Purpose: Retrieve patient details, their health summary, and provider notes.
-- Expected Result: Displays each patient's name, date of health summary, and provider notes.
SELECT p.Patient_ID, CONCAT(p.First_name, ' ', p.Last_name) AS Patient_Name, h.Date, h.Provider_notes
FROM PATIENTS p
         JOIN HEALTH_SUMMARY h ON p.Patient_ID = h.Patient_ID
         JOIN PROVIDERS pr ON h.Provider_ID = pr.Provider_ID;

-- SQL Query 2: Correlated Nested Query with Proper Aliasing
-- Purpose: Retrieve patients who are 'Under Treatment' or 'Sick' and have an unresolved high-level alert with an active patch device.

SELECT DISTINCT
    p.First_name,                   -- Patient's first name
    p.Last_name,                    -- Patient's last name
    p.Status,                       -- Patient's health status ('Under Treatment' or 'Sick')
    a.ALERT_TYPE,                   -- Alert type (HIGH in this case)
    a.TIME_STAMP                    -- Timestamp of the alert
FROM
    PATIENTS AS p                   -- Alias 'p' for the PATIENTS table
        JOIN ALERTS AS a ON p.Patient_ID = a.PATIENT_ID
WHERE
    p.Status IN ('Under Treatment', 'Sick')      -- Filter for patients with specific health statuses
  AND a.ALERT_TYPE = 'HIGH'                    -- Only consider high-level alerts
  AND a.RESOLVED = 'F'                         -- Only include unresolved alerts
  AND EXISTS (
    SELECT 1
    FROM PATCH_DEVICE AS pd
    WHERE pd.Patient_ID = p.Patient_ID
      AND pd.Patch_Status = 'Active'         -- Ensure the patient's patch device is active
)
ORDER BY
    a.TIME_STAMP DESC;                           -- Order by the most recent alert timestamps





-- Query 3: Correlated Nested Query with Aliasing
-- Purpose: Find devices that are actively monitoring patients with critical health summaries.
-- Expected Result: Lists device IDs and statuses for devices linked to patients with critical health summaries.
SELECT pd.Device_ID, pd.Patch_Status
FROM PATCH_DEVICE pd
WHERE EXISTS (
    SELECT 1
    FROM HEALTH_SUMMARY hs
    WHERE hs.Patient_ID = pd.Patient_ID
      AND hs.Vital_signs = 'Critical'
);


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


