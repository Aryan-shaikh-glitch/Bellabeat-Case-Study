###PHASE1_EXPLORATION

SELECT COUNT(*) as total_rows FROM `axial-autonomy-478712-i3.fitbit_data.daily_activity`;
SELECT COUNT(*) as total_rows FROM `axial-autonomy-478712-i3.fitbit_data.sleep_day`;
SELECT COUNT(*) as total_rows FROM `axial-autonomy-478712-i3.fitbit_data.weight_log`;
SELECT COUNT(*) as total_rows FROM `axial-autonomy-478712-i3.fitbit_data.hourly_steps`;
SELECT COUNT(*) as total_rows FROM `axial-autonomy-478712-i3.fitbit_data.daily_calories`;
#counted rows 940, 413, 67, 22099, 940 resp

SELECT COUNT(DISTINCT Id) as total_users FROM `axial-autonomy-478712-i3.fitbit_data.daily_activity`;
SELECT COUNT(DISTINCT Id) as total_users FROM `axial-autonomy-478712-i3.fitbit_data.sleep_day`;
SELECT COUNT(DISTINCT Id) as total_users FROM `axial-autonomy-478712-i3.fitbit_data.weight_log`;
SELECT COUNT(DISTINCT Id) as total_users FROM `axial-autonomy-478712-i3.fitbit_data.hourly_steps`;
SELECT COUNT(DISTINCT Id) as total_users FROM `axial-autonomy-478712-i3.fitbit_data.daily_calories`;
#counted total users who logged 33, 24, 8, 33, 33 resp

SELECT
  MIN(ActivityDate) AS start_date,
  MAX(ActivityDate) AS end_date
FROM `axial-autonomy-478712-i3.fitbit_data.daily_activity`;
#start date 2016-04-12, end date 2016-05-12

SELECT
  COUNTIF(Id IS NULL) AS null_id,
  COUNTIF(Activitydate IS NULL) AS null_date,
  COUNTIF(TotalSteps IS NULL) AS null_steps,
  COUNTIF(Calories IS NULL) AS null_calories,
FROM `axial-autonomy-478712-i3.fitbit_data.daily_activity`;
#no null values

SELECT
  COUNTIF(Id IS NULL) AS null_id,
  COUNTIF(SleepDay IS NULL) AS null_date,
  COUNTIF(TotalMinutesAsleep IS NULL) AS null_sleep,
  COUNTIF(TotalTimeInBed IS NULL) AS null_bedtime,
FROM `axial-autonomy-478712-i3.fitbit_data.sleep_day`;
#no null values

SELECT * FROM `axial-autonomy-478712-i3.fitbit_data.daily_activity` LIMIT 10;
SELECT * FROM `axial-autonomy-478712-i3.fitbit_data.sleep_day` LIMIT 10;
SELECT * FROM `axial-autonomy-478712-i3.fitbit_data.weight_log` LIMIT 10;
SELECT * FROM `axial-autonomy-478712-i3.fitbit_data.hourly_steps` LIMIT 10;
SELECT * FROM `axial-autonomy-478712-i3.fitbit_data.daily_calories` LIMIT 10;
#viewing the first 10 rows of every table to get familiar with the data


###PHASE2_CLEANING

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.clean_daily_activity` AS
SELECT
  Id,
  CAST(ActivityDate AS DATE) AS ActivityDate,
  TotalSteps,
  TotalDistance,
  TrackerDistance,
  VeryActiveDistance,
  ModeratelyActiveDistance,
  LightActiveDistance,
  VeryActiveMinutes,
  FairlyActiveMinutes,
  LightlyActiveMinutes,
  SedentaryMinutes,
  Calories
FROM `axial-autonomy-478712-i3.fitbit_data.daily_activity`
WHERE
  Id IS NOT NULL
  AND ActivityDate IS NOT NULL
  AND TotalSteps >= 0
  AND Calories > 0;
#cleaned daily_activity_table

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.clean_sleep_day` AS 
SELECT
  Id,
  PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', SleepDay) AS SleepDay,
  TotalSleepRecords,
  TotalMinutesAsleep,
  TotalTimeInBed,
  (TotalTimeInBed - TotalMinutesAsleep) AS MinutesAwakeInBed
FROM `axial-autonomy-478712-i3.fitbit_data.sleep_day`
WHERE 
  Id IS NOT NULL
  AND SleepDay IS NOT NULL
  AND TotalMinutesAsleep > 0
  AND TotalTimeInBed > 0;
#cleaned sleep_day_table

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.clean_weight_log` AS
SELECT
  Id,
  PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', Date) AS Date,
  WeightKg,
  WeightPounds,
  BMI,
  IsManualReport
FROM `axial-autonomy-478712-i3.fitbit_data.weight_log`
WHERE
  Id IS NOT NULL
  AND Date IS NOT NULL
  AND WeightKg > 0
  AND BMI >0;
#cleaned weight_log_table

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.clean_hourly_steps` AS
SELECT
  Id,
  PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour) AS ActivityHour,
  EXTRACT(HOUR FROM PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour)) AS Hour,
  EXTRACT(DAYOFWEEK FROM PARSE_DATETIME('%m/%d/%Y %I:%M:%S %p', ActivityHour)) AS DayOfWeek,
  StepTotal
FROM `axial-autonomy-478712-i3.fitbit_data.hourly_steps`
WHERE 
  Id IS NOT NULL
  AND ActivityHour IS NOT NULL
  AND StepTotal >= 0;
#cleaned hourly_steps_table

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.clean_daily_calories` AS
SELECT
  Id,
  PARSE_DATE('%m/%d/%Y', ActivityDay) AS ActivityDay,
  Calories
FROM `axial-autonomy-478712-i3.fitbit_data.daily_calories`
WHERE
  Id IS NOT NULL
  AND ActivityDay IS NOT NULL
  AND Calories > 0;
#cleaned daily_calories_table


###PHASE3_ANALYSIS

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.analysis_daily_activity` AS
SELECT
  Id,
  ActivityDate,
  TotalSteps,
  Calories,
  TotalDistance,
  VeryActiveMinutes,
  FairlyActiveMinutes,
  LightlyActiveMinutes,
  SedentaryMinutes,
  CASE
    WHEN TotalSteps >= 10000 THEN 'Very Active'
    WHEN TotalSteps >= 7500 THEN 'Fairly Active'
    WHEN TotalSteps >= 5000 THEN 'Lightly Active'
    ELSE 'Sedentary'
  END AS ActivityLevel,
  FORMAT_DATE('%A', ActivityDate) AS DayName
FROM `axial-autonomy-478712-i3.fitbit_data.clean_daily_activity`;
#created daily_activity_summary_table for analysis

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.analysis_user_averages` AS
SELECT
  Id,
  ROUND(AVG(TotalSteps), 0) AS AvgDailySteps,
  ROUND(AVG(Calories), 0) AS AvgDailyCalories,
  ROUND(AVG(TotalDistance), 2) AS AvgDailyDistance,
  ROUND(AVG(VeryActiveMinutes), 0) AS AvgVeryActiveMinutes,
  ROUND(AVG(SedentaryMinutes), 0) AS AvgSedentaryMinutes,
  CASE
    WHEN AVG(TotalSteps) >= 10000 THEN 'Very Active'
    WHEN AVG(TotalSteps) >= 7500 THEN 'Fairly Active'
    WHEN AVG(TotalSteps) >= 5000 THEN 'Lightly Active'
    ELSE 'Sedentary'
  END AS UserActivityCategory
FROM `axial-autonomy-478712-i3.fitbit_data.clean_daily_activity`
GROUP BY Id;
#created daily user_average_table for analysis

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.analysis_sleep` AS
SELECT
  Id,
  DATE(SleepDay) AS SleepDate,
  TotalMinutesAsleep,
  TotalTimeInBed,
  MinutesAwakeInBed,
  ROUND(TotalMinutesAsleep / 60, 2) AS HoursAsleep,
  CASE
    WHEN TotalMinutesAsleep >= 420 THEN 'Good Sleep (7+ hrs)'
    WHEN TotalMinutesAsleep >= 360 THEN 'Fair Sleep (6-7 hrs)'
    ELSE 'Poor Sleep (<6 hrs)'
  END AS SleepQuality
FROM `axial-autonomy-478712-i3.fitbit_data.clean_sleep_day`;
#created sleep_analysis_table for analysis

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.analysis_hourly_steps` AS
SELECT
  Hour,
  ROUND(AVG(StepTotal), 0) AS AvgSteps,
  SUM(StepTotal) AS TotalSteps,
  CASE
    WHEN Hour BETWEEN 6 AND 9 THEN 'Morning'
    WHEN Hour BETWEEN 10 AND 12 THEN 'Late Morning'
    WHEN Hour BETWEEN 13 AND 17 THEN 'Afternoon'
    WHEN Hour BETWEEN 18 AND 21 THEN 'Evening'
    ELSE 'Night/Early Morning'
  END AS TimeOfDay
FROM `axial-autonomy-478712-i3.fitbit_data.clean_hourly_steps`
GROUP BY Hour
ORDER BY Hour;
#created hourly_steps_table for analysis

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.analysis_day_of_week` AS
SELECT
  DayName,
  ROUND(AVG(TotalSteps), 0) AS AvgSteps,
  ROUND(AVG(Calories), 0) AS AvgCalories,
  ROUND(AVG(VeryActiveMinutes), 0) AS AvgVeryActiveMinutes
FROM `axial-autonomy-478712-i3.fitbit_data.analysis_daily_activity`
GROUP BY DayName
ORDER BY
  CASE DayName
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END;
  #created day_of_week table_for analysis

CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.analysis_activity_sleep` AS
SELECT
  a.Id,
  a.ActivityDate,
  a.TotalSteps,
  a.Calories,
  a.VeryActiveMinutes,
  a.SedentaryMinutes,
  a.ActivityLevel,
  s.HoursAsleep,
  s.TotalTimeInBed,
  s.MinutesAwakeInBed,
  s.SleepQuality
FROM `axial-autonomy-478712-i3.fitbit_data.analysis_daily_activity` a
LEFT JOIN `axial-autonomy-478712-i3.fitbit_data.analysis_sleep` s
  ON CAST(a.Id AS STRING) = CAST(s.Id AS STRING) 
  AND a.ActivityDate = s.SleepDate;
#created sleep_activity_table for analysis

  CREATE OR REPLACE TABLE `axial-autonomy-478712-i3.fitbit_data.analysis_weight` AS
SELECT
  Id,
  ROUND(AVG(WeightKg), 1) AS AvgWeightKg,
  ROUND(AVG(BMI), 1) AS AvgBMI,
  COUNT(*) AS TotalWeightLogs,
  CASE
    WHEN AVG(BMI) < 18.5 THEN 'Underweight'
    WHEN AVG(BMI) < 25 THEN 'Normal'
    WHEN AVG(BMI) < 30 THEN 'Overweight'
    ELSE 'Obese'
  END AS BMICategory,
  COUNTIF(IsManualReport = 'True') AS ManualEntries,
  COUNTIF(IsManualReport = 'False') AS AutoEntries
FROM `axial-autonomy-478712-i3.fitbit_data.clean_weight_log`
GROUP BY Id;
#created weight_analysis_table for analysis
