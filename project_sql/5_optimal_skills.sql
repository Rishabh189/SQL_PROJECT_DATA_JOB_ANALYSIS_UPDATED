WITH TOP_DEMANDS_SKILLS AS(
SELECT 
    sd.skill_id,
    sd.skills,
    count(sjd.job_id) as demand_count
 FROM
    job_postings_fact jpf  
    INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst'
AND jpf.salary_year_avg IS NOT NULL
AND job_work_from_home = TRUE
group by 
    sd.skill_id
), Average_Salary as(  --combining two CTEs, use comma dont use two WITH
SELECT 
    sd.skill_id,
    sd.skills,
    ROUND(avg(jpf.salary_year_avg),2) as avg_salary
 FROM
    job_postings_fact jpf  
    INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst'
AND jpf.salary_year_avg IS NOT NULL
group by 
    sd.skill_id
)
SELECT TDSE.skill_id,TDSE.skills,
demand_count, avg_salary
FROM TOP_DEMANDS_SKILLS TDSE
INNER JOIN Average_salary ASE
ON TDSE.skill_id=ASE.skill_id
order by avg_salary desc,demand_count desc;
