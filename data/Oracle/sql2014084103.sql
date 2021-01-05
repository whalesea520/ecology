alter table workflow_flownode add nodeorder int
/
alter table workflow_nodelink add linkorder int
/
alter table workflow_base add fieldNotImport varchar2(4000)
/
create table WORKFLOW_VIEWLOG
(
  ID             VARCHAR2(250) not null,
  P_NODEID       VARCHAR2(250),
  P_OPTERUID     VARCHAR2(250),
  P_DATE         VARCHAR2(250),
  P_ADDIP        VARCHAR2(250),
  P_NUMBER       VARCHAR2(250),
  REQUESTID      VARCHAR2(250),
  P_NODENAME     VARCHAR2(250),
  REQUESTNAME    VARCHAR2(250),
  WORKFLOWTYPE   VARCHAR2(250),
  WORKFLOWTYPEID VARCHAR2(250),
  WORKFLOWID     VARCHAR2(250)
)
/

create sequence WORKFLOW_VIEWLOG_SQE
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

CREATE TABLE Workflow_SetTitle(
  id number NOT NULL,
  xh varchar(250) NULL,
  fieldtype varchar(250) NULL,
  fieldvalue varchar(250) NULL,
  fieldlevle varchar(250) NULL,
  fieldname varchar(350) NULL,
  fieldzx varchar(150) NULL,
  workflowid varchar(200) NULL,
  trrowid varchar(200) NULL,
  txtUserUse varchar(50) NULL,
  showhtml varchar(500) NULL
)
/
create sequence WORKFLOW_SETTITLE_SQE
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20
/


 

