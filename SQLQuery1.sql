select BusinessEntityID,Rate,
ROW_NUMBER() over(order by Rate desc) 'Series',
RANK() over (order by Rate desc) 'rank',
DENSE_RANK() over(order by Rate desc) 'WithoutGap'
from HumanResources.EmployeePayHistory

---------create---------
create table empsales
(
productid int not null,
month int not null,
sales int not null
)

select * from empsales
insert into EmpSales (productid,month,sales)
values (1,1,2000), (1,2,4500),(2,3,4800),(3,4,5600),(4,5,1500)

select month,sales 'Current Month',
Lead(Sales) over(order by Month) 'Next Month',
Lag(Sales) over (order by Month) 'Previous Month'
from empsales

---------------order by---------------
select BusinessEntityID, JobTitle,VacationHours
from HumanResources.Employee
where VacationHours>Any (select VacationHours
from HumanResources.Employee
where JobTitle='Recruiter')
order by VacationHours

select JobTitle, VacationHours 
from HumanResources.Employee e1
where JobTitle in('Buyer','Recruiter') and 
e1.VacationHours>(Select avg(VacationHours)
from HumanResources.Employee e2
where e1.JobTitle=e2.JobTitle
)
select * from HumanResources.Employee

select JobTitle, VacationHours 
from HumanResources.Employee e1
where JobTitle in('Design Engineer','Tool Designer') and 
e1.VacationHours>(Select avg(VacationHours)
from HumanResources.Employee e2
where e1.JobTitle=e2.JobTitle
)
-------------------rate int------------------------------------
declare @rate int
select @rate=max(Rate)
from HumanResources.EmployeePayHistory
print @rate
if (@rate<120)
begin
print 'No need to revise'
end
go

---------------------
create proc prcSales
as
begin
select * from empsales
end

exec prcSales


--------procedure----------
create proc prcEmpTitle @title varchar(20)
as
begin
select BusinessEntityID,LoginID,Gender
from HumanResources.Employee
where JobTitle=@title
end

exec prcEmpTitle 'Tool Designer'

alter proc prcTitleVH @title varchar(20), @vh int output
as
begin
select @vh=VacationHours
from HumanResources.Employee
where JobTitle=@title
end

Declare @v int 
exec prcTitleVH 'Tool Designer',@v output
print @v



create proc prcTitle @t varchar(20)
as
begin
Select BusinessEntityID,LoginId, JobTitle
from HumanResources.Employee
where JobTitle=@t
end



create proc prcEmpDName @e int
as
begin
select Name
from HumanResources.Department d
where DepartmentID=(select DepartmentID
from HumanResources.EmployeeDepartmentHistory 
where BusinessEntityID=@e)
end 

exec prcEmpDName 15


---------create procedure and insert values by calling it-----

create proc prcInsert
(
@sampleid int,
@samplename varchar(20)
)
as
begin
declare @tblSample Table(id int, Name varchar(20))
insert into @tblSample (id,Name) values(@sampleid,@samplename)
select * from @tblSample
end
