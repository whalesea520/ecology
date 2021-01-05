create table workflow_requestbase_dellog as select * from workflow_requestbase where 1 = 2
/
create table workflow_curroperator_dellog as select * from workflow_currentoperator where 1 = 2
/
create table workflow_requestLog_dellog as 
select REQUESTID,WORKFLOWID,NODEID,LOGTYPE,OPERATEDATE,OPERATETIME,OPERATOR,REMARK1,CLIENTIP,OPERATORTYPE,DESTNODEID,
RECEIVEDPERSONS_1,SHOWORDER,AGENTORBYAGENTID,AGENTTYPE,LOGID,ANNEXDOCIDS,REQUESTLOGID,OPERATORDEPT,SIGNDOCIDS,SIGNWORKFLOWIDS,
RECEIVEDPERSONS,ISMOBILE,HANDWRITTENSIGN,SPEECHATTACHMENT,RECEIVEDPERSONIDS,REMARKLOCATION from workflow_requestLog where 1 = 2
/
alter table workflow_requestLog_dellog add (REMARK LONG)
/
create table workflow_nownode_dellog as select * from workflow_nownode where 1 = 2
/
alter table workflow_requestdeletelog add (deletetabledata clob)
/
alter table workflow_requestdeletelog add (isold char(1))
/
update workflow_requestdeletelog set isold = '1'
/
alter table workflow_requestdeletelog modify (CLIENT_ADDRESS varchar2(50))
/