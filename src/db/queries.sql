USE VitalWatchers;

-- Query 1: Triple Table Join
-- Purpose: Retrieve patient details, their health summary, and provider notes.
-- Expected Result: Displays each patient's name, date of health summary, and provider notes.
SELECT p.Patient_ID, CONCAT(p.First_name, ' ', p.Last_name) AS Patient_Name, h.Date, h.Provider_notes
FROM PATIENTS p
         JOIN HEALTH_SUMMARY h ON p.Patient_ID = h.Patient_ID
         JOIN PROVIDERS pr ON h.Provider_ID = pr.Provider_ID;

-- Query 2: Nested Query with IN and GROUP BY
-- Purpose: List patients monitored on dates when any critical alert was raised.
-- Expected Result: Lists each patient and the count of their health summaries on critical alert dates.
SELECT CONCAT(p.First_name, ' ', p.Last_name) AS Patient_Name, COUNT(h.Date) AS Health_Summary_Count
FROM PATIENTS p
         JOIN HEALTH_SUMMARY h ON p.Patient_ID = h.Patient_ID
WHERE h.Date IN (
    SELECT a.TIME_STAMP
    FROM ALERTS a
    WHERE a.ALERT_TYPE = 'HIGH'
)
GROUP BY Patient_Name;

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


