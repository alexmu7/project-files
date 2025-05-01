--SQL entity relationship design project, This database will be an efficient system to track all electronic equipment repairs entered through the ITS Desk in a virtual college Library at State College. They relationship consists of important metadata such as Employee manager faculty information, repair information including date and type of device. There is a third party vendor for repair services in case the ITS employee is not able to complete the repair service.

--SQL Skill used: altering and inserting data values into tables, queries using subqueries, joins, aggregates, set operators.



--1) SETUP QUERIES



--Check In Electronic for new user
Insert into Customers values (9000000016, 'FirstNam', 'LastNam', '111 Test Street', '1/23/1996', 'Student')
 
-- Add relation
Insert into [Employee and Customer Relation] values (1360, 9000000016)
 
-- Add electronic
Insert into Electronics values (16, 9000000016, 'Laptop', 'Dell', 'Windows 10', 4/19/2017, Null)
 
--Check Out Electronic
Update Electronics
SET [Checkout Date] = '4/22/2017'
Where [E.Gen. Ticket No] = 16
 
--Check If Owner
Select [E.Gen. Ticket No] from Electronics where Owner = '9000000005'

--Check if Relation Exists
Select * From [Employee and Customer Relation] ECR
Where ECR.[Employee ID] = '1185' and ECR.[Customer ID] = '9000000012'
 
--Add Relation to the ER diagram
Insert into [Employee and Customer Relation] values
(1360, 9000000016)



--2) REPAIR QUERIES


  
--Look Up Third Parties
Select Distinct R.[TP Name], R.[TP Phone Number]
From Repairs R join Electronics E on R.[Gen ticket number] = E.[E.Gen. Ticket No]
Where R.[Issue Type] Like 'Cracked Screen' and E.[Type Of Device] Like '%'

--Add Repair
Insert into Repairs values (1360, 16, 'State College Electronics', 2342786692, GetDate(), Null, 'Virus')
 
--Finish Repair
Update Repairs
Set [Repair End Date] = GetDate()
Where [Employee ID] = 1360 and [Gen ticket number] = 16
and [TP Name] = 'State College Electronics' and [TP Phone Number] = 2342786692
 
--Look Up Ongoing repairs
Select [Employee ID], [Gen ticket number], [TP Name], [TP Phone Number],
[Repair Start Date], [Issue Type]
From Repairs
Where [Employee ID] = 1360 and [Repair End Date] is Null

--Look Up Experienced Employees
Select E.[First Name], E.[Last Name]
From Employees E join Repairs R on E.EmployeeID = R.[Employee ID]
Where R.[Issue Type] = 'Cracked Screen'

--Update Third Party
Update Repairs
Set [TP Name] = 'Computerprints', [TP Phone Number] = '2346212365'
Where [Employee ID] = 1360 and [Gen ticket number] = 16
and [TP Name] = 'State College Electronics' and [TP Phone Number] = '2342786692'



--3) FACULTY LOOKUP QUERIES



--Look Up Employees and Their Supervisor
Select E.[First Name] as SubFirstFame, M.[First Name] as SupFirstName
From Employees E left outer join Employees M on E.SupervisorID = M.EmployeeID

--Look Up Team with Most Repairs Since a Date
Select T.[Team Name], count(*) as NumReps
From Teams T join Employees E on T.[Team Name] = E.[Team Name]
  	join Repairs R on E.EmployeeID=R.[Employee ID]
Where R.[Repair End Date] > '11/1/2016'
Group By T.[Team Name]
Having count(*) = (
  	Select max(r.numReps)
  	From (
         	Select count(*) as numReps
         	From Teams T join Employees E on T.[Team Name] = E.[Team Name]
               	join Repairs R on E.EmployeeID=R.[Employee ID]
         	Where R.[Repair End Date] > '11/1/2016'
         	Group By T.[Team Name]
  	) r
)

--Look Up Team with Most Repairs Between Two Dates
Select T.[Team Name], count(*) as NumReps
From Teams T join Employees E on T.[Team Name] = E.[Team Name]
  	join Repairs R on E.EmployeeID=R.[Employee ID]
Where R.[Repair End Date] between '9/1/2016' and '9/30/2016'
Group By T.[Team Name]
Having count(*) = (
  	Select max(r.numReps)
  	From (
         	Select count(*) as numReps
         	From Teams T join Employees E on T.[Team Name] = E.[Team Name]
               	join Repairs R on E.EmployeeID=R.[Employee ID]
         	Where R.[Repair End Date] between '9/1/2016' and '9/30/2016'
         	Group By T.[Team Name]
  	) r
)
