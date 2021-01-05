create or replace procedure  WorkTaskShareSet_Insert (taskid_1       integer, taskstatus_1	integer,sharetype_1	integer, seclevel_1	integer, rolelevel_1	integer, 
sharelevel_1	integer, userid_1	varchar2, subcompanyid_1	varchar2, departmentid_1	varchar2, 
roleid_1	integer, foralluser_1	integer, sharetype_2	integer, seclevel_2	integer, rolelevel_2	integer,
 userid_2	varchar2, subcompanyid_2	varchar2, departmentid_2	varchar2, roleid_2	integer, foralluser_2	integer, 
 settype_1	integer,
flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)
 as
 begin 
 insert into WorkTaskShareSet(taskid,taskstatus,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,
departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype) 
values(taskid_1,taskstatus_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,subcompanyid_1,departmentid_1,roleid_1,foralluser_1,sharetype_2,
seclevel_2,rolelevel_2,userid_2,subcompanyid_2,departmentid_2,roleid_2,foralluser_2,settype_1);
end;
/

create or replace procedure WorkTaskCreateShare_Insert (
taskid_1	integer,
sharetype_1	integer,
seclevel_1	integer, 
rolelevel_1	integer, 
userid_1	integer, 
subcompanyid_1	integer, 
departmentid_1	integer, 
roleid_1	integer, 
foralluser_1	integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
insert into WorkTaskCreateShare 
(taskid,sharetype,seclevel,rolelevel,userid,subcompanyid,departmentid,roleid,foralluser)
values (taskid_1, sharetype_1, seclevel_1, rolelevel_1, userid_1, subcompanyid_1, departmentid_1, roleid_1, foralluser_1) ;
end;
/

create or replace procedure WorkTaskCreateShare_Delete (id_1	integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as
begin
	 delete from WorkTaskCreateShare where id=id_1;
end;
/


create or replace procedure worktask_RequestID_Update(flag out integer, msg out varchar2,thecursor IN OUT cursor_define.weavercursor )
AS
begin
	 update worktask_requestsequence set requestid=requestid+1;
	 open thecursor for select requestid from worktask_requestsequence;
end;
/
