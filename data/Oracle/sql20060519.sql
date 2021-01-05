alter table workflow_currentoperator add wfreminduser varchar2(200)
/

alter table workflow_currentoperator add wfusertypes varchar2(100)
/

INSERT INTO HtmlLabelIndex values(19046,'没有找到操作人，无法特送至本节点！') 
/
INSERT INTO HtmlLabelInfo VALUES(19046,'没有找到操作人，无法特送至本节点！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19046,'no next operator,can not move the node!',8) 
/

alter table workflow_currentoperator add preisremark char(1)
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
insert into workflow_currentoperator 
(requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid,preisremark)
values(requestid1,userid1,groupid1, workflowid1,workflowtype2,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,0,1,groupdetailid_1,@isremark); 
else
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,iscomplete,islasttimes,groupdetailid,,preisremark)
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,0,1,groupdetailid_1,@isremark); 
end if ;

end;
/