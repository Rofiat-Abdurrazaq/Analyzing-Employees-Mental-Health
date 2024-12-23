--Fetch all data from the table
SELECT * FROM
MHealth.dbo.Remote_work;

--1.--What is the average work-life balance rating across different job roles, and how does it impact mental health conditions?
SELECT Job_Role,  AVG(Work_life_balance_rating) Work_life_balance
FROM MHealth.dbo.Remote_work
--WHERE Work_life_balance_rating = (SELECT AVG(Work_life_balance_rating) FROM MHealth.dbo.Remote_work)
GROUP BY Job_Role
ORDER BY Job_Role;

--2a.--Which industries report the highest levels of stress? ANS: Finance has the highest stress count
SELECT Industry, Stress_level, COUNT(*) Stress_count
FROM MHealth.dbo.Remote_work
WHERE Stress_Level = 'HIGH'
GROUP BY Industry, Stress_level 
ORDER BY Stress_count DESC;

--With %35.60, Finance Industry reports the highest stress level
--2b.--stress levels per industry
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


--3--stress level per region
SELECT  Region,
	COUNT(CASE WHEN Stress_level ='HIGH' THEN 1 END) High_stress_lvl,
	COUNT(CASE WHEN Stress_level ='MEDIUM' THEN 1 END) Medium_stress_lvl,
	COUNT(CASE WHEN Stress_level ='LOW' THEN 1 END) Low_stress_lvl,
	COUNT(Employee_id) Total_employees,
	CAST(ROUND((COUNT(CASE WHEN Stress_level ='HIGH' THEN 1 END) * 100.0) / COUNT(Employee_id), 3) AS float) High_stress_percentage
FROM MHealth.dbo.Remote_work
GROUP BY Region
ORDER BY High_Stress_Percentage DESC,Region;


--4.--How does the number of virtual meetings affect stress levels? Hybrid vm != high stress, Onsite vm != high stress, remote partially
SELECT work_location, Number_of_Virtual_Meetings, 
       COUNT(CASE WHEN Stress_Level = 'High' THEN 1 END) AS High_Stress_Count,
       COUNT(CASE WHEN Stress_Level = 'Medium' THEN 1 END) AS Medium_Stress_Count,
       COUNT(CASE WHEN Stress_Level = 'Low' THEN 1 END) AS Low_Stress_Count,
       COUNT(Employee_ID) AS Total_Employees,
       (COUNT(CASE WHEN Stress_Level = 'High' THEN 1 END) * 100.0) / COUNT(employee_id) AS High_Stress_Percentage
FROM MHealth.dbo.Remote_work
GROUP BY Number_of_Virtual_Meetings, work_location
ORDER BY  Work_Location,Number_of_Virtual_Meetings DESC,High_Stress_Count; 


--5.--Is there a relationship between the number of hours worked per week and mental health conditions?
SELECT SUM(Hours_Worked_Per_Week) Hours_worked, Mental_Health_Condition
FROM MHealth.dbo.Remote_work
--WHERE Mental_Health_Condition = 'Burnout'
GROUP BY Mental_Health_Condition
ORDER BY Hours_worked DESC;


--6.--Does company support for remote work affect work-life balance ratings? 
-- Not the only determining factor. its based on different indidviduals in different roles across various industries
SELECT Job_Role,Work_Life_Balance_Rating,Company_Support_for_Remote_Work
FROM MHealth.dbo.Remote_work
WHERE Work_Location = 'Remote' AND Company_Support_for_Remote_Work >= 3
ORDER BY Company_Support_for_Remote_Work DESC,Work_Life_Balance_Rating;

SELECT Industry,
    AVG(Company_Support_for_Remote_Work) AS Company_support, 
    AVG(Work_Life_Balance_Rating) AS Avg_Work_Life_Balance_Rating
FROM MHealth.dbo.Remote_work
GROUP BY  Industry
ORDER BY Avg_Work_Life_Balance_Rating;

 
--7.--How does social isolation relate to productivity changes?
SELECT Industry,Productivity_Change,  COUNT(Social_Isolation_Rating) Social_Isolation_Rating
FROM MHealth.dbo.Remote_work
GROUP BY Industry,Productivity_Change
ORDER BY Social_Isolation_Rating,Industry ASC;

---------------------------------------------------------------
--8. Does company support for remote work affect work-life balance ratings?
SELECT industry, company_support_for_remote_work, AVG(work_life_balance_rating) as avg_work_life_balance_rating,
COUNT(*) as number_of_ratings
FROM MHealth.dbo.Remote_work
GROUP BY company_support_for_remote_work, Industry
ORDER BY avg_work_life_balance_rating DESC
----------------------------------------------

--9.--COMPANY support does seems not to be the only factor that determines work life balnace rating
SELECT company_support_for_remote_work, AVG(work_life_balance_rating) avg_work_life_balance_rating,
COUNT(*)  number_of_ratings
FROM MHealth.dbo.Remote_work
GROUP BY company_support_for_remote_work
ORDER BY company_support_for_remote_work;
--yes 

--10.-- How does social isolation relate to productivity changes?
select industry, social_isolation_rating, productivity_change
from MHealth.dbo.Remote_work
group by productivity_change, social_isolation_rating, industry
order by Industry;

--11.--dependent on the individual
select Job_Role, social_isolation_rating, productivity_change
from MHealth.dbo.Remote_work
group by productivity_change, social_isolation_rating, Job_Role
order by Job_Role;

--12.-- Find the top 5 employees with the highest productivity despite high isolation levels
select top 5 Employee_ID, social_isolation_rating, productivity_change, Sleep_Quality
from MHealth.dbo.Remote_work
where Productivity_Change ='increase'
group by productivity_change, social_isolation_rating, Employee_ID, Sleep_Quality;


--13.--Do employees with access to mental health resources (Access_to_Mental_Health_Resources) report better Mental_Health_Condition and lower Stress_Level compared to those without access?
SELECT Access_to_Mental_Health_Resources, 
    stress_level,
    ROUND((SUM(CASE WHEN Mental_Health_Condition = 'None' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS percent_without_condition
FROM MHealth.dbo.Remote_work
GROUP BY Access_to_Mental_Health_Resources, Stress_Level
ORDER BY percent_without_condition DESC;

--14.--What are the most common mental health conditions reported by gender
SELECT Gender, Mental_Health_Condition, COUNT(*) num_employees
FROM MHealth.dbo.Remote_work
GROUP BY Gender, Mental_Health_Condition
ORDER BY Gender, num_employees DESC;


--15.--How does work location influence employees' mental health Condition and Social_Isolation_Rating
SELECT Work_Location, Mental_Health_Condition, Social_Isolation_Rating, COUNT(*) AS num_employees
FROM MHealth.dbo.Remote_work
GROUP BY Work_Location,Mental_Health_Condition,Social_Isolation_Rating
ORDER BY Work_Location;

--16.--Does age affect how employees cope with stress in a remote work environment?
SELECT Age, 
       count(case when Stress_Level = 'High' then 1 end) as High_Stress_Count,
       count(case when Stress_Level = 'Medium' then 1 end) as  Medium_Stress_Count,
       count(case when Stress_Level = 'Low' then 1 end) as  Low_Stress_Count,
       COUNT(employee_id) AS Total_Employees,
       (count(case when Stress_Level = 'High' then 1 end) * 100.0) / COUNT(employee_id) AS High_Stress_Percentage
from MHealth.dbo.Remote_work
group by Age
order by High_Stress_Percentage desc

--17. What role does Physical_Activity and Sleep_Quality play in maintaining good mental health for remote workers?
SELECT Physical_Activity, Sleep_Quality,
 AVG(CASE 
         WHEN Mental_Health_Condition = 'none' THEN 1
		 WHEN Mental_Health_Condition = 'depression' THEN 2
         WHEN Mental_Health_Condition = 'anxiety' THEN 3
         WHEN Mental_Health_Condition = 'burnout' THEN 4
         ELSE NULL 
        END) AS avg_mental_health_rating
FROM MHealth.dbo.Remote_work
GROUP BY Physical_Activity, Sleep_Quality
ORDER BY Physical_Activity,Sleep_Quality;


--18.--Does working more hours per week(hours worked per week) lead to higher levels of stress (Stress Level) or poorer mental health?
SELECT Industry, Stress_level, COUNT(*) Stress_count, COUNT(Hours_worked_per_week)
FROM MHealth.dbo.Remote_work
WHERE Stress_Level = 'HIGH'
GROUP BY Industry, Stress_level 
ORDER BY Stress_count DESC;


--19.--What role does Physical_Activity and Sleep_Quality play in maintaining good mental health for remote workers?
SELECT Industry, Physical_Activity, Sleep_Quality, Work_Location
FROM MHealth.dbo.Remote_work;







