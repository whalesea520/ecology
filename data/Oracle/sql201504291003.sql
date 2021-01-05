create table workflow_monitor_info
(
  id           INTEGER not null,
  monitortype  INTEGER not null,
  flowcount    INTEGER,
  operatordate CHAR(10) not null,
  operatortime CHAR(8) not null,
  jktype       INTEGER,
  jkvalue      VARCHAR2(4000),
  operator     INTEGER not null,
  subcompanyid INTEGER,
  fwtype       INTEGER,
  fwvalue      VARCHAR2(4000)
)
/
alter table workflow_monitor_info add constraint workflow_monitor_info_pk primary key (ID)
/
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
  issooperator    CHAR(1)
)
/
create sequence monitor_infoid minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/