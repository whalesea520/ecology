alter table workflow_requestbase add currentstatus int
/
alter table workflow_requestbase add laststatus VARCHAR2(60)
/
alter table workflow_currentoperator add lastisremark CHAR(1)
/

CREATE TABLE workflow_otheroperator
(
  ID NUMBER(*,0) primary key NOT NULL ENABLE,
  REQUESTID NUMBER(*,0) NOT NULL ENABLE,
  USERID NUMBER(*,0),
  USERTYPE NUMBER(*,0),
  NODEID NUMBER(*,0),
  ISREMARK CHAR(1),
  WORKFLOWID NUMBER(*,0),
  SHOWORDER NUMBER(*,0),
  RECEIVEDATE CHAR(10),
  RECEIVETIME CHAR(8),
  VIEWTYPE NUMBER(*,0),
  OPERATEDATE CHAR(10),
  OPERATETIME CHAR(8)
)
/
CREATE SEQUENCE workflow_otheroperator_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create index workflow_otheroperator_ridx on workflow_otheroperator(requestid)
/

create or replace trigger workflow_otheroperator_Tri
  before insert on workflow_otheroperator
  for each row
begin
  select workflow_otheroperator_seq.nextval into :new.id from dual;
end;
/