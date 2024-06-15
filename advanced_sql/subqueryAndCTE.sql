/*
Subqueries - query within other query
-It can be used in severalplaces in the main query
 such as SELECT, FROM, WHERE or HAVING clauses
-Its executed first, and the result are passed to ouer query
*/

SELECT company_id,name as Company_Name
FROM company_dim
where company_id IN
(
SELECT company_id
FROM job_postings_fact
WHERE job_no_degree_mention= TRUE
)


/*CTEs - Common Table Expresssions
- a temporary result set that can be used within a 
SELECT, INSERT, UPDATE or DELETE statement
- Exists only during the execution of a query
- WITH used to define CTEs at beginning of the query
*/

/*
--Problem:
Find the companies that have the most job openings
-Get the the total number of job postings per company id (job_postings_fact)
-Return the total number of jobs with the company name (company dim)
*/

WITH Job_Count AS (
SELECT count(job_id) as count_of_jobs,
company_id
FROM job_postings_fact
group by company_id)
SELECT cd.name as company_name,
jb.count_of_jobs,cd.company_id
from company_dim cd left join job_count jb
ON cd.company_id=jb.company_id; 


/*
--Problem
Find the count of number of remote job postings per skill
 - Display the top 5 skills by their demand in remote jobs
 - Include skill ID, name and count of postings requiring the skill
*/

WITH NUMBER_OF_REM_JOBS as(
select count(jpf.job_id) as number_of_jobs,
sjd.skill_id
from job_postings_fact jpf join
skills_job_dim sjd
ON jpf.job_id=sjd.job_id
where jpf.job_work_from_home=TRUE
group by sjd.skill_id
)
select NJ.skill_id, sd.skills, NJ.number_of_jobs
from NUMBER_OF_REM_JOBS NJ join
skills_dim sd
ON NJ.skill_id=sd.skill_id
order by number_of_jobs desc LIMIT 5;

--Problem
/*
Find job postings from the first quarter that have salary greater than $70K
-Combine job posting tables from first quarter of 2023(jan-mar)
-Gets job postings with an average yearly salary > $70000
*/

WITH COMBINE_JOBS AS (
select job_id, job_title_short,salary_year_avg
from january_jobs
UNION ALL
select job_id, job_title_short,salary_year_avg
from february_jobs
UNION ALL
select job_id, job_title_short,salary_year_avg
from march_jobs
)
SELECT job_id,avg(salary_year_avg) as Average_Yearly_Salary
FROM COMBINE_JOBS
group by job_id
having avg(salary_year_avg) > 70000 
order by Average_Yearly_Salary asc;







