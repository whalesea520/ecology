alter table sap_inParameter add showname varchar(200)
GO
alter table sap_inParameter add oadesc varchar(200)
GO
alter table sap_inParameter add isshow int
GO 
alter table sap_inParameter add isrdonly int
GO
alter table sap_inParameter add orderfield float
GO
alter table sap_instructure add oadesc varchar(200)
GO
alter table sap_instructure add showname varchar(200)
GO
alter table sap_instructure add isshow int
GO
alter table sap_instructure add isrdonly int
GO
alter table sap_instructure add orderfield float
GO
alter table sap_outParameter add oadesc varchar(200)
GO
alter table sap_outstructure add oadesc varchar(200)
GO
alter table sap_outTable add oadesc varchar(200)
GO
alter table sap_outTable add orderfield float
GO
alter table sap_inTable add oadesc varchar(200)
GO
alter table sap_inTable add showname varchar(200)
GO
alter table sap_outparaprocess add oadesc varchar(200)
GO
alter table sap_outparaprocess add showname varchar(200)
GO
alter table int_BrowserbaseInfo add parurl varchar(4000)
GO
alter table int_BrowserbaseInfo add browsertype int
GO
update  int_BrowserbaseInfo set browsertype=226
GO
alter table workflow_NodeFormGroup add  isopensapmul char(1)
GO
update workflow_NodeFormGroup set isopensapmul=0
GO
alter table int_BrowserbaseInfo add isbill int
GO
update int_BrowserbaseInfo set isbill=1
GO
alter table int_BrowserbaseInfo add isdelete int
GO
update  int_BrowserbaseInfo set isdelete=0
GO
CREATE TABLE sap_multiBrowser
(
       id int primary key not null identity(1,1), 
       mxformname  varchar(200),
       mxformid   int,
       isbill        int,
       browsermark   varchar(200)           
)
GO
CREATE TABLE int_saplogsql
(
       id int primary key not null identity(1,1), 
       BASEID  int,
       LOGSQL   VARCHAR(2000),
       RESULT        VARCHAR(10),
       LOGTYPE   int         
)
GO
CREATE TABLE sap_jarsys
(
       id int primary key not null identity(1,1), 
       jarurl  varchar(200),
       jardesc varchar(200),
       jarname varchar(200)   
)
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002239.zip','AIX 32bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002240.zip','TRU64 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002243.zip','Windows Server on IA32 32bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002244.zip','z/OS 32bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002245.zip','Linux on zSeries 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002247.zip','Solaris on SPARC 32bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002882.zip','AIX 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002883.zip','HP-UX on IA64 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002884.zip','HP-UX on PA-RISC 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002885.zip','Linux on IA-64 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002886.zip','OS/400','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002887.zip','Solaris on SPARC 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-10002888.zip','Windows Server on IA64 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20001730.zip','Windows Server on x64 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20001731.zip','Solaris on x64_64 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007300.zip','Linux on x86_64 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007301.zip','Linux on IA32 32bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007302.zip','Linux on Power 64bit','')
GO
insert into sap_jarsys (jarurl,jarname,jardesc) values('/integration/sapjar/sapjco21P_10-20007303.zip','HP-UX on PA-RISC 32bit','')
GO
drop proc int_BrowserbaseInfo_insert
GO
create proc int_BrowserbaseInfo_insert
(       
	@mark_1    varchar(50),
	@hpid_2   int,
	@poolid_3     int,
	@regservice_4 varchar(50),
	@brodesc_5	varchar(50),
	@authcontorl_6 	varchar(50),
        @w_fid_7 int,
	@w_nodeid_8 int,
	@w_actionorder_9  int,
	@w_enable_10       int,
	@w_type_11     int,
	@ispreoperator_12  int,
	@nodelinkid_13    int,
	@browsertype_14    int,
	@isbill_15   int,
	@url_16   varchar(200),
	@flag 		int 	output ,
	@msg 		varchar(80) 	output 
)
as    
    declare  @maxid_ varchar(50); 
begin
	/*插入数据*/
	insert into int_BrowserbaseInfo (mark,hpid,poolid,regservice,brodesc,authcontorl,w_fid,w_nodeid,w_actionorder,w_enable,w_type,ispreoperator,nodelinkid,browsertype,isbill,parurl,isdelete)
	values (@mark_1,@hpid_2,@poolid_3,@regservice_4,@brodesc_5,@authcontorl_6,@w_fid_7,@w_nodeid_8,@w_actionorder_9,@w_enable_10,@w_type_11,@ispreoperator_12,@nodelinkid_13,@browsertype_14,@isbill_15,@url_16,0);
	/*查出最大值*/
	select @maxid_=MAX(id)  from int_BrowserbaseInfo;      
	select @maxid_                      
end;  
GO

CREATE TABLE sap_thread
(
       id int primary key not null identity(1,1), 
       name varchar(200),
       wfid integer,
       sapread  varchar(200),
       sapwrite  varchar(200),
       wfcreateid int,
       wftitle   varchar(200),
       wftitleAdd   varchar(200),
       wflevel   int,
       isopen    int,
       ScanInterval int,
       wfmark    varchar(200),
       isbill  int
)
GO
