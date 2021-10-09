# Pewlett-Hackard-Analysis


## Overview & Purpose
As a large company with many employees, Pewlett-Hackard (PH), is planning for its staffing needs for the future. Part of this planning involves understanding their current employee makeup (age, seniority, benefit packages, etc.) and identify who is likely to retire in the near future which would lead to job vacancies that would need to be filled.

The goal of the following analysis was to: 1) Determine the number of retiring employees per title, and 2) Identify employees who are eligible to participate in a mentorship program.

To analysis will be performed on data in a SQL database using PostgreSQL.

## Analysis
There are 6 tables from which data will be pulled from to perform the analysis.

### Data Schema
The tables, and their relationships to each other can be seen below:

![EmployeeDB](https://user-images.githubusercontent.com/89284280/136662271-4916663f-d83b-47fa-a063-96619c8975d7.png)

### Number of Retiring Employees by Title
It has been determined that the most likely employees who will be retiring soon were born between 1952 and 1955. Therefore, we'll need to create a separate table for those employees:
```
-- Retirement Titles Table
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date,
	e.birth_date
INTO retirement_titles
FROM employees e
JOIN titles t
ON t.emp_no = e.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER by e.emp_no
--LIMIT 10
;
```

Because this result has duplicates (due to employees changing roles over their time with PH) we'll need to unique the employees using ```Distinct ON ()``` in PostgreSQL.

```
-- Unique Titles Table
SELECT DISTINCT ON (rt.emp_no) rt.emp_no,
--SELECT rt.emp_no,
	rt.first_name,
	rt.last_name,
	rt.title,
	rt.to_date
INTO unique_titles
FROM retirement_titles rt
ORDER BY rt.emp_no, rt.to_date DESC
--LIMIT 10
;
```

Lastly, to understand which titles would be most impacted, we will summarize those employees likely to retire by their title:
```
-- Count Number of Titles
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles ut
GROUP BY ut.title
ORDER BY 1 DESC
;
```

Each of these table results will be exported as .CSV and handed to the HR Manager.

### Employees Eligible for the Mentorship Program
