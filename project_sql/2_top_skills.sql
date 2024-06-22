
--from previous question 1, add skills also with each role

WITH TOP_PAYING_JOBS AS
    (SELECT
        jf.job_id,
        jf.job_title,
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
    LIMIT 10
)
    SELECT
        TPJ.*,
        sd.skills
    FROM
        TOP_PAYING_JOBS TPJ
    INNER JOIN skills_job_dim sjd ON TPJ.job_id = sjd.job_id
    INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
    order by TPJ.salary_year_avg desc