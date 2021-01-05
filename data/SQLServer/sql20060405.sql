alter PROCEDURE HrmResource_SelectAll 
 (@flag integer output, @msg   varchar(80) output ) 
AS select 
  id,
  loginid,  
  lastname,
  sex,
  resourcetype,
  email,
  locationid,
  workroom, 
  departmentid,
  costcenterid,
  jobtitle,
  managerid,
  assistantid ,
  seclevel,
  joblevel,
  status,
  account,
  mobile
from HrmResource  
if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end 

GO