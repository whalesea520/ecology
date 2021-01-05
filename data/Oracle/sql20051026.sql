ALTER TABLE workflow_currentoperator ADD receivedate char(10)
/
ALTER TABLE workflow_currentoperator ADD receivetime char(8)
/
ALTER TABLE workflow_currentoperator ADD viewtype int
/
ALTER TABLE workflow_currentoperator ADD orderdate char(10)
/
ALTER TABLE workflow_currentoperator ADD ordertime char(8)
/
ALTER TABLE workflow_currentoperator ADD iscomplete int
/
ALTER TABLE workflow_currentoperator ADD islasttimes int
/

INSERT INTO HtmlLabelIndex values(17991,'已办事宜') 
/
INSERT INTO HtmlLabelIndex values(17992,'办结事宜') 
/
INSERT INTO HtmlLabelInfo VALUES(17991,'已办事宜',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17991,'handled matters',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17992,'办结事宜',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17992,'complete matters',8) 
/
INSERT INTO HtmlLabelIndex values(17994,'接收日期') 
/
INSERT INTO HtmlLabelInfo VALUES(17994,'接收日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17994,'receive date',8) 
/

update workflow_currentoperator set viewtype=-2
/
update workflow_currentoperator set iscomplete=0 where requestid in(select requestid from workflow_requestbase where currentnodetype<>3)
/
update workflow_currentoperator set iscomplete=1 where requestid in(select requestid from workflow_requestbase where currentnodetype=3)
/
update workflow_currentoperator set islasttimes=1 where isremark=0 or isremark=1 or isremark=4
/
update workflow_currentoperator set islasttimes=0 where isremark=2
/
update workflow_currentoperator set receivedate='2005-10-31',receivetime='01:01:01',orderdate='2005-10-31',ordertime='01:01:01'  
where receivedate is null and receivetime is null
/


CREATE OR REPLACE PROCEDURE workflow_CurrentOperator_I
( requestid1    integer, userid1        integer, groupid1    in out integer,
workflowid1    integer, workflowtype1    integer, usertype1    integer, isremark1    char  ,nodeid  integer,agentorbyagentid  integer,agenttype  char,showorder integer,
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

update workflow_currentoperator set islasttimes=0 where requestid=requestid1 and userid=userid1;

if workflowtype1 = '' 
then 
select  workflowtype INTO  workflowtype2 from workflow_base where id = workflowid1;
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes)
values(requestid1,userid1,groupid1, workflowid1,workflowtype2,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,receivedate,receivetime,0,1); 
else
insert into workflow_currentoperator (requestid,userid,groupid, workflowid,workflowtype,usertype,isremark,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,viewtype,orderdate,ordertime,iscomplete,islasttimes)
values(requestid1,userid1,groupid1, workflowid1,workflowtype1,usertype1,isremark1,nodeid,agentorbyagentid,agenttype,showorder,receivedate,receivetime,0,receivedate,receivetime,0,1); 
end if ;

end;
/