alter table workflow_currentoperator add  groupdetailid integer null
/

alter table workflow_agentpersons add  groupdetailid integer null
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
select to_char(sysdate,'hh24:mm:ss') into receivetime from dual;

if groupid1 is null 
then groupid1 := 0 ; 
end if ;

update workflow_currentoperator set islasttimes=0 where requestid=requestid1 and userid=userid1 and usertype = usertype1;

if workflowtype1 = '' 
then 
select  workflowtype INTO  workflowtype2 from workflow_base where id = workflowid1;
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes,groupdetailid)
values(requestid1,userid1,groupid1, workflowid1,workflowtype2,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,receivedate,receivetime,0,1,groupdetailid_1); 
else
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes,groupdetailid)
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,receivedate,receivetime,0,1,groupdetailid_1); 
end if ;

end;
/
CREATE or REPLACE PROCEDURE workflow_CurOpe_UpdatebySubmit 
(userid_2	integer, requestid_1 integer,groupid_1 integer,flag out integer,msg out varchar2,thecursor IN OUT cursor_define.weavercursor)
AS 
currentdate char(10);
currenttime char(8);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;

update workflow_currentoperator set isremark = '2' 
where requestid =requestid_1 and isremark=0 and groupid =groupid_1;

update workflow_currentoperator set operatedate = currentdate,operatetime = currenttime  
where requestid = requestid_1 and userid = userid_2 and isremark=2 and groupid = groupid_1;
end;
/

INSERT INTO HtmlLabelIndex values(17416,'导出') 
/
INSERT INTO HtmlLabelInfo VALUES(17416,'导出',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17416,'Export',8) 
/