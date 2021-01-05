create table wfec_outdatawfset
(
  id                INTEGER PRIMARY KEY IDENTITY(1,1),
 name        varchar(1000), 
 workflowid        INTEGER,
 subcompanyid integer,
  outermaintable    varchar(30),
  outermainwhere    varchar(500),
  successback       varchar(500),
  failback          varchar(500),
  outerdetailtables varchar(2000),
  outerdetailwheres varchar(2000),
  datasourceid      varchar(30),
  datarecordtype    CHAR(1),
  keyfield          varchar(100),
  requestid         varchar(100),
  ftriggerflag      varchar(100),
  ftriggerflagvalue varchar(100),
  typename          CHAR(1),
  periodvalue       INTEGER,
  status            INTEGER
)
GO


create table wfec_outdatawfdetail
(
  mainid        INTEGER,
  workflowid    INTEGER,
  requestid     INTEGER,
  keyfieldvalue varchar(1000),
  ftriggerflag  CHAR(1),
  dataid  integer
)
GO


create table wfec_outdatasetdetail
(
  id              INTEGER PRIMARY KEY IDENTITY(1,1),
  mainid          INTEGER,
  wffieldid       INTEGER,
  wffieldname     varchar(30),
  wffieldhtmltype INTEGER,
  wffieldtype     INTEGER,
  wffielddbtype   varchar(50),
  outerfieldname  varchar(50),
  changetype      INTEGER,
  iswriteback     CHAR(1),
  customsql       varchar(2000),
 customtxt       varchar(2000)
)
GO


create table wfec_tablelist
(
  id              INTEGER PRIMARY KEY IDENTITY(1,1),
  tablename          varchar(1000),
  isdetail       INTEGER,
  mainid integer,
  changetype integer,
  rid integer
)
GO


create table wfec_tablefield
(
  id              INTEGER PRIMARY KEY IDENTITY(1,1),
  dbname        varchar(1000),
  type       INTEGER,
  dbtype varchar(1000),
  tableid integer,
  isdefault integer,
  isModified integer,
  showorder integer
)
GO


create table wfec_indatawfset
(
  id              INTEGER PRIMARY KEY IDENTITY(1,1) ,
  name          varchar(1000),
  workflowid       INTEGER,
   subcompanyid integer,
   datasourceid      varchar(30),
   outermaintable    varchar(30),
   outerdetailtables varchar(2000),
   periodvalue       INTEGER,
   iscallback   integer,
   status integer
)
GO


create table wfec_indatasetdetail
(
  id              INTEGER PRIMARY KEY IDENTITY(1,1),
  mainid          INTEGER,
  wffieldid       INTEGER,
  wffieldname     varchar(30),
  wffieldhtmltype INTEGER,
  wffieldtype     INTEGER,
  wffielddbtype   varchar(50),
  outerfieldname  varchar(50),
  changetype      INTEGER,
  customsql       varchar(2000),
  customtxt       varchar(2000)
)
GO

create table wfec_indatadetail
(
  mainid        INTEGER,
  workflowid    INTEGER,
  requestid     INTEGER,
  dataid  integer
)
GO


create view wfex_view
as 
select id,name,workflowid,datasourceid,subcompanyid, 0 as type,status from wfec_outdatawfset
union all
select id,name ,workflowid,datasourceid,subcompanyid,1 as type,status from wfec_indatawfset
GO

insert into actionsetting (actionname,actionclass,actionshowname)  values('ExchangeApprovalDisagree','weaver.interfaces.workflow.action.ExchangeApprovalDisagree','流程交换审批不通过回写')
GO
insert into actionsetting (actionname,actionclass,actionshowname)  values('ExchangeApprovalAgree','weaver.interfaces.workflow.action.ExchangeApprovalAgree','流程数据审批通过回写')
GO
insert into actionsetting (actionname,actionclass,actionshowname)  values('ExchangeSetValueAction','weaver.interfaces.workflow.action.ExchangeSetValueAction','流程交换数据赋值')
GO
