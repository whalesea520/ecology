/*td:1515 by zxf for 不能创建重复的分部*/
CREATE OR REPLACE PROCEDURE HrmSubCompany_Insert (subcompanyname_1 	varchar2, subcompanydesc_2 	varchar2, companyid_3 	smallint, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
count0 int;
count1 int;
begin 
select count(*) into count0 from HrmSubCompany where subcompanyname=subcompanyname_1 ;
select count(*) into count1 from HrmSubCompany where subcompanydesc=subcompanydesc_2 ;
if count0>0 then
   flag:=2;
   msg:='该分部简称已经存在，不能保存！' ;
   return;
end if; 
if count1>0 then
   flag:=3;
   msg:='该分部全称已经存在，不能保存！' ;
   return;
end if;
INSERT INTO HrmSubCompany ( subcompanyname, subcompanydesc, companyid) VALUES ( subcompanyname_1, subcompanydesc_2, companyid_3); 
open thecursor for select (max(id)) from HrmSubCompany ; 
end;
/

CREATE OR REPLACE PROCEDURE HrmSubCompany_Update (id_1 	integer, subcompanyname_2 	varchar2, subcompanydesc_3 	varchar2, companyid_4 	smallint, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
count0 int;
count1 int;
begin 
select count(*) into count0 from HrmSubCompany where subcompanyname=subcompanyname_2 and id!=id_1;
select count(*) into count1 from HrmSubCompany where subcompanydesc=subcompanydesc_3 and id!=id_1;
if count0>0 then
   flag:=2;
   msg:='该分部简称已经存在，不能保存！' ;
   return;
end if; 
if count1>0 then
   flag:=3;
   msg:='该分部全称已经存在，不能保存！' ;
   return;
end if; 
UPDATE HrmSubCompany SET subcompanyname	 = subcompanyname_2, subcompanydesc	 = subcompanydesc_3, companyid	 = companyid_4  WHERE ( id	 = id_1) ; 
end;
/

insert into ErrorMsgIndex values (40,'分部简称重复') 
/
insert into ErrorMsgInfo values (40,'该分部简称已经存在，不能保存',7) 
/
insert into ErrorMsgInfo values (40,'The branch name duplicated',8) 
/
insert into ErrorMsgIndex values (43,'分部全称重复') 
/
insert into ErrorMsgInfo values (43,'该分部全称已经存在，不能保存',7) 
/
insert into ErrorMsgInfo values (43,'The branch name duplicated',8) 
/

/*td:1517 by zxf for 不能创建重复的部门*/
CREATE OR REPLACE PROCEDURE HrmDepartment_Insert ( departmentmark_1 varchar2, departmentname_2 	varchar2, supdepid_3 integer, allsupdepid_4 varchar2, subcompanyid1_5 integer, showorder_6 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
count0 int;
count1 int;
begin
select count(*) into count0 from HrmDepartment where subcompanyid1=subcompanyid1_5 and departmentmark=departmentmark_1;
select count(*) into count1 from HrmDepartment where subcompanyid1=subcompanyid1_5 and departmentname=departmentname_2;
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

CREATE OR REPLACE PROCEDURE HrmDepartment_Update (id_1 integer, departmentmark_2 varchar2, departmentname_3 varchar2, supdepid_4 integer, allsupdepid_5 varchar2, subcompanyid1_6 	integer, showorder_7 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
count0 int;
count1 int;
begin
select count(*) into count0 from HrmDepartment where subcompanyid1=subcompanyid1_6 and departmentmark=departmentmark_2 and id!=id_1;
select count(*) into count1 from HrmDepartment where subcompanyid1=subcompanyid1_6 and departmentname=departmentname_3 and id!=id_1;
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

insert into ErrorMsgIndex values (41,'部门名称重复') 
/
insert into ErrorMsgInfo values (41,'该部门简称已经存在，不能保存',7) 
/
insert into ErrorMsgInfo values (41,'The department name duplicated',8) 
/
insert into ErrorMsgIndex values (44,'部门全称重复') 
/
insert into ErrorMsgInfo values (44,'该部门全称已经存在，不能保存',7) 
/
insert into ErrorMsgInfo values (44,'The department name duplicated',8) 
/

/*td:1519 by zxf for 限制被引用的办公地点不能被删除 */
CREATE OR REPLACE PROCEDURE HrmLocations_Delete
(id_1 	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as 
count0 int;
begin
select count(*) into count0 from HrmLocations a join HrmResource b on a.id=b.locationid;
if count0>0 then
flag:=2;
msg:='办公地点在使用中';
return;
end if;
delete HrmLocations  WHERE ( id=id_1); 
end;
/

insert into ErrorMsgIndex values (42,'办公地点在使用中') 
/
insert into ErrorMsgInfo values (42,'办公地点在使用中，不能删除',7) 
/
insert into ErrorMsgInfo values (42,'the site has been used',8) 
/

