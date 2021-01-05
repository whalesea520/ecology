create table WORKFLOW_MONITOR_INFO
(
  id           INTEGER not null,
  monitortype  INTEGER not null,
  flowcount    INTEGER,
  operatordate CHAR(10) not null,
  operatortime CHAR(8) not null,
  jktype       INTEGER,
  jkvalue      VARCHAR(4000),
  operator     INTEGER not null,
  subcompanyid INTEGER,
  fwtype       INTEGER,
  fwvalue      VARCHAR(4000)
)
GO
alter table workflow_monitor_info add constraint workflow_monitor_info_pk primary key (ID)
GO
create table WORKFLOW_MONITOR_DETAIL
(
  INFOID      INTEGER,
  workflowid      INTEGER,
  operatordate    CHAR(10),
  operatortime    CHAR(8),
  isview          INTEGER default (0),
  isedit          char(1),
  isintervenor    CHAR(1),
  isdelete        CHAR(1),
  isforcedrawback CHAR(1),
  isforceover     CHAR(1),
  operator        INTEGER,
  monitortype     INTEGER,
  subcompanyid    INTEGER,
  issooperator    char(1)
)
GO