ALTER TABLE  workflow_nodecustomrcmenu add subnobackName7 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add subnobackName8 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add subbackName7 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add subbackName8 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add forsubnobackName7 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add forsubnobackName8 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add forsubbackName7 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add forsubbackName8 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add ccsubnobackName7 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add ccsubnobackName8 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add ccsubbackName7 varchar(50) null
/
ALTER TABLE  workflow_nodecustomrcmenu add ccsubbackName8 varchar(50) null
/
ALTER TABLE workflow_nodecustomrcmenu add hasfornoback char(1) null
/
ALTER TABLE workflow_nodecustomrcmenu add hasforback char(1) null
/
ALTER TABLE workflow_nodecustomrcmenu add hasccnoback char(1) null
/
ALTER TABLE workflow_nodecustomrcmenu add hasccback char(1) null
/
ALTER TABLE workflow_nodecustomrcmenu add hasnoback char(1) null
/
ALTER TABLE workflow_nodecustomrcmenu add hasback char(1) null
/
ALTER table workflow_currentoperator add needwfback char(1) null
/
update workflow_nodecustomrcmenu set subbackName7 = submitName7, hasback='1' where submitName7 is not null
/
update workflow_nodecustomrcmenu set subbackName8 = submitName8, hasback='1' where submitName8 is not null
/
update workflow_nodecustomrcmenu set forsubbackName7 = forsubName7, hasforback='1' where forsubName7 is not null
/
update workflow_nodecustomrcmenu set forsubbackName8 = forsubName8, hasforback='1' where forsubName8 is not null
/
update workflow_nodecustomrcmenu set ccsubbackName7 = ccsubName7, hasccback='1' where ccsubName7 is not null
/
update workflow_nodecustomrcmenu set ccsubbackName8 = ccsubName8, hasccback='1' where ccsubName8 is not null
/
update workflow_currentoperator set needwfback='1'
/

CREATE OR REPLACE PROCEDURE workflow_CurrentOperator_I
( requestid1    integer, userid1        integer, groupid1    in out integer,
workflowid1    integer, workflowtype1    integer, usertype1    integer, isremark1    char  ,nodeid  integer,agentorbyagentid  integer,agenttype  char,showorder integer,groupdetailid_1 integer,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS
workflowtype2 integer;
receivedate char(10);
receivetime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into receivedate from dual;
select to_char(sysdate,'hh24:mi:ss') into receivetime from dual;

if groupid1 is null 
then groupid1 := 0 ; 
end if ;

update workflow_currentoperator set islasttimes=0 where requestid=requestid1 and userid=userid1 and usertype = usertype1;

if workflowtype1 = ''  or workflowtype1 is null
then 
select  workflowtype INTO  workflowtype2 from workflow_base where id = workflowid1;
insert into workflow_currentoperator 
(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid,preisremark,needwfback)
values(requestid1,userid1,groupid1, workflowid1,workflowtype2,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,0,1,groupdetailid_1,isremark1,'1'); 
else
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid,preisremark,needwfback)
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,0,1,groupdetailid_1,isremark1,'1'); 
end if ;

end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebyPassNB
(requestid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator 
set isremark=2,operatedate=currentdate,operatetime=currenttime, needwfback='0'
where requestid =requestid_1 and isremark=0;

end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UbySubmitNB 
(userid_2	integer, requestid_1 integer,groupid_1 integer,nodeid_2 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set operatedate = currentdate,operatetime = currenttime,viewtype=-2 where requestid = requestid_1 and userid = userid_2 and isremark='0' and groupid = groupid_1 and nodeid=nodeid_2;

update workflow_currentoperator set isremark = '2', needwfback='0' where requestid =requestid_1 and isremark='0' and groupid =groupid_1 and nodeid=nodeid_2;

update workflow_currentoperator set isremark = '2', needwfback='0' where requestid =requestid_1 and (isremark='1' or isremark='5' or isremark='8' or isremark='9') and userid = userid_2;
end;
/

CREATE OR REPLACE PROCEDURE workflow_CurOpe_UbySendNB
	(requestid_0	integer, 
	 userid_0	integer, 
	 usertype_0	integer, 
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
where requestid =requestid_0 and userid =userid_0 and usertype=usertype_0 and ((isremark=9) or (preisremark=8 and isremark=2));
end;
/

CREATE or REPLACE PROCEDURE workflow_CurOpe_UbyForwardNB 
(requestid_1 integer,userid_1 integer,usertype_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set isremark=2,operatedate=currentdate,operatetime=currenttime, needwfback='0'
where requestid =requestid_1 and userid =userid_1 and usertype=usertype_1 and (isremark=1 or isremark=8 or isremark=9);

end;
/




