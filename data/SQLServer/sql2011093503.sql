create table Workflow_MonitorType
(
       id int IDENTITY (1, 1) NOT NULL ,
       typename varchar(200),
       typedesc varchar(600),
       typeorder integer default 0
)
GO
alter table workflow_monitor_bound add monitortype integer
GO
alter table workflow_monitor_bound add subcompanyid integer
GO
alter table Workflow_Custom add subCompanyId Integer
GO
alter table Workflow_Report add subCompanyId Integer
GO
create table dmlactionset
(
       id int IDENTITY (1, 1) NOT NULL ,
       dmlactionname varchar(200) not null,
       dmlorder int,
       workflowId int,
       nodeid int,
       ispreoperator char(1),
       nodelinkid int,
       datasourceid varchar(200),
       dmltype varchar(10)
)
go
create table dmlactionsqlset
(
       id int IDENTITY (1, 1) NOT NULL ,
       actionid integer,
       actiontable varchar(200),
       dmlformid int,
       dmlformname varchar(200),
       dmlisdetail int,
       dmltablename varchar(100),
       dmltablebyname varchar(100),
       dmlsql varchar(4000),
       dmlfieldtypes varchar(4000),
       dmlfieldnames varchar(4000),
       dmlothersql varchar(4000),
       dmlotherfieldtypes varchar(4000),
       dmlotherfieldnames varchar(4000),
       dmlcuswhere varchar(4000),
       dmlmainsqltype int,
       dmlcussql varchar(4000)
)
go
create table dmlactionfieldmap
(
       id int IDENTITY (1, 1) NOT NULL ,
       actionsqlsetid integer,
       maptype char(1),
       fieldname varchar(200),
       fieldvalue varchar(200),
       fieldtype varchar(200)
)
go

update MainMenuInfo set defaultparentid=1020,defaultlevel=2,defaultindex=1,parentid=1020,linkaddress='/workflow/monitor/managemonitor.jsp' where id=421
GO
update MainMenuInfo set defaultparentid=1020,defaultlevel=2,defaultindex=2,parentid=1020 where id=125
GO

update SystemRights set detachable=1 where id=771
GO
update MainMenuInfo set linkaddress='/workflow/workflow/CustomQuery_frm.jsp' where id=632
GO
update SystemRights set detachable=1 where id=719
GO

update MainMenuInfo  set parentid=1030 ,defaultindex=1 ,defaultlevel=2 where id=122
GO
update MainMenuInfo  set parentid=1030 ,defaultindex=2 ,defaultlevel=2,linkaddress='/workflow/report/Report_frm.jsp' where id=123
GO
update systemrights set detachable = 1 where id=300
GO

CREATE PROCEDURE Workflow_MonitorType_INSERT(@typename_1  varchar(200),
                                                         @typedesc_2  varchar(600),
                                                         @typeorder_3 integer,
                                                         @flag integer output,
	 @msg varchar(80) output) AS
  INSERT INTO Workflow_MonitorType
    (typename, typedesc, typeorder)
  VALUES
    (@typename_1, @typedesc_2, @typeorder_3)
GO

CREATE PROCEDURE Workflow_MonitorType_UPDATE(@id_1        integer,
                                                         @typename_2  varchar(200),
                                                         @typedesc_3  varchar(600),
                                                         @typeorder_4 integer,
                                                         @flag integer output,
	 @msg varchar(80) output) AS
  UPDATE Workflow_MonitorType
     SET typename  = @typename_2,
         typedesc  = @typedesc_3,
         typeorder = @typeorder_4
   WHERE (id = @id_1)
GO

CREATE PROCEDURE Workflow_MonitorType_DELETE(@id_1      integer,
                                                         @flag integer output,
	 @msg varchar(80) output) AS
  Declare @count1 integer
  select @count1=count(1)
    from workflow_monitor_bound
   where monitortype = @id_1;
  if @count1 <> 0
    begin
       select 0
    end
  else
    begin
      DELETE from Workflow_MonitorType WHERE (id = @id_1)
    end
GO