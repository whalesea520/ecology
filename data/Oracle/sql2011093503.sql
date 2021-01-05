create table Workflow_MonitorType
(
       id integer primary key not null,
       typename varchar2(200),
       typedesc varchar2(600),
       typeorder integer default 0
)
/
CREATE SEQUENCE Workflow_MonitorType_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger Workflow_MonitorType_Tri
  before insert on Workflow_MonitorType
  for each row
begin
  select Workflow_MonitorType_seq.nextval into :new.id from dual;
end;
/
alter table workflow_monitor_bound add monitortype integer
/
alter table workflow_monitor_bound add subcompanyid integer
/
alter table Workflow_Custom add subCompanyId Integer
/
alter table Workflow_Report add subCompanyId Integer
/
create table dmlactionset
(
       id integer primary key not null,
       dmlactionname varchar2(200) not null,
       dmlorder int,
       workflowId int,
       nodeid int,
       ispreoperator char(1),
       nodelinkid int,
       datasourceid varchar2(200),
       dmltype varchar(10)
)
/
CREATE SEQUENCE dmlactionset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger dmlactionset_Tri
  before insert on dmlactionset
  for each row
begin
  select dmlactionset_seq.nextval into :new.id from dual;
end;
/
create table dmlactionsqlset
(
       id integer primary key not null,
       actionid integer,
       actiontable varchar2(200),
       dmlformid int,
       dmlformname varchar2(200),
       dmlisdetail int,
       dmltablename varchar2(100),
       dmltablebyname varchar2(100),
       dmlsql varchar2(4000),
       dmlfieldtypes varchar2(4000),
       dmlfieldnames varchar2(4000),
       dmlothersql varchar2(4000),
       dmlotherfieldtypes varchar2(4000),
       dmlotherfieldnames varchar2(4000),
       dmlcuswhere varchar2(4000),
       dmlmainsqltype int,
       dmlcussql varchar2(4000)
)
/
CREATE SEQUENCE dmlactionsqlset_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger dmlactionsqlset_Tri
  before insert on dmlactionsqlset
  for each row
begin
  select dmlactionsqlset_seq.nextval into :new.id from dual;
end;
/
create table dmlactionfieldmap
(
       id integer primary key not null,
       actionsqlsetid integer,
       maptype char(1),
       fieldname varchar2(200),
       fieldvalue varchar2(200),
       fieldtype varchar2(200)
)
/
CREATE SEQUENCE dmlactionfieldmap_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger dmlactionfieldmap_Tri
  before insert on dmlactionfieldmap
  for each row
begin
  select dmlactionfieldmap_seq.nextval into :new.id from dual;
end;
/


update MainMenuInfo m set m.defaultparentid=1020,m.defaultlevel=2,m.defaultindex=1,m.parentid=1020,m.linkaddress='/workflow/monitor/managemonitor.jsp' where id=421
/
update MainMenuInfo m set m.defaultparentid=1020,m.defaultlevel=2,m.defaultindex=2,m.parentid=1020 where id=125
/
update SystemRights t set t.detachable=1 where t.id=771
/
update MainMenuInfo set linkaddress='/workflow/workflow/CustomQuery_frm.jsp' where id=632
/
update SystemRights t set t.detachable=1 where t.id=719
/
update MainMenuInfo  set parentid=1030 ,defaultindex=1 ,defaultlevel=2 where id=122
/
update MainMenuInfo  set parentid=1030 ,defaultindex=2 ,defaultlevel=2,linkaddress='/workflow/report/Report_frm.jsp' where id=123
/
update systemrights set detachable = 1 where id=300
/

CREATE OR REPLACE PROCEDURE Workflow_MonitorType_UPDATE(id_1        integer,
                                                         typename_2  varchar2,
                                                         typedesc_3  varchar2,
                                                         typeorder_4 integer,
                                                         flag        out integer,
                                                         msg         out varchar2,
                                                         thecursor   IN OUT cursor_define.weavercursor) AS
begin
  UPDATE Workflow_MonitorType
     SET typename  = typename_2,
         typedesc  = typedesc_3,
         typeorder = typeorder_4
   WHERE (id = id_1);
end;
/

CREATE OR REPLACE PROCEDURE Workflow_MonitorType_DELETE(id_1      integer,
                                                         flag      out integer,
                                                         msg       out varchar2,
                                                         thecursor IN OUT cursor_define.weavercursor) AS
  count1 integer;
begin
  select count(1)
    INTO count1
    from workflow_monitor_bound
   where monitortype = id_1;
  if count1 <> 0 then
    open thecursor for
      select 0 from dual;
  else
    DELETE from Workflow_MonitorType WHERE (id = id_1);
  end if;
end;
/

CREATE OR REPLACE PROCEDURE Workflow_MonitorType_INSERT(typename_1  varchar2,
                                                         typedesc_2  varchar2,
                                                         typeorder_3 integer,
                                                         flag        out integer,
                                                         msg         out varchar2,
                                                         thecursor   IN OUT cursor_define.weavercursor) AS
begin
  INSERT INTO Workflow_MonitorType
    (typename, typedesc, typeorder)
  VALUES
    (typename_1, typedesc_2, typeorder_3);
end;
/