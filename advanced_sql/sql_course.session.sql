CREATE TABLE EmployeeInfo (
    EmpID INT PRIMARY KEY,
    EmpFname VARCHAR(50),
    EmpLname VARCHAR(50),
    Department VARCHAR(50),
    Project VARCHAR(50),
    Address VARCHAR(100),
    DOB DATE,
    Gender CHAR(1)
);


INSERT INTO EmployeeInfo (EmpID, EmpFname, EmpLname, Department, Project, Address, DOB, Gender) VALUES
(1, 'Sanjay', 'Mehra', 'HR', 'P1', 'Hyderabad(HYD)', '1976-12-01', 'M'),
(2, 'Ananya', 'Mishra', 'Admin', 'P2', 'Delhi(DEL)', '1968-05-02', 'F'),
(3, 'Rohan', 'Diwan', 'Account', 'P3', 'Mumbai(BOM)', '1980-01-01', 'M'),
(4, 'Sonia', 'Kulkarni', 'HR', 'P1', 'Hyderabad(HYD)', '1992-05-02', 'F'),
(5, 'Ankit', 'Kapoor', 'Admin', 'P2', 'Delhi(DEL)', '1994-07-03', 'M');


CREATE TABLE EmployeePosition (
    EmpID INT,
    EmpPosition VARCHAR(50),
    DateOfJoining DATE,
    Salary DECIMAL(10, 2),
    PRIMARY KEY (EmpID, EmpPosition, DateOfJoining)
);

INSERT INTO EmployeePosition (EmpID, EmpPosition, DateOfJoining, Salary) VALUES
(1, 'Manager', '2024-05-01', 500000),
(2, 'Executive', '2024-05-02', 75000),
(3, 'Manager', '2024-05-01', 90000),
(2, 'Lead', '2024-05-02', 85000),
(1, 'Executive', '2024-05-01', 300000);


/*
Write a query to fetch the EmpFname from the EmployeeInfo table in the upper case and use the ALIAS name as EmpName.
Write a query to fetch the number of employees working in the department ‘HR’.
Write a query to get the current date.
Write a query to retrieve the first four characters of  EmpLname from the EmployeeInfo table.
Write a query to fetch only the place name(string before brackets) from the Address column of EmployeeInfo table.
Write a query to create a new table that consists of data and structure copied from the other table.
Write q query to find all the employees whose salary is between 50000 to 100000.
Write a query to find the names of employees that begin with ‘S’
Write a query to fetch top N records.
Write a query to retrieve the EmpFname and EmpLname in a single column as “FullName”.
  The first name and the last name must be separated with space.
*/

select upper(empfname) as EmpName from employeeinfo;

select count(*) from employeeinfo where department = 'HR';

--SELECT GETDATE(); not working in postgres
SELECT CURRENT_DATE;

select substring(emplname,1,4) as emplname from employeeinfo;

--select substring(address,1,CHAR('(', Address)) as address_place_name from employeeinfo;
--not working in postgres

select substring(Address from '^(.*?)\(') as PlaceName from employeeinfo;

select * INTO NEW_TABLE From employeeinfo where 1=0;

select ep.empid,ei.empfname,ei.emplname from employeeposition ep inner join employeeinfo ei 
on ep.empid=ei.empid
where salary between 50000 and 100000;

SELECT * FROM EmployeePosition WHERE Salary BETWEEN '50000' AND '100000';

select empfname from employeeinfo where empfname like 'S%';

SELECT * from employeeinfo LIMIT N order by salary desc;--u can order by anything

SELECT CONCAT(empfname, ' ', emplname) as FullName from employeeinfo;

-- Write a query find number of employees whose DOB is between 
--02/05/1970 to 31/12/1975 and are grouped according to gender

select count(*) as No_of_employees,gender from employeeinfo
where dob between '02/05/1970' and '31/12/1975'
group by GENDER;

--Write a query to fetch all the records from the EmployeeInfo table ordered by EmpLname 
--in descending order and Department in the ascending order.

select * from employeeinfo
order by Emplname desc ,Department asc;

--Write a query to fetch details of employees whose EmpLname ends with an alphabet ‘A’ and 
--contains five alphabets.

select empid, empfname, emplname from employeeinfo
where emplname like '____a';

--Write a query to fetch details of all employees excluding the employees with first names,
-- “Sanjay” and “Sonia” from the EmployeeInfo table.

select * from employeeinfo where empfname NOT IN ('Sanjay', 'Sonia');

--Write a query to fetch details of employees with the address as “DELHI(DEL)”.

select * from employeeinfo where address = 'Delhi(DEL)';

-- Write a query to fetch all employees who also hold the managerial position.

select ei.empid,ei.empfname,ep.empposition from employeeinfo ei join employeeposition ep 
ON ei.empid=ep.empid
AND ep.empposition IN ('Manager')--u can use WHERE also in place of AND

--Write a query to fetch the department-wise count of employees sorted by 
--department’s count in ascending order.

select count(*) AS EmpDeptCount,department from employeeinfo
group by department order by department asc;

--Write a query to calculate the even and odd records from a table.

WITH numbered_rows AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY empid) AS rn
    FROM 
        employeeinfo)
SELECT * FROM numbered_rows WHERE rn % 2 = 0;

-- Write a SQL query to retrieve employee details from EmployeeInfo table
-- who have a date of joining in the EmployeePosition table.

SELECT * FROM EmployeeInfo E 
WHERE EXISTS 
(SELECT * FROM EmployeePosition P WHERE E.EmpId = P.EmpId);

--Write a query to retrieve two minimum and maximum salaries from the 
--EmployeePosition table.

--Max:
select distinct salary from employeeposition E1 where 2 >
(Select count(distinct(salary)) from employeeposition E2 where E1.Salary<E2.salary)
order by E1.salary desc;

--Min:
select distinct salary from EmployeePosition E1 where 2 >
(select count(distinct(salary)) from employeeposition E2 where E2.salary<E1.salary)
order by salary asc;

--Write a query to retrieve duplicate records from a table.

select count(*),department from employeeinfo
group by department
having count(*)>1

--Write a query to retrieve the list of employees working in the same department.

select Distinct E1.empid,E1.department,E1.empfname from employeeinfo E1, employeeinfo E2
where E1.Empid <> E2.EmpID and E1.department = E2.department; 
----for self join just include comma between tables 

--Write a query to retrieve the last 3 records from the EmployeeInfo table.
--we will use CTE (common table expression) here:

WITH Ranked_Employees AS
(
  SELECT *, Row_Number() Over (ORDER BY empid desc) rn
  from EmployeeInfo
)
SELECT empid,empfname from Ranked_Employees
where rn <= 3
order by empid desc;

-- Write a query to find the third-highest salary from the EmpPosition table.

select empid,salary from Employeeposition E1 where 2=
(select count(distinct(salary)) from EmployeePosition E2 where E1.salary>E2.Salary);

--Write a query to display the first and the last record from the EmployeeInfo table.

--Last record:

WITH ranked_emp AS(
  SELECT *,ROW_NUMBER() OVER (ORDER BY empid desc) rn
  from employeeinfo
)
select empid,empfname from ranked_emp
where rn = 1;

--First Record:
WITH RANKED_EMP AS(
  SELECT *, ROW_NUMBER() OVER (ORDER BY empid) rn
  from employeeinfo
)
select empid,empfname from RANKED_EMP
where rn =1;

--Write a query to add email validation to your database

--1. adding email column to our table

ALTER TABLE employeeinfo
ADD email VARCHAR (255);

--2. Applying CHECK constraint for email validation:
ALTER TABLE employeeinfo
ADD CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$');

--3. Adding data in employeeinfo:

UPDATE EMPLOYEEINFO SET email = 'Sanjay.Mehra@rishabh.com'
where empid=1;

UPDATE EMPLOYEEINFO SET email = 'Rohan.Diwan@rishabh.com'
where empid=3;

UPDATE EMPLOYEEINFO SET email = 'Sonia.Kulkarni@rishabh.com'
where empid=4;

UPDATE EMPLOYEEINFO SET email = 'Ankit.Kapoor@rishabh.com'
where empid=5;

UPDATE EMPLOYEEINFO SET email = 'Ananya.Mishra@rishabh.com'
where empid=2;

--finally checking email validation in a given record

SELECT Email FROM EmployeeInfo WHERE NOT 
REGEXP_LIKE(Email, ‘[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}’, ‘i’);
--it will not work here, its for oracle sql

--postgres equivalent:

SELECT Email 
FROM EmployeeInfo 
WHERE Email !~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$';

--This query will return all email addresses from the EmployeeInfo table 
--that do not match the specified email format pattern. Hence no op as all
--email data matches the expression

--Write a query to retrieve Departments who have less than 2 employees 
--working in it.

select count(*),department from employeeinfo
group by department having count(*)<2;

--Write a query to retrieve EmpPostion along with total salaries paid for each of them.

select sum(salary) as Total_Slaries,empposition
from employeeposition group by empposition;


--Write a query to fetch 50% records from the EmployeeInfo table
WITH ranked_emp AS(
  SELECT *,ROW_NUMBER() OVER (ORDER BY empid) rn,
  count(*) OVER() AS TOTAL_ROWS 
  from employeeinfo
)
select empid from ranked_emp
where rn <= total_rows/2;























