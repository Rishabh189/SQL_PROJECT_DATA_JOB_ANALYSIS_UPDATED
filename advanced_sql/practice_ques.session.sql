CREATE TABLE EmployeeDetails (
    EmpId INT PRIMARY KEY,
    FullName VARCHAR(100),
    ManagerId INT,
    DateOfJoining DATE,
    City VARCHAR(100)
);

CREATE TABLE EmployeeSalary (
    EmpId INT,
    Project VARCHAR(10),
    Salary DECIMAL(10, 2),
    Variable DECIMAL(10, 2),
    PRIMARY KEY (EmpId, Project)
);

INSERT INTO EmployeeDetails (EmpId, FullName, ManagerId, DateOfJoining, City) VALUES
(121, 'John Snow', 321, '2019-01-31', 'Toronto'),
(321, 'Walter White', 986, '2020-01-30', 'California'),
(421, 'Kuldeep Rana', 876, '2021-11-27', 'New Delhi');

INSERT INTO EmployeeSalary (EmpId, Project, Salary, Variable) VALUES
(121, 'P1', 8000.00, 500.00),
(321, 'P2', 10000.00, 1000.00),
(421, 'P1', 12000.00, 0.00);

--Write an SQL query to fetch the EmpId and FullName 
--of all the employees working under the Manager with id – ‘986’.
SELECT EMPid,FULLNAME from employeedetails
where managerid = 986;


--Write an SQL query to fetch the different projects available from the EmployeeSalary table.
select distinct project from EmployeeSalary;

--Write an SQL query to fetch the count of employees working in project ‘P1’.
select count(*) from employeesalary where project ='P1';

--Write an SQL query to display the total salary of each employee adding the Salary with Variable value.
select empid, (salary + variable) as Total_Salary from employeesalary;

--Write an SQL query to fetch the employees whose name begins with any two characters, 
--followed by a text “hn” and ends with any sequence of characters.
select * from employeedetails where fullname like ('__hn%')

--Write an SQL query to fetch all the EmpIds which are present in either of the tables
-- – ‘EmployeeDetails’ and ‘EmployeeSalary’.

select empid from employeedetails
UNION
select empid from employeesalary

-- Write an SQL query to fetch common records between two tables.
--We can use INTERSECT but no of columns should be same in both tables
select * from employeedetails where empid in
(
    select empid from employeesalary
);

--Write an SQL query to fetch records that are present in one table 
--but not in another table.--we can use MINUS but no of columns should be same in both tables
select * from employeedetails where empid NOT IN
(
    select empid from employeesalary
);

--Write an SQL query to fetch the employee’s full names and replace the space with ‘-’.
select replace (fullname,' ','-') AS NEWNAME from employeedetails;

--Write an SQL query to fetch the position of a given character(s) in a field.

select POSITION (fullname IN 'White') from employeedetails;


--Write a query to fetch only the first name(string before space) from the 
--FullName column of the EmployeeDetails table.

SELECT SUBSTRING(FullName, 1, CHARINDEX(' ',FullName)) 
FROM EmployeeDetails; -- in sql server

SELECT EmpId, FullName, split_part(FullName, ' ', 1) AS FirstName
FROM EmployeeDetails; --using SPLIT_PART function


SELECT 
    EmpId, 
    FullName, 
    substring(FullName from 1 for position(' ' in FullName) - 1) AS FirstName
FROM EmployeeDetails; --using substring

--Write an SQL query to find the count of the total occurrences of a particular 
--character – ‘n’ in the FullName field.

select fullname, (length(fullname) - length(Replace(fullname,'n','')))AS count_of_n
from employeedetails;

--Write an SQL query to update the employee names by removing leading 
--and trailing spaces.

update employeedetails
SET fullname = LTRIM(RTRIM(fullname));

--Fetch all the employees who are not working on any project.
select empid from employeesalary where Project IS NULL;

--Write an SQL query to fetch all employee records from the EmployeeDetails table 
--who have a salary record in the EmployeeSalary table.

SELECT empid,fullname from employeedetails E where EXISTS
(SELECT empid from employeesalary S where E.empid=S.empid);

--Write an SQL query to fetch the project-wise count of employees sorted by 
--project’s count in descending order.
select count(*) as count_of_project,project from employeesalary 
group by project order by count_of_project desc;

--Write a query to fetch employee names and salary records. 
--Display the employee details even if the salary record is not present for the employee

select e.empid,e.fullname,s.salary from employeedetails e left join employeesalary s
on e.empid = s.empid;

--Write an SQL query to fetch all the Employees who are also managers 
--from the EmployeeDetails table.

select E1.empid,E1.fullname from employeedetails E1, employeedetails E2
where E1.empid=E2.managerid;

--Write an SQL query to remove duplicates from a table without 
--using a temporary table.

DELETE E1 from employeedetails E1 , employeedetails E2
where E1.empid>E2.empid and E1.fullname =E2.fullname
AND E1.managerid=E2.managerid and E1.dateofjoining=E2.dateofjoining
and E1.city=E2.city;

--Write an SQL query to fetch only odd rows from the table.

WITH RANKED_EMPLOYEES AS(
    SELECT *,
    ROW_NUMBER() OVER (ORDER BY empid) AS rn
    from employeedetails order by empid
)select * from RANKED_EMPLOYEES
where rn % 2 =1
order by empid;

--Write an SQL query to find the nth highest salary from a table.

select E1.salary from employeesalary E1 where 1=
(select count(distinct(salary)) from employeesalary E2
where E1.salary<E2.salary) order by salary;

--Write a query to find employees who earn more than their managers.

    SELECT * from EMPLOYEEDETAILS E2 join employeesalary s
    on e2.managerid=s.empid
    where E2.salary>S.salary;
--need to check

