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
Find the employees who would be candiates to participate in PH's mentorship program. These employees would be born in the year 1965.

```
SELECT DISTINCT ON (e.emp_no) e.emp_no,
    e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date AS dept_start_date,
	de.to_date AS dept_end_date,
	t.title,
	t.from_Date AS title_start_date,
	t.to_date AS title_end_date
INTO mentorship_eligibility
FROM employees e
JOIN dept_employees de
ON e.emp_no = de.emp_no
JOIN titles t
ON e.emp_no = t.emp_no
WHERE de.to_date = '9999-01-01' 
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no, title_start_date DESC
--LIMIT 100
;
```

Likewise, this table of results will be placed into its own table and exported to .CSV.

## Results

**1) There are 90,398 employees who are close to retirement.**
```
SELECT COUNT(*) AS about_to_retire
FROM unique_titles
;
```

**2) Most of those close to retiring currently hold "Senior" positions:**
```
SELECT *
FROM retiring_titles
;
```
![retiring_titles_table](https://user-images.githubusercontent.com/89284280/136668368-02ed393c-1e93-4306-a22b-7a1437f7765b.PNG)

**3) There are 1,549 employees who are candidates for the mentorship program.**
```
SELECT COUNT(*)
FROM mentorship_eligibility
;
```

**4) Most of the employees eligible for the mentorship program currently hold "Senior Staff" or "Senior Engineer" positions within the company.**
```
SELECT title, COUNT(title)
FROM mentorship_eligibility
GROUP BY title
ORDER BY 2 DESC
;
```
![mentor_titles_table](https://user-images.githubusercontent.com/89284280/136668509-9969eb12-0496-4869-8074-4a414c8061be.PNG)

## Summary
As seen by the Analysis and Results section above, PH has a significant portion of their employees who are approaching retirement. Most of those retiring currently hold "Senior" positions within the company. This situation creates a significant risk to PH in terms of productivity and experience. Fortunately, there are current employees who are not yet near retirement who can serve as mentors to junior and new staff at PH.  
