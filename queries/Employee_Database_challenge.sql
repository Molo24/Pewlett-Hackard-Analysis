--
-- DELIVERABLE 1
--
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

-- Count Number of Titles
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles ut
GROUP BY ut.title
ORDER BY 1 DESC
;


--
-- Deliverable 2
-- 
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