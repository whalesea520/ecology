ALTER PROCEDURE HrmDepartment_Select
@flag integer output , 
@msg varchar(80) output 
AS 
select * from HrmDepartment order by subcompanyid1,supdepid ,showorder,departmentname;
set  @flag = 0 set  @msg = '操作成功完成' 
GO

ALTER PROCEDURE HrmSubCompany_Select
@flag integer output , 
@msg varchar(80) output 
AS
select * from HrmSubCompany order by supsubcomid,showorder,subcompanyname
set  @flag = 0 
set  @msg = '操作成功完成'
GO
