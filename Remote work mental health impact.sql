--1.--Fetch all data from the table
SELECT * FROM
MHealth.dbo.Remote_work;

--2.--What is the average work-life balance rating across different job roles on a scale of 1-5?
--ANS: Data scientist, Sales, and Software Engineer roles seem to have a fair work-life (of 3) compared to other roles
SELECT Job_Role,  AVG(Work_life_balance_rating) Work_life_balance
FROM MHealth.dbo.Remote_work
GROUP BY Job_Role
ORDER BY Job_Role;

--3a.--Which industries report the highest levels of stress? 
--ANS: Finance has the highest stress count of 266 followed by Healthcare(257)
SELECT Industry, Stress_level, COUNT(*) Stress_count
FROM MHealth.dbo.Remote_work
WHERE Stress_Level = 'HIGH'
GROUP BY Industry, Stress_level 
ORDER BY Stress_count DESC;


--3b.--Analyzing stress levels and their percentage per industry
--ANS: The finance industry reports the highest stress level, 35.60%.
SELECT  Industry,
COUNT(CASE WHEN Stress_level ='HIGH' THEN 1 END) High_stress_lvl,
COUNT(CASE WHEN Stress_level ='MEDIUM' THEN 1 END) Medium_stress_lvl,
COUNT(CASE WHEN Stress_level ='LOW' THEN 1 END) Low_stress_lvl,
COUNT(Employee_id) Total_employees,
CAST(ROUND((COUNT(CASE WHEN Stress_level ='HIGH' THEN 1 END) * 100.0) / COUNT(Employee_id), 3) AS float) High_stress_percentage,
CAST(ROUND((COUNT(CASE WHEN Stress_level ='MEDIUM' THEN 1 END) * 100.0) / COUNT(Employee_id), 3) AS float) Medium_stress_percentage,
CAST(ROUND((COUNT(CASE WHEN Stress_level ='LOW' THEN 1 END) * 100.0) / COUNT(Employee_id), 3) AS float) Low_stress_percentage
FROM MHealth.dbo.Remote_work
GROUP BY Industry
ORDER BY High_Stress_Percentage DESC,Industry;


--4.--Stress level per region
--ANS: Africa has the highest employee stress level compared to other continents
SELECT  Region,
	COUNT(CASE WHEN Stress_level ='HIGH' THEN 1 END) High_stress_lvl,
	COUNT(CASE WHEN Stress_level ='MEDIUM' THEN 1 END) Medium_stress_lvl,
	COUNT(CASE WHEN Stress_level ='LOW' THEN 1 END) Low_stress_lvl,
	COUNT(Employee_id) Total_employees,
	CAST(ROUND((COUNT(CASE WHEN Stress_level ='HIGH' THEN 1 END) * 100.0) / COUNT(Employee_id), 3) AS float) High_stress_percentage
FROM MHealth.dbo.Remote_work
GROUP BY Region
ORDER BY High_Stress_Percentage DESC,Region;


--5.--How does the number of virtual meetings affect stress levels on remote jobs? 
--ANS: No of virtual meetings doesn't seem to be the only factor for high stress level.
SELECT work_location, 
COUNT(Employee_ID) AS Total_Employees,
Number_of_Virtual_Meetings, 
COUNT(CASE WHEN Stress_Level = 'High' THEN 1 END) AS High_Stress_Count,
(COUNT(CASE WHEN Stress_Level = 'High' THEN 1 END) * 100.0) / COUNT(employee_id) AS High_Stress_Percentage
FROM MHealth.dbo.Remote_work
WHERE work_location = 'Remote' AND Number_of_Virtual_Meetings <> 0
GROUP BY Number_of_Virtual_Meetings, work_location
ORDER BY  Work_Location,Number_of_Virtual_Meetings DESC,High_Stress_Percentage DESC; 


--6.--Is there a relationship between the number of hours worked per week and mental health conditions?
--ANS: Employees with Burnout reportedly worked for 40hrs per week on average spanning across different industries.
SELECT SUM(Hours_Worked_Per_Week) Hours_worked, Mental_Health_Condition
FROM MHealth.dbo.Remote_work
--WHERE Mental_Health_Condition = 'Burnout'
GROUP BY Mental_Health_Condition
ORDER BY Hours_worked DESC;


--7.--Does company support for remote work affect work-life balance ratings? 
-- Company support is not the only determining factor. It is based on different individuals in different roles across various industries
SELECT Industry,
    AVG(Company_Support_for_Remote_Work) AS Company_support, 
    AVG(Work_Life_Balance_Rating) AS Avg_Work_Life_Balance_Rating
FROM MHealth.dbo.Remote_work
GROUP BY  Industry
ORDER BY Avg_Work_Life_Balance_Rating;

 
--8.--How does social isolation relate to productivity changes?
--ANS: High social isolation leads to a decrease in productivity change
SELECT Industry,Productivity_Change,  COUNT(Social_Isolation_Rating) Social_Isolation_Rating
FROM MHealth.dbo.Remote_work
GROUP BY Industry,Productivity_Change
ORDER BY Social_Isolation_Rating DESC,Productivity_Change ASC;


--9.-- Find the top 5 employees increase productivity change despite high isolation levels and sleep quality.
select top 5 Employee_ID, social_isolation_rating, productivity_change, Sleep_Quality
from MHealth.dbo.Remote_work
where Productivity_Change ='increase'
group by productivity_change, social_isolation_rating, Employee_ID, Sleep_Quality;


--10.--Do employees with access to mental health resources report lower Stress_Level compared to those without access?
--ANS: The percentage difference is not significant
SELECT Access_to_Mental_Health_Resources, 
    stress_level,
    ROUND((SUM(CASE WHEN Mental_Health_Condition = 'None' THEN 0 ELSE 1 END) * 100.0) / COUNT(*), 2) AS percent_without_condition
FROM MHealth.dbo.Remote_work
GROUP BY Access_to_Mental_Health_Resources, Stress_Level
ORDER BY Access_to_Mental_Health_Resources DESC,Stress_Level;

--11.--What gender report the most common mental health conditions?
--ANS: Male employees are more burned out than other genders
SELECT Gender, Mental_Health_Condition, COUNT(*) num_employees
FROM MHealth.dbo.Remote_work
GROUP BY Gender, Mental_Health_Condition
ORDER BY Gender, num_employees DESC;

--12.--How does work location influence employees' mental health Condition and Social_Isolation_Rating
SELECT Work_Location, Mental_Health_Condition, Social_Isolation_Rating, COUNT(*) AS num_employees
FROM MHealth.dbo.Remote_work
GROUP BY Work_Location,Mental_Health_Condition,Social_Isolation_Rating
ORDER BY Work_Location;

--13.--Does age affect how employees cope with stress in a remote work environment?
--The ratio is fair between the stress level. Employees below 55 seem to report high stress level.
SELECT Age, 
       COUNT(CASE WHEN Stress_Level = 'High' THEN 1 END) AS High_Stress_Count,
       COUNT(CASE WHEN Stress_Level = 'Medium' THEN 1 END) AS  Medium_Stress_Count,
       COUNT(CASE WHEN Stress_Level = 'Low' THEN 1 END) AS  Low_Stress_Count,
       COUNT(employee_id) AS Total_Employees
FROM MHealth.dbo.Remote_work
WHERE Work_Location = 'Remote'
GROUP BY Age
ORDER BY Age ASC, High_Stress_Count DESC;

--14. What role does Physical_Activity and Sleep_Quality play in maintaining good mental health for remote workers?
--These factor does not have an impact on 
SELECT Physical_Activity, Sleep_Quality,
 AVG(CASE 
         WHEN Mental_Health_Condition = 'none' THEN 1
	 WHEN Mental_Health_Condition = 'depression' THEN 2
         WHEN Mental_Health_Condition = 'anxiety' THEN 3
         WHEN Mental_Health_Condition = 'burnout' THEN 4
         ELSE NULL 
        END) AS Mental_health
FROM MHealth.dbo.Remote_work
WHERE Work_Location = 'Remote'
GROUP BY Physical_Activity, Sleep_Quality
ORDER BY Physical_Activity,Sleep_Quality;








