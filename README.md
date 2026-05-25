# School Management Database System

A relational database project for school management built with MySQL.

## Features
* **Normalized Architecture:** Designed 7 normalized tables (students, teachers, grades, classes) to ensure data integrity and establish relationships (including `ON DELETE CASCADE`).
* **Stored Procedures:** Developed procedures utilizing complex SQL queries (`INNER`/`LEFT JOIN`s, `GROUP BY`, date functions) for data extraction and reporting.
* **Triggers & Validation:** Automated business rules and data validation by implementing custom triggers (e.g., grade range validation, working hours limits).

## Tech Stack
* MySQL
* SQL (DDL, DML, Procedures, Triggers)
