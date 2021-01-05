alter table sap_inParameter add showname varchar2(200)
/
alter table sap_inParameter add oadesc varchar2(200)
/
alter table sap_inParameter add isshow integer
/ 
alter table sap_inParameter add isrdonly integer
/
alter table sap_inParameter add orderfield number
/
alter table sap_instructure add oadesc varchar2(200)
/
alter table sap_instructure add showname varchar2(200)
/
alter table sap_instructure add isshow integer
/
alter table sap_instructure add isrdonly integer
/
alter table sap_instructure add orderfield number
/
alter table sap_outParameter add oadesc varchar2(200)
/
alter table sap_outstructure add oadesc varchar2(200)
/
alter table sap_outTable add oadesc varchar2(200)
/
alter table sap_outTable add orderfield number
/
alter table sap_inTable add oadesc varchar2(200)
/
alter table sap_inTable add showname varchar2(200)
/
alter table sap_outparaprocess add oadesc varchar2(200)
/
alter table sap_outparaprocess add showname varchar2(200)
/
alter table int_BrowserbaseInfo add parurl varchar2(4000)
/
alter table int_BrowserbaseInfo add browsertype integer
/
update  int_BrowserbaseInfo set browsertype=226
/
alter table workflow_NodeFormGroup add  isopensapmul char(1)
/
update workflow_NodeFormGroup set isopensapmul=0
/
alter table int_BrowserbaseInfo add isbill integer
/
update int_BrowserbaseInfo set isbill=1
/
alter table int_BrowserbaseInfo add isdelete integer
/
update  int_BrowserbaseInfo set isdelete=0
/
CREATE TABLE sap_multiBrowser
(
       ID INTEGER PRIMARY KEY NOT NULL,
       mxformname  varchar2(200),
       mxformid   int,
       isbill        int,
       browsermark   varchar2(200)           
)
/
create sequence sq_sap_multiBrowser
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_multiBrowser
before insert on sap_multiBrowser
for each row
begin
select sq_sap_multiBrowser.nextval into :new.id from dual;
end;
/
CREATE TABLE int_saplogsql
(
       ID INTEGER PRIMARY KEY NOT NULL,
       BASEID  INTEGER,
       LOGSQL   VARCHAR2(2000),
       RESULT        VARCHAR2(10),
       LOGTYPE   INTEGER         
)
/
create sequence sq_int_saplogsql
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_int_saplogsql
before insert on int_saplogsql
for each row
begin
select sq_int_saplogsql.nextval into :new.id from dual;
end;
/
CREATE TABLE sap_jarsys
(
       ID INTEGER PRIMARY KEY NOT NULL,
       jarurl  varchar2(200),
       jardesc   varchar2(200),
       jarname        varchar2(200)   
)
/
create sequence sq_sap_jarsys
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_jarsys
before insert on sap_jarsys
for each row
begin
select sq_sap_jarsys.nextval into :new.id from dual;
end;
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002239.zip','AIX 32bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002240.zip','TRU64 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002243.zip','Windows Server on IA32 32bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002244.zip','z/OS 32bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002245.zip','Linux on zSeries 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002247.zip','Solaris on SPARC 32bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002882.zip','AIX 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002883.zip','HP-UX on IA64 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002884.zip','HP-UX on PA-RISC 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002885.zip','Linux on IA-64 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002886.zip','OS/400','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002887.zip','Solaris on SPARC 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002888.zip','Windows Server on IA64 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20001730.zip','Windows Server on x64 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20001731.zip','Solaris on x64_64 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007300.zip','Linux on x86_64 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007301.zip','Linux on IA32 32bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007302.zip','Linux on Power 64bit','')
/
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007303.zip','HP-UX on PA-RISC 32bit','')
/
create or replace procedure int_BrowserbaseInfo_insert
(
  mark_1         varchar2,
  hpid_2   integer,
  poolid_3     integer,
  regservice_4 varchar2,
  brodesc_5  varchar2,
  authcontorl_6   varchar2,
  w_fid_7 integer,
  w_nodeid_8 integer,
  w_actionorder_9  integer,
  w_enable_10       integer,
  w_type_11     integer,
  ispreoperator_12  integer,
  nodelinkid_13    integer,
  browsertype_14    integer,
  isbill_15   integer,
  url_16   varchar2,
  flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor
)
as
      maxid_ varchar2(50);
begin
  
  insert into int_BrowserbaseInfo (mark,hpid,poolid,regservice,brodesc,authcontorl,w_fid,w_nodeid,w_actionorder,w_enable,w_type,ispreoperator,nodelinkid,browsertype,isbill,parurl,isdelete)
  values (mark_1,hpid_2,poolid_3,regservice_4,brodesc_5,authcontorl_6,w_fid_7,w_nodeid_8,w_actionorder_9,w_enable_10,w_type_11,ispreoperator_12,nodelinkid_13,browsertype_14,isbill_15,url_16,0);
 
  select MAX(id) into maxid_  from int_BrowserbaseInfo;
	open thecursor for  select maxid_  from dual;
end;
/

CREATE TABLE sap_thread
(
       ID INTEGER PRIMARY KEY NOT NULL,
       name varchar2(200),
       wfid integer,
       sapread  varchar2(200),
       sapwrite  varchar2(200),
       wfcreateid integer,
       wftitle   varchar2(200),
       wftitleAdd   varchar2(200),
       wflevel   integer,
       isopen    integer,
       ScanInterval integer,
       wfmark    varchar2(200),
       isbill  integer
)
/
create sequence sq_sap_thread
start with 1
increment by 1
nomaxvalue
nocycle
/
create or  replace trigger tr_sap_thread
before insert on sap_thread
for each row
begin
select sq_sap_thread.nextval into :new.id from dual;
end;
/