/*
Problem: What are top skills based on salary
-Look at the average salary associated with each skill for data analyst positions
-Focusses on roles with specified salaries, regardless of location
-Why? It reveals how different skills impact salary levels for data nalayst
and helps identify the most financially rewarding skills to acquire or improve
*/

SELECT 
    skills,
    ROUND(avg(salary_year_avg),2) as avg_salary
 FROM
    job_postings_fact jpf  
    INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
group by 
    skills
order by avg_salary DESC
LIMIT 25;