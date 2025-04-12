--1. Basic, select all query.
SELECT *
FROM employees;

--2. Find employees that have a Bachelors degree and joined the
--   company in the year 2013.
SELECT *
FROM employees
WHERE Education = 'Bachelors' and JoiningYear = '2013';

--3. Find employees that have a Masters degree and have not left
--   the company. Sort by employee JoiningYear where the employees
--   that have been at the company the longest are first.
SELECT *
FROM employees
WHERE Education = 'Masters' and LeaveOrNot = '0'
ORDER BY JoiningYear;

--4. Find the first employees of every education level to have
--   ever joined the company.
SELECT Education, JoiningYear, Age, EverBenched, ExperienceInCurrentDomain, LeaveOrNot
FROM employees
GROUP BY Education
ORDER BY JoiningYear;

--5. Find the total number of employees that joined the company
--   each year.
SELECT JoiningYear, count(Education) as numJoins
FROM employees
GROUP BY JoiningYear
ORDER BY JoiningYear;

--6. Find the oldest 10 employees (in terms of age) that have
--   also been at the company the longest and have not left
--   the company.
SELECT Education, JoiningYear, Age, LeaveOrNot
FROM employees
WHERE LeaveOrNot = '0'
ORDER BY JoiningYear, Age DESC
LIMIT 10;

--7. Find the oldest 10 employees (in terms of age) that have
--   the most experience and have not left the company.
SELECT Education, Age, ExperienceInCurrentDomain, LeaveOrNot
FROM employees
WHERE LeaveOrNot = '0'
ORDER BY ExperienceInCurrentDomain DESC, Age DESC
LIMIT 10;

--8. Find the total number of employees with each degree that
--   are either still with the company or have left the company.
SELECT a.Education, a.numDegrees, b.numDegreesLeft
FROM
(SELECT Education, count(Education) as numDegrees
FROM employees
WHERE LeaveOrNot = '0'
GROUP BY Education) as a
LEFT JOIN
(SELECT Education, count(Education) as numDegreesLeft
FROM employees
WHERE LeaveOrNot = '1'
GROUP BY Education) as b on a.Education = b.Education;

--9. Find the total number of employees with each numbers of years
--   of experience in their assigned domain that are either still with
--   the company or have left the company.
SELECT a.ExperienceInCurrentDomain, a.numStayed, b.numLeft
FROM
(SELECT ExperienceInCurrentDomain, count(ExperienceInCurrentDomain) as numStayed
FROM employees
WHERE LeaveOrNot = '0'
GROUP BY ExperienceInCurrentDomain) as a
LEFT JOIN
(SELECT ExperienceInCurrentDomain, count(ExperienceInCurrentDomain) as numLeft
FROM employees
WHERE LeaveOrNot = '1'
GROUP BY ExperienceInCurrentDomain) as b on a.ExperienceInCurrentDomain = b.ExperienceInCurrentDomain
ORDER BY ExperienceInCurrentDomain;

--10. Find the average number of years of experience that each level
--    of education has within all employees still at the company.
SELECT Education, avg(ExperienceInCurrentDomain) as avgExperience
FROM employees
WHERE LeaveOrNot = '0'
GROUP BY Education;

--11. Find the youngest and oldest employees respectively at each
--    level of education that are still with the company.
SELECT Education, min(Age) as youngest, max(Age) as oldest
FROM employees
WHERE LeaveOrNot = '0'
GROUP BY Education;

--12a. Find the number of employees at each level of education
--    that graduated from each city.
SELECT Education, City, count(City) as cntCity
FROM employees as e1
GROUP BY Education, City
ORDER BY Education, cntCity DESC;

--12b. Find the city that the greatest number of employees graduated
--     from for each level of education respectively.
SELECT Education, City, count(City) as cntCity
FROM employees as e1
GROUP BY Education, City
HAVING e1.City = 
    (SELECT e2.City
    FROM employees as e2
    WHERE e2.Education = e1.Education
    GROUP BY e2.City
    ORDER BY COUNT(*) DESC, e2.City
    LIMIT 1
    );

--13. Find the total number of employees that have either been benched
--    or never been benched and whether or not they are still with the company
--    or not for each level of education respectively.
SELECT a.Education, a.benchedStayed, a.benchedLeft, b.notBenchedStayed, b.notBenchedLeft
FROM
(SELECT Education,
    count(case when EverBenched = 'Yes' and LeaveOrNot = '1' then 1 end) as benchedLeft,
    count(case when EverBenched = 'Yes' and LeaveOrNot = '0' then 1 end) as benchedStayed
FROM employees
GROUP BY Education) a
LEFT JOIN
(SELECT Education,
    count(case when EverBenched = 'No' and LeaveOrNot = '1' then 1 end) as notBenchedLeft,
    count(case when EverBenched = 'No' and LeaveOrNot = '0' then 1 end) as notBenchedStayed
FROM employees
GROUP BY Education) b on a.Education = b.Education;

--14a. Find the number of employees at each age.
SELECT Age, count(Age) as numEmployees
FROM employees
GROUP BY Age
ORDER BY Age;

--14b. Find the number of male and female employees at each age.
SELECT Age, 
    count(case when Gender = 'Male' then 1 end) as Male, 
    count(case when Gender = 'Female' then 1 end) as Female
FROM employees
GROUP BY Age
ORDER BY Age;

--15. Find the number of male and female employees at each 
--    education level.
SELECT Education, 
    count(case when Gender = 'Male' then 1 end) as Male, 
    count(case when Gender = 'Female' then 1 end) as Female
FROM employees
GROUP BY Education;

--16. Find the oldest and youngest employees from each city.
SELECT City, max(Age) as oldest, min(Age) as youngest
FROM employees
GROUP BY City;
