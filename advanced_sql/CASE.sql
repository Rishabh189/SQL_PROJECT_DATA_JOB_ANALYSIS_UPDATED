/*
Label new columns as follows:
- 'Anywhere' jobs as Remote
-'New York,NY' jobs as Local
- Otherwise Onsite

*/

--Use of case expression for logic and new columns:

SELECT job_title_short,
job_location,
CASE  
    WHEN job_location = 'Anywhere' THEN 'REMOTE'
    WHEN job_location= 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact;

SELECT count(job_id) AS count_of_jobs,
       job_title_short,
CASE  
    WHEN job_location = 'Anywhere' THEN 'REMOTE'
    WHEN job_location= 'New York, NY' THEN 'Local'
    ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY job_title_short,location_category;
