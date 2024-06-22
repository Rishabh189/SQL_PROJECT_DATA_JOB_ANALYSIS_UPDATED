--top skills for data analyst

SELECT 
    skills,
    count(jpf.job_id) as demand_count
 FROM
    job_postings_fact jpf  
    INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Analyst'
AND job_work_from_home = TRUE
group by 
    skills
order by demand_count DESC
LIMIT 10;