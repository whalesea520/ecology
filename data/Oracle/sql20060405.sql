create or replace procedure HrmResource_SelectAll 
 (	flag out integer  , 
  	msg  out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
	) 
AS
begin 
open thecursor for
select 
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
from HrmResource  ;
end;
/