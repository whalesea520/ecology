alter table workflow_requestbase add currentstatus int
GO
alter table workflow_requestbase add laststatus VARCHAR(60)
GO
alter table workflow_currentoperator add lastisremark CHAR(1)
GO

CREATE TABLE workflow_otheroperator
(
  ID int IDENTITY (1, 1) primary key NOT NULL,
  REQUESTID int NOT NULL,
  USERID int,
  USERTYPE int,
  NODEID int,
  ISREMARK CHAR(1),
  WORKFLOWID int,
  SHOWORDER int,
  RECEIVEDATE CHAR(10),
  RECEIVETIME CHAR(8),
  VIEWTYPE int,
  OPERATEDATE CHAR(10),
  OPERATETIME CHAR(8)
)
GO
create index workflow_otheroperator_ridx on workflow_otheroperator(requestid)
GO
