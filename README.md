# SureTrust_G18_PowerBI_SQL
SQL feedback validation system + Power BI dashboards (Mini &amp; Major projects)
# SureTrust Feedback & Power BI Projects

*Author*:Syam Kumar Appikatla  
*Repository*:SureTrust_G18_PowerBI_SQL



## Project Overview

This repository contains two main projects developed during my internship with *SureTrust*:

1. *SQL-Based Feedback & Attendance Validation System*  
   - End-to-end system using *MySQL*.  
   - Integrates Google Form responses with meeting attendance records.  
   - Validates feedback so that only attendees’ responses are processed.  
   - Includes logging mechanism and admin-ready reports.

2. *Power BI Reports*  
   - Mini and Major projects built in *Power BI Desktop*.  
   - Showcase data visualization and business intelligence skills.  
   - Each project includes the .pbix file, dataset, and screenshots.
ChatGPT said:

Almost ✅, but what you pasted is a cut version of the README (some formatting is broken).

You can paste it, but before pasting, let’s fix it into a proper Markdown format so that GitHub shows it neatly with headings, code blocks, and bullet points.

Here’s the correct version 👇 — you can copy-paste this directly into README.md:

# SureTrust Feedback & Power BI Projects

*Author:* Syam Kumar Appikatla  
*Repository:* SureTrust_G18_PowerBI_SQL  

---

## 📂 Repository Structure



├─ SQL_Project/
│ ├─ suretrust_project.sql # Full database dump (schema + data)
│ ├─ create_tables.sql # Schema creation scripts
│ ├─ stored_procedures.sql # Stored procedure for feedback validation
│ ├─ queries.sql # Useful SELECT and report queries
│ ├─ process_responses.py # Python automation script
│ ├─ er_diagram.png # Entity-Relationship diagram
│ ├─ charts/ # Graph outputs (PNG)
│ ├─ screenshots/ # MySQL Workbench screenshots
│ └─ docs/
│ └─ project_report.pdf
│
├─ PowerBI_Mini/
│ ├─ mini_report.pbix
│ ├─ dataset/
│ ├─ screenshots/
│ ├─ docs/
│ └─ queries/
│
├─ PowerBI_Major/
│ ├─ major_report.pbix
│ ├─ dataset/
│ ├─ screenshots/
│ ├─ docs/
│ └─ queries/
│
└─ README.md


---

## 🚀 Getting Started

### A. SQL Project
1. Import the MySQL dump:
   ```bash
   mysql -u root -p < SQL_Project/suretrust_project.sql


To process responses automatically:

pip install -r requirements.txt
python SQL_Project/process_responses.py

B. Power BI Projects

Open PowerBI_Mini/mini_report.pbix or PowerBI_Major/major_report.pbix in Power BI Desktop.

Explore dashboards and interact with visuals.

📊 Demonstrations

ER Diagram → SQL schema overview (SQL_Project/er_diagram.png)

Charts → Valid vs invalid responses, user participation (SQL_Project/charts/)

Screenshots → MySQL Workbench proof (SQL_Project/screenshots/)

🔮 Future Enhancements

Automate CSV imports from Google Sheets with Python.

Real-time dashboards using Flask + Chart.js or Power BI Service.

Email alerts for invalid feedback entries.

Multi-meeting channel support.

📬 Contact

Syam Kumar Appikatla
📧 Email: your_email_here
🔗 LinkedIn : https://www.linkedin.com/in/syam-kumar-appikatla-a078ab2b2/
