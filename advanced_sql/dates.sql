-- ::DATE function
select job_title_short AS title,
job_location as location,
job_posted_date::DATE as DATE
from job_postings_fact limit 5;

--Timezone function
select 
    job_title_short AS title,
    job_location as location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS Date_Time --converting timezone from UTC to EST
from 
    job_postings_fact 
limit 5;

select 
    job_title_short AS title,
    job_location as location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST' AS Date_Time --converting timezone from UTC to IST
from 
    job_postings_fact 
limit 5;

--Extract function
select 
    job_title_short AS title,
    job_location as location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST' AS Date_Time,
    EXTRACT(MONTH from job_posted_date) AS MONTH
from 
    job_postings_fact 
limit 5;

--using Extract function with group by to find the number of job posting on monthly basis or so on

select count(job_id) as job_posted_count,
    EXTRACT(MONTH from job_posted_date) as month
from job_postings_fact
where job_title_short= 'Data Analyst'
group by MONTH
order by job_posted_count DESC;

--Practice Questions:

CREATE TABLE JANUARY_JOBS AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1;

    CREATE TABLE FEBRUARY_JOBS AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=2;

    CREATE TABLE MARCH_JOBS AS
    SELECT * FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=3;
