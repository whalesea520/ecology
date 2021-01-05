CREATE OR REPLACE PROCEDURE HrmDepartment_Select 
 (
  	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	) 
AS
begin
open thecursor for
select * from HrmDepartment order by subcompanyid1,supdepid ,showorder,departmentname;
end;
/

CREATE or replace PROCEDURE HrmSubCompany_Select
(flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin
open thecursor for select * from HrmSubCompany order by supsubcomid,showorder,subcompanyname;
end;
/
