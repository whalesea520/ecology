create table wfec_outdatawfset
(
  id                INTEGER,
 name        varchar2(1000), 
 workflowid        INTEGER,
 subcompanyid integer,
  outermaintable    VARCHAR2(30),
  outermainwhere    VARCHAR2(500),
  successback       VARCHAR2(500),
  failback          VARCHAR2(500),
  outerdetailtables VARCHAR2(2000),
  outerdetailwheres VARCHAR2(2000),
  datasourceid      VARCHAR2(30),
  datarecordtype    CHAR(1),
  keyfield          VARCHAR2(100),
  requestid         VARCHAR2(100),
  ftriggerflag      VARCHAR2(100),
  ftriggerflagvalue VARCHAR2(100),
  typename          CHAR(1),
  periodvalue       INTEGER,
  status            INTEGER
)
/
CREATE SEQUENCE wfec_odws_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/


create table wfec_outdatawfdetail
(
  mainid        INTEGER,
  workflowid    INTEGER,
  requestid     INTEGER,
  keyfieldvalue VARCHAR2(1000),
  ftriggerflag  CHAR(1),
  dataid  integer
)
/


create table wfec_outdatasetdetail
(
  id              INTEGER,
  mainid          INTEGER,
  wffieldid       INTEGER,
  wffieldname     VARCHAR2(30),
  wffieldhtmltype INTEGER,
  wffieldtype     INTEGER,
  wffielddbtype   VARCHAR2(50),
  outerfieldname  VARCHAR2(50),
  changetype      INTEGER,
  iswriteback     CHAR(1),
  customsql       VARCHAR2(2000),
 customtxt       VARCHAR2(2000)
)
/
CREATE SEQUENCE wfec_odsetdetail_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/


create table wfec_tablelist
(
  id              INTEGER,
  tablename          varchar2(1000),
  isdetail       INTEGER,
  mainid integer,
  changetype integer,
  rid integer
)
/
CREATE SEQUENCE wfec_tablelist_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/


create table wfec_tablefield
(
  id              INTEGER,
  dbname        varchar2(1000),
  type       INTEGER,
  dbtype varchar2(1000),
  tableid integer,
  isdefault integer,
  isModified integer,
  showorder integer
)
/
CREATE SEQUENCE wfec_tablefield_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/


create table wfec_indatawfset
(
  id              INTEGER,
  name          varchar2(1000),
  workflowid       INTEGER,
   subcompanyid integer,
   datasourceid      VARCHAR2(30),
   outermaintable    VARCHAR2(30),
   outerdetailtables VARCHAR2(2000),
   periodvalue       INTEGER,
   iscallback   integer,
   status integer
)
/
CREATE SEQUENCE wfec_indatawfset_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/



create table wfec_indatasetdetail
(
  id              INTEGER,
  mainid          INTEGER,
  wffieldid       INTEGER,
  wffieldname     VARCHAR2(30),
  wffieldhtmltype INTEGER,
  wffieldtype     INTEGER,
  wffielddbtype   VARCHAR2(50),
  outerfieldname  VARCHAR2(50),
  changetype      INTEGER,
  customsql       VARCHAR2(2000),
  customtxt       VARCHAR2(2000)
)
/
CREATE SEQUENCE wfec_idsetdetail_sequence
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
NOCACHE
/



create table wfec_indatadetail
(
  mainid        INTEGER,
  workflowid    INTEGER,
  requestid     INTEGER,
  dataid  integer
)
/


create view wfex_view
as 
select id,name,workflowid,datasourceid,subcompanyid, 0 as type,status from wfec_outdatawfset
union all
select id,name ,workflowid,datasourceid,subcompanyid,1 as type,status from wfec_indatawfset
/

insert into actionsetting (actionname,actionclass,actionshowname)  values('ExchangeApprovalDisagree','weaver.interfaces.workflow.action.ExchangeApprovalDisagree','流程交换审批不通过回写')
/
insert into actionsetting (actionname,actionclass,actionshowname)  values('ExchangeApprovalAgree','weaver.interfaces.workflow.action.ExchangeApprovalAgree','流程数据审批通过回写')
/
insert into actionsetting (actionname,actionclass,actionshowname)  values('ExchangeSetValueAction','weaver.interfaces.workflow.action.ExchangeSetValueAction','流程交换数据赋值')
/