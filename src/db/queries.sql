-- Query 1: Triple Table Join
-- Purpose: Retrieve patient details, their health summary, and provider notes.
-- Expected Result: Displays each patient's name, date of health summary, and provider notes.
SELECT p.Patient_ID, CONCAT(p.First_name, ' ', p.Last_name) AS Patient_Name, h.Date, h.Provider_notes
FROM PATIENTS p
         JOIN HEALTH_SUMMARY h ON p.Patient_ID = h.Patient_ID
         JOIN PROVIDERS pr ON h.Provider_ID = pr.Provider_ID;