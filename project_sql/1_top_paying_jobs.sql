/*
Question: What are top-paying data analyst jobs?
- Identify the top 10 highest paying Data Analyst roles that are 
available remotely
- Focussed on job postings with specified salaries (remove nulls)
- Why?Highlight the top paying opportunities for data analysts, 
offering insights into employement opportunities (get company name as well)
*/

WITH TOP_SALARY_JOBS AS
(SELECT
    job_id,
    job_title,
    job_title_short,
    job_location,
    job_work_from_home,
    salary_year_avg,company_id
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT 10)
SELECT  
    TJ.job_id,
    TJ.job_title,
    TJ.job_title_short,
    TJ.job_location,
    TJ.job_work_from_home,
    TJ.salary_year_avg,
    cd.company_id,
    cd.name
FROM 
    TOP_SALARY_JOBS TJ 
    INNER JOIN
    company_dim cd 
    ON 
    TJ.company_id = cd.company_id

--OR

SELECT
    jf.job_id,
    jf.job_title,
    jf.job_title_short,
    jf.job_location,
    jf.job_work_from_home,
    jf.salary_year_avg,
    cd.name as company_name
FROM
    job_postings_fact jf
LEFT JOIN company_dim cd
ON jf.company_id = cd.company_id
WHERE
    jf.job_title_short = 'Data Analyst' AND
    jf.job_work_from_home = TRUE AND
    jf.salary_year_avg IS NOT NULL
ORDER BY 
    jf.salary_year_avg DESC
LIMIT 10;