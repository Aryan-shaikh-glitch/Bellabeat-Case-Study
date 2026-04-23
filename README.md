# 🌿 Bellabeat Case Study — Google Data Analytics Capstone

## 📋 Project Overview

This case study is part of the **Google Data Analytics Professional Certificate** capstone project. The goal is to analyze smart device fitness data to uncover consumer usage trends and provide data-driven marketing recommendations for **Bellabeat** — a high-tech company that manufactures health-focused smart products for women.

---

## 🏢 About Bellabeat

Bellabeat is a successful small company with the potential to become a larger player in the global smart device market. Their products collect data on activity, sleep, stress, and reproductive health to empower women with knowledge about their own health and habits.

---

## ❓ Business Questions

1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat's marketing strategy?

---

## 📂 Dataset

- **Source:** [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) (Kaggle)
- **License:** CC0 Public Domain
- **Description:** Data from 33 FitBit users who consented to submit personal tracker data including daily activity, steps, sleep, calories and weight logs
- **Time Period:** April 2016 — May 2016

### Files Used:
| File | Description |
|------|-------------|
| `dailyActivity_merged.csv` | Daily steps, distance, calories, active minutes |
| `sleepDay_merged.csv` | Daily sleep records and time in bed |
| `weightLogInfo_merged.csv` | Weight, BMI and logging method |
| `hourlySteps_merged.csv` | Hourly step counts |
| `dailyCalories_merged.csv` | Daily calorie burn |

---

## 🛠️ Tools Used

| Tool | Purpose |
|------|---------|
| **Google BigQuery** | Data storage, cleaning and analysis using SQL |
| **Power BI** | Data visualization and dashboard creation |
| **VS Code** | SQL query organization |
| **GitHub** | Project documentation and portfolio |

---

## 🔄 Process

### 1. Ask
Defined the business problem and key questions to answer for Bellabeat's marketing team.

### 2. Prepare
- Downloaded FitBit dataset from Kaggle
- Uploaded 5 relevant CSV files to Google BigQuery
- Assessed data for completeness, credibility and limitations

### 3. Process (Data Cleaning)
Cleaned all 5 tables in BigQuery using SQL:
- Converted date/datetime columns from STRING to proper DATE format
- Removed NULL values and invalid records
- Created new calculated columns (MinutesAwakeInBed, HoursAsleep)
- Added extra distance columns for richer analysis

### 4. Analyze
Created 7 analysis tables in BigQuery:
- Daily activity summary with activity level categories
- User averages per person
- Sleep quality analysis
- Peak hourly activity patterns
- Day of week activity patterns
- Combined activity and sleep table
- Weight and BMI summary

### 5. Share
Built a 3 page interactive dashboard in Power BI:
- 📊 Page 1: Activity Overview
- 😴 Page 2: Sleep & Wellness
- 💡 Page 3: Key Insights & Recommendations

### 6. Act
Derived actionable marketing recommendations for Bellabeat based on analysis findings.

---

## 📊 Key Insights

| # | Insight |
|---|---------|
| 1 | Average daily steps = 7,566 — below WHO recommended 10,000 steps |
| 2 | Only 24 out of 33 users tracked sleep — low engagement |
| 3 | Peak activity hours are 12pm and 5-7pm |
| 4 | Only 8 out of 33 users tracked weight — very low engagement |
| 5 | Users spend an average of 39 minutes awake in bed — sleep quality concern |

---

## 💡 Recommendations for Bellabeat

1. **Target sedentary users** with personalized step challenges and activity reminders during peak hours (12pm & 6pm)

2. **Market automatic sleep tracking** as an effortless solution — FitBit users clearly struggle to track sleep manually

3. **Launch a "Better Sleep" campaign** targeting active women who are physically active but have poor sleep quality

4. **Introduce automatic weight sync** feature to boost weight tracking engagement which is currently very low

5. **Send motivational notifications** on low activity days (Sunday & Friday) to keep users engaged throughout the week

---

## 📁 Repository Structure
