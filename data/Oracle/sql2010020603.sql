CREATE OR REPLACE PROCEDURE HrmDepartment_Insert ( departmentmark_1 varchar2, departmentname_2 	varchar2, supdepid_3 integer, allsupdepid_4 varchar2, subcompanyid1_5 integer, showorder_6 integer,coadjutant_7 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS
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
INSERT INTO HrmDepartment ( departmentmark, departmentname, supdepid, allsupdepid, subcompanyid1, showorder,coadjutant) VALUES ( departmentmark_1, departmentname_2, supdepid_3, allsupdepid_4, subcompanyid1_5, showorder_6,coadjutant_7) ; 
open thecursor for select (max(id)) from HrmDepartment ; 
end;
/

CREATE OR REPLACE PROCEDURE HrmDepartment_Update (id_1 integer, departmentmark_2 varchar2, departmentname_3 varchar2, supdepid_4 integer, allsupdepid_5 varchar2, subcompanyid1_6 	integer, showorder_7 integer,coadjutant_8 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS 
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
UPDATE HrmDepartment SET departmentmark = departmentmark_2, departmentname	= departmentname_3, supdepid = supdepid_4, allsupdepid = allsupdepid_5, subcompanyid1 = subcompanyid1_6, showorder = showorder_7,coadjutant=coadjutant_8 WHERE ( id	 = id_1); 
end;
/

CREATE OR REPLACE PROCEDURE workflow_CurOpe_UbySend 
	(requestid_0	integer, 
	 userid_0	integer, 
	 usertype_0	integer,
	 isremark_0 char,
	 flag out integer,
	 msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
AS  
	 currentdate_0 varchar(10); 
	 currenttime_0 varchar(8) ;
begin	 
    select to_char(sysdate,'yyyy-mm-dd') into currentdate_0 from dual;
    select to_char(sysdate,'hh24:mi:ss') into currenttime_0 from dual;
update workflow_currentoperator 
set isremark=2,operatedate=currentdate_0,operatetime=currenttime_0 
where requestid =requestid_0 and userid =userid_0 and usertype=usertype_0 and isremark=isremark_0;
end;
/

CREATE OR REPLACE PROCEDURE workflow_CurOpe_UbySendNB
	(requestid_0	integer, 
	 userid_0	integer, 
	 usertype_0	integer,
	 isremark_0 char, 
	 flag out integer,
	 msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
AS  
	 currentdate_0 varchar(10); 
	 currenttime_0 varchar(8) ;
begin	 
    select to_char(sysdate,'yyyy-mm-dd') into currentdate_0 from dual;
    select to_char(sysdate,'hh24:mi:ss') into currenttime_0 from dual;
update workflow_currentoperator 
set isremark=2,operatedate=currentdate_0,operatetime=currenttime_0,needwfback='0'
where requestid =requestid_0 and userid =userid_0 and usertype=usertype_0 and ((isremark=isremark_0) or (preisremark=8 and isremark=2));
end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebySubmit 
(userid_2	integer, requestid_1 integer,groupid_1 integer,nodeid_2 integer,isremark_0 char,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set operatedate = currentdate,operatetime = currenttime,viewtype=-2 where requestid = requestid_1 and userid = userid_2 and isremark=isremark_0 and groupid = groupid_1 and nodeid=nodeid_2;

update workflow_currentoperator set isremark = '2' where requestid =requestid_1 and isremark=isremark_0 and groupid =groupid_1 and nodeid=nodeid_2;

update workflow_currentoperator set isremark = '2' where requestid =requestid_1 and (isremark='5' or isremark='8' or isremark='9') and userid = userid_2;
end;
/

CREATE or REPLACE PROCEDURE workflow_groupdetail_Insert
(
groupid_1 integer, 
type_2 	integer, 
objid_3 	integer, 
level_4 	integer, 
level2_5 	integer,
conditions_6 varchar2,
conditioncn_7 varchar2,
orders_8 number,
signorder_9 char,
IsCoadjutant_10 char,
signtype_11 char,
issyscoadjutant_12 char,
issubmitdesc_13 char,
ispending_14 char,
isforward_15 char,
ismodify_16 char,
coadjutants_17 varchar2,
coadjutantcn_18 varchar2, 
flag out integer  , 
msg out varchar2  ,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin 
INSERT INTO workflow_groupdetail (groupid, type, objid, level_n, level2_n,conditions,conditioncn,orders,signorder,IsCoadjutant,signtype,issyscoadjutant,issubmitdesc,ispending,isforward,ismodify,coadjutants,coadjutantcn)  
VALUES (groupid_1, type_2, objid_3, level_4, level2_5,conditions_6,conditioncn_7,orders_8,signorder_9,IsCoadjutant_10,signtype_11,issyscoadjutant_12,issubmitdesc_13,ispending_14,isforward_15,ismodify_16,coadjutants_17,coadjutantcn_18);
OPEN thecursor FOR select max(id) from workflow_groupdetail;
end;
/

CREATE OR REPLACE PROCEDURE workflow_groupdetail_SByGroup 
(id_1 	integer, 	 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS begin open thecursor for 
SELECT id, groupid, type, objid, level_n, level2_n, conditions, conditioncn, orders, signorder,case when signorder in(3,4) then 10000+signorder else 1+orders  end as sort,IsCoadjutant,signtype,issyscoadjutant,issubmitdesc,ispending,isforward,ismodify,coadjutants,coadjutantcn from workflow_groupdetail where groupid=id_1 order by sort;
end;
/
