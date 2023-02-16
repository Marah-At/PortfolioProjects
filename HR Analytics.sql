--1  Let's Show all the data in the EmployeesData Table

SELECT *
FROM EmployeesData

--2 Looking at the Total Number of Employees 

SELECT COUNT(Employee_Count) AS CountOfEmployees
FROM EmployeesData

--3 Looking at the Total Number of Active Employees 

SELECT COUNT(Attrition) AS ActiveEmployees 
FROM EmployeesData
WHERE Attrition ='No'


--4 Looking at the Total Number of Attrition Employees 


SELECT COUNT(Attrition) AS AttritionEmployees 
FROM EmployeesData
WHERE Attrition ='Yes'


--5 Find the Count of attrition in each Department 

SELECT Department , COUNT(Attrition) AS CountAttritionEmployees 
FROM EmployeesData
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY COUNT(Attrition) DESC


--6 Looking at the Attrition in each Education Field

SELECT Education_Field, COUNT(Attrition) AS CountofAttrition
FROM EmployeesData
WHERE Attrition = 'Yes'
GROUP BY Education_Field
ORDER BY COUNT(Attrition) DESC


--7 Find the Count of attrition in each Age_Band for different gender (Male/Female)


SELECT CF_age_band ,Gender, COUNT(Attrition) AS CountAttritionEmployees 
FROM EmployeesData
WHERE Attrition = 'Yes'
GROUP BY CF_age_band, Gender
ORDER BY CF_age_band 


--8 Looking at the Attrition according to the number of Years At Company

SELECT Years_At_Company ,Count(Attrition) AS COUNTOfAttrition
FROM EmployeesData
WHERE Attrition = 'Yes'
GROUP BY Years_At_Company
ORDER BY Count(Attrition) DESC


--9 Looking at the Job Satisfaction Rating 

SELECT Job_Role,
	   Job_Satisfaction,
       COUNT(Job_Satisfaction) AS GrandTotal
FROM EmployeesData
GROUP BY Job_Role, Job_Satisfaction 
ORDER BY Job_Role


--10 Looking at the employees with Max Performance Rate and without Promotion since 5 Years 

SELECT Employee_Number,
       Attrition,
	   Department,
	   Gender,
	   Age,
	   Job_Satisfaction,
	   Performance_Rating,
	   Years_Since_Last_Promotion
FROM EmployeesData
WHERE Performance_Rating = ( SELECT max(Performance_Rating) FROM EmployeesData)
AND Years_Since_Last_Promotion >= 5


--11 Looking at the employees who have worked at the company more than 5 Years and worked overtime with minimum Percent Salary hike and 

SELECT Employee_Number,
       Attrition , 
       Department,
	   Gender,
	   Years_At_Company,
	   Over_Time,
	   Age,
	   Percent_Salary_Hike
FROM EmployeesData
WHERE Years_At_Company > 5  
AND Over_Time = 'Yes'
AND Percent_Salary_Hike =( SELECT min(Percent_Salary_Hike) FROM EmployeesData)


--12 Looking at the min and max salary for each departmant

SELECT Department , 
       MIN(Monthly_Income) AS MinSalary,
	   MAX(Monthly_Income) AS MaxSalary
FROM EmployeesData
GROUP BY Department


-- extract the Count of Attrition according to Gender 

SELECT Gender , COUNT(Attrition) AS CountOfAttrition
FROM EmployeesData
WHERE Attrition = 'Yes'
GROUP BY Gender


-- extract the Count of Attrition according to Marital_Status 

SELECT Marital_Status, COUNT(Attrition) AS CountOfAttrition
FROM EmployeesData
WHERE Attrition = 'Yes'
GROUP BY Marital_Status


