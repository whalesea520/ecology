CREATE or replace PROCEDURE HrmSubCompany_Select
(flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 as 
begin 
open thecursor for select * from HrmSubCompany order by showorder,subcompanyname; 
end;
/

 CREATE OR REPLACE PROCEDURE HrmDepartment_Select 
 (
  	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	) 
AS
begin
open thecursor for
select * from HrmDepartment order by showorder,departmentname;
end;
/