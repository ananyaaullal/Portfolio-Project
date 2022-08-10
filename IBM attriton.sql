--Percentage of attrition based on Department
SELECT
  Department,
COUNT(Department)ASno_per_dep,
COUNT(Department)*100/(
SELECT
SUM(EmployeeCount)AStotal_count
FROM
`project-1-358005.ibm.employee_attrition`)AS Percentage
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE
GROUPBY
  Department

--Percentage Attrition per department
SELECT
  Department,
COUNT(Department)ASno_per_dep,
COUNT(Department)*100/(
SELECT
SUM(EmployeeCount)AStotal_count
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE)AS Percentage
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE
GROUPBY
  Department


--Attrition based on Job Role
SELECT
  Department,
JobRole,
COUNT(EmployeeCount)ASattrition_by_jobrole
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition= TRUE
GROUPBY
JobRole,
  Department
ORDERBY
attrition_by_jobrole DESC


--Attrition based on Job Performance
SELECT
  Department,
PerformanceRating,
COUNT(Department)AScount_per_dep,
Jobrole
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition = TRUE
GROUPBY
  Department,
PerformanceRating,
JobRole
ORDERBY
count_per_dep DESC

(Employees with good job performance were leaving)

--based on last promotion and years at the company
SELECT
YearsSinceLastPromotion,
YearsAtCompany,
JobRole,
COUNT(Department)AScount_per_dep
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition = TRUE
GROUPBY
  Department,
JobRole,
YearsSinceLastPromotion,
YearsAtCompany
ORDERBY
count_per_depDESC

-- No of employees doing overtime (where attrition is true)
SELECT
  Department,
COUNT(OverTime)ASno_overtime
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE
ANDOverTime=TRUE
GROUPBY
  Department,
  Overtime
ORDERBY
no_overtimeDESC


--Percentage of people doing overtime where attrition is true
SELECT
  Department,
COUNT(OverTime)ASno_overtime,
COUNT(OverTime)*100/(
SELECT
SUM(EmployeeCount)AStotal_dep
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE)ASpercentage_overtime
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition= TRUE
ANDOverTime=TRUE
GROUPBY
  Department
ORDERBY
percentage_overtimeDESC


--Perentage attrition based on OverTime (Deaprtment-wise)
WITH
dep_countAS(
SELECT
    Department,
OverTime,
SUM(EmployeeCount)OVER(PARTITIONBY Department ORDERBY Department )AStotal_dep
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE)
SELECT
  Department,
total_dep,
COUNT(OverTime)AStotal_overtime,
ROUND(COUNT(OverTime)*100/total_dep,2)AS percentage
FROM
dep_count
WHERE
OverTime=TRUE
GROUPBY
dep_count.Department,
dep_count.total_dep
ORDERBY
dep_count.total_depDESC


-- Average Monthly income of a jobrole VS Average Monthly Income of a jobrole who attritioned
WITH
Avg_Mon_IncAS(
SELECT
    Department,
JobRole,
ROUND(AVG(MonthlyIncome)OVER(PARTITIONBYJobRole),2)ASAvg,
    Attrition,
MonthlyIncome
FROM
`project-1-358005.ibm.employee_attrition`)
SELECT
Avg_Mon_Inc.Department,
Avg_Mon_Inc.JobRole,
Avg_Mon_Inc.Avg,
ROUND(AVG(Avg_Mon_Inc.MonthlyIncome),2)ASattri_avg
FROM
Avg_Mon_Inc
WHERE
Avg_Mon_Inc.Attrition = TRUE
GROUPBY
Avg_Mon_Inc.Department,
Avg_Mon_Inc.JobRole,
Avg_Mon_Inc.Avg


--Percentage attritioned based on Gender
SELECT
  Gender,
COUNT(Gender)ASnum_gen_attri,
COUNT(Gender)*100/(
SELECT
SUM(EmployeeCount)
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE)ASpercent_gender_attri
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE
GROUPBY
  Gender


--Comparison of average 'Distance From Home' of employees attritioned and not attritioned
SELECT
AVG(DistanceFromHome)avg_dis_attri,
(
SELECT
AVG(DistanceFromHome)
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=FALSE)ASavg_dis_non_attri
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE

--Comparison of average 'Distance From Home' of employees attritioned and not attritioned with Total Average of Distance From Home
WITH
avg_totalAS(
SELECT
AVG(DistanceFromHome)avg_dis_attri,
(
SELECT
AVG(DistanceFromHome)
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=FALSE)ASavg_dis_non_attri
FROM
`project-1-358005.ibm.employee_attrition`
WHERE
Attrition=TRUE)
SELECT
AVG(avg_total.avg_dis_attri)/2+AVG(avg_total.avg_dis_non_attri)/2AStotal_avg_dis,
avg_total.avg_dis_attri,
avg_total.avg_dis_non_attri
FROM
avg_total
GROUPBY
2,
3

