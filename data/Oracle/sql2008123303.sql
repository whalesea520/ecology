CREATE OR REPLACE PROCEDURE HrmDepartment_Update (id_1 integer, departmentmark_2 varchar2, departmentname_3 varchar2, supdepid_4 integer, allsupdepid_5 varchar2, subcompanyid1_6 	integer, showorder_7 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
count0 int;
count1 int;
begin
select count(*) into count0 from HrmDepartment where subcompanyid1=subcompanyid1_6 and departmentmark=departmentmark_2 and id!=id_1 and supdepid = supdepid_4;
select count(*) into count1 from HrmDepartment where subcompanyid1=subcompanyid1_6 and departmentname=departmentname_3 and id!=id_1 and supdepid = supdepid_4;
if count0>0 then
   flag:=2;
   msg:='该部门简称已经存在，不能保存！' ;
   return;
end if;  
if count1>0 then
   flag:=3;
   msg:='该部门全称已经存在，不能保存！' ;
   return;
end if; 
UPDATE HrmDepartment SET departmentmark = departmentmark_2, departmentname	= departmentname_3, supdepid = supdepid_4, allsupdepid = allsupdepid_5, subcompanyid1 = subcompanyid1_6, showorder = showorder_7 WHERE ( id	 = id_1); 
end;
/

CREATE OR REPLACE PROCEDURE HrmDepartment_Insert ( departmentmark_1 varchar2, departmentname_2 	varchar2, supdepid_3 integer, allsupdepid_4 varchar2, subcompanyid1_5 integer, showorder_6 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
count0 int;
count1 int;
begin
select count(*) into count0 from HrmDepartment where subcompanyid1=subcompanyid1_5 and departmentmark=departmentmark_1 and supdepid=supdepid_3;
select count(*) into count1 from HrmDepartment where subcompanyid1=subcompanyid1_5 and departmentname=departmentname_2 and supdepid=supdepid_3;
if count0>0 then
   flag:=2;
   msg:='该部门简称已经存在，不能保存！' ;
   return;
end if; 
if count1>0 then
   flag:=3;
   msg:='该部门全称已经存在，不能保存！' ;
   return;
end if; 
INSERT INTO HrmDepartment ( departmentmark, departmentname, supdepid, allsupdepid, subcompanyid1, showorder) VALUES ( departmentmark_1, departmentname_2, supdepid_3, allsupdepid_4, subcompanyid1_5, showorder_6) ; 
open thecursor for select (max(id)) from HrmDepartment ; 
end;
/