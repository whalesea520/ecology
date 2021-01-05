alter table cus_formdict add fieldname varchar(30) null
GO
alter table cus_formdict add fieldlabel varchar(200) null
GO
alter table cus_formdict add scope varchar(200) null
GO
ALTER TABLE cus_formfield
ADD isuse CHAR(1)
GO
update cus_formdict set fieldname='field'+convert(varchar,id) where fieldname is null
GO
update cus_formfield set  isuse='1' where scope='ProjCustomField' and isuse is null
GO
alter table cus_formfield add doc_fieldlabel int null
GO
alter table cus_selectitem add doc_isdefault int null default 0
GO
alter table cus_selectitem add cancel int null default 0
GO
alter table DocSecCategoryDocProperty add customNameEng varchar(200) null
GO
alter table DocSecCategoryDocProperty add customNameTran varchar(200) null
GO
alter table DocSecCategory add isuser int null
GO
alter table DocSecCategory add e8number varchar(100) null
GO
alter table workflow_base add isWorkflowDoc int null default 0
GO
alter table workflow_base add officalType int null
GO
update workflow_base set isWorkflowDoc=1 where id in (select workflowid from workflow_createdoc where status=1 and flowDocField>-1)
GO
alter table DocMould add lastModTime varchar(32) null
GO
alter table DocMailMould add lastModTime varchar(32) null
GO
alter table DocMouldfile add lastModTime varchar(32) null
GO
alter table DocMould add subcompanyid int null
GO
alter table DocFrontpage add subcompanyid int null
GO
alter table DocMouldfile add subcompanyid int null
GO
alter table  DocSecCategoryTemplate add subcompanyid int null
GO
alter table  DocMailMould add subcompanyid int null
GO
alter table  WebMagazineType add subcompanyid int null
GO
alter table   DocMainCategory add subcompanyid int null
GO
CREATE TABLE workflow_process_relative(
	id int IDENTITY(1,1) NOT NULL,
	workflowid int not null,
	nodeids varchar(100) NULL,
	officaltype int NULL,
	pdid int NOT NULL
)
GO
CREATE TABLE workflow_processdefine(
	id int IDENTITY(1,1) NOT NULL,
	sysid int null,
	label varchar(100) NULL,
	status int NULL,
	sortorder decimal(15,2) NULL,
	linktype int NOT NULL,
	shownamelabel int null,
	isSys int not null 
)
GO
CREATE TABLE workflow_processinst(
	id int IDENTITY(1,1) NOT NULL,
	pd_id int null,
	phraseDesc varchar(200) NULL,
	phraseShort varchar(100) NULL,
	sortorder decimal(15,2) NULL,
	isdefault int not null 
)
GO
CREATE PROCEDURE DocFrontpage_Insert_New(@frontpagename_1 	varchar(200), @frontpagedesc_2 	varchar(200), @isactive_3 	char(1), @departmentid_4 	int, @linktype_5 	varchar(2), @hasdocsubject_6 	char(1), @hasfrontpagelist_7 	char(1), @newsperpage_8 	tinyint, @titlesperpage_9 	tinyint, @defnewspicid_10 	int, @backgroundpicid_11 	int, @importdocid_12 	varchar(200), @headerdocid_13 	int, @footerdocid_14 	int, @secopt_15 	varchar(2), @seclevelopt_16 	tinyint, @departmentopt_17 	int, @dateopt_18 	int, @languageopt_19 	int, @clauseopt_20 	text, @newsclause_21 	text, @languageid_22 	int, @publishtype_23 	int , @newstypeid_24 	int , @typeordernum_25 int, @subcompanyid_26 int, @flag	int	output, @msg	varchar(80)	output) AS INSERT INTO DocFrontpage ( frontpagename, frontpagedesc, isactive, departmentid, linktype, hasdocsubject, hasfrontpagelist, newsperpage, titlesperpage, defnewspicid, backgroundpicid, importdocid, headerdocid, footerdocid, secopt, seclevelopt, departmentopt, dateopt, languageopt, clauseopt, newsclause, languageid, publishtype, newstypeid, typeordernum,subcompanyid) VALUES ( @frontpagename_1, @frontpagedesc_2, @isactive_3, @departmentid_4, @linktype_5, @hasdocsubject_6, @hasfrontpagelist_7, @newsperpage_8, @titlesperpage_9, @defnewspicid_10, @backgroundpicid_11, @importdocid_12, @headerdocid_13, @footerdocid_14, @secopt_15, @seclevelopt_16, @departmentopt_17, @dateopt_18, @languageopt_19, @clauseopt_20, @newsclause_21, @languageid_22, @publishtype_23, @newstypeid_24,@typeordernum_25,@subcompanyid_26) select max(id) from DocFrontpage 
GO
CREATE PROCEDURE DocFrontpage_Update_New(@id_1 	int, @frontpagename_2 	varchar(200), @frontpagedesc_3 	varchar(200), @isactive_4 	char(1), @departmentid_5 	int, @hasdocsubject_7 	char(1), @hasfrontpagelist_8 	char(1), @newsperpage_9 	tinyint, @titlesperpage_10 	tinyint, @defnewspicid_11 	int, @backgroundpicid_12 	int, @importdocid_13 	varchar(200), @headerdocid_14 	int, @footerdocid_15 	int, @secopt_16 	varchar(2), @seclevelopt_17 	tinyint, @departmentopt_18 	int, @dateopt_19 	int, @languageopt_20 	int, @clauseopt_21 	text, @newsclause_22 	text, @languageid_23 	int, @publishtype_24 	int , @newstypeid_25  int, @typeordernum_26  int, @checkOutStatus_27  int, @checkOutUserId_28  int, @subcompanyid_29 int, @flag	int	output, @msg	varchar(80)	output) AS UPDATE DocFrontpage  SET  frontpagename	 = @frontpagename_2, frontpagedesc	 = @frontpagedesc_3, isactive	 = @isactive_4, departmentid	 = @departmentid_5, hasdocsubject	 = @hasdocsubject_7, hasfrontpagelist	 = @hasfrontpagelist_8, newsperpage	 = @newsperpage_9, titlesperpage	 = @titlesperpage_10, defnewspicid	 = @defnewspicid_11, backgroundpicid	 = @backgroundpicid_12, importdocid	 = @importdocid_13, headerdocid	 = @headerdocid_14, footerdocid	 = @footerdocid_15, secopt	 = @secopt_16, seclevelopt	 = @seclevelopt_17, departmentopt	 = @departmentopt_18, dateopt	 = @dateopt_19, languageopt	 = @languageopt_20, clauseopt	 = @clauseopt_21, newsclause	 = @newsclause_22, languageid	 = @languageid_23, publishtype	 = @publishtype_24, newstypeid=@newstypeid_25, typeordernum=@typeordernum_26, checkOutStatus=@checkOutStatus_27, checkOutUserId=@checkOutUserId_28,subcompanyid=@subcompanyid_29  WHERE ( id = @id_1) 
GO
CREATE TABLE ecology_pagesize(
	id int IDENTITY(1,1) NOT NULL,
	pageid varchar(200) not NULL,
	pagesize int  NOT NULL,
	userid int not null
) 
GO


CREATE TABLE MouldBookMarkEdit (
  id int IDENTITY(1,1) NOT NULL ,
  mouldId int NULL ,
  name   varchar(100) NULL,
  descript   varchar(200) NULL,
  showOrder decimal(6,2)   NULL
)
GO
CREATE TABLE WorkFlow_DocShowEdit (
  id int IDENTITY(1,1) NOT NULL ,
  flowId int NULL ,
  selectItemId int NULL ,
  secCategoryID  varchar(500) NULL,
  modulId int NULL ,
  fieldId int NULL,
  docMouldID int NULL,
  isDefault char(1) NULL,
  dateShowType char(1) NULL
)
GO
ALTER TABLE DocDetail ADD editMouldId int null
GO
delete from workflow_processdefine where sysid=1
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('拟稿',1,1,'1.0',1,0,1);

GO
delete from workflow_processdefine where sysid=2
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('核稿',2,1,'2.0',1,0,1);
	
GO
delete from workflow_processdefine where sysid=3
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('会签',3,1,'3.0',1,0,1);
	
GO
delete from workflow_processdefine where sysid=4
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('签发',4,1,'4.0',1,0,1);
	
GO
delete from workflow_processdefine where sysid=5
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('套红',5,1,'5.0',1,0,1);
	
GO
delete from workflow_processdefine where sysid=6
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('签章',6,1,'6.0',1,0,1);
	
GO
delete from workflow_processdefine where sysid=7
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('打印',7,1,'7.0',1,0,1);
	
GO
delete from workflow_processdefine where sysid=8
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('分发',8,1,'8.0',1,0,1);
	
GO
delete from workflow_processdefine where sysid=9
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('查收',9,1,'9.0',1,0,1);
delete from workflow_processdefine where sysid=10
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('拟稿',10,1,'1.0',3,0,1);

GO

delete from workflow_processdefine where sysid=11
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('核稿',11,1,'2.0',3,0,1);
	
GO
delete from workflow_processdefine where sysid=12
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('会签',12,1,'3.0',3,0,1);
	
GO
delete from workflow_processdefine where sysid=13
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('签发',13,1,'4.0',3,0,1);
	
GO
delete from workflow_processdefine where sysid=14
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('确认',14,1,'5.0',3,0,1);
	
GO
delete from workflow_processdefine where sysid=15
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('通知',15,1,'6.0',3,0,1);
	
GO
delete from workflow_processdefine where sysid=16
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('登记',16,1,'1.0',2,0,1);

GO
delete from workflow_processdefine where sysid=17
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('拟办',17,1,'2.0',2,0,1);
	
GO
delete from workflow_processdefine where sysid=18
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('审核',18,1,'3.0',2,0,1);
	
GO
delete from workflow_processdefine where sysid=19
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('批示',19,1,'4.0',2,0,1);
	
GO
delete from workflow_processdefine where sysid=20
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('办理',20,1,'5.0',2,0,1);
	
GO
delete from workflow_processdefine where sysid=21
GO
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('传阅',21,1,'6.0',2,0,1);
GO

CREATE TABLE [system_default_col](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[isdefault] [varchar](1) NOT NULL,
	[pageid] [varchar](200) NULL,
	[align] [varchar](10) NULL,
	[name] [varchar](32) NULL,
	[_column] [varchar](32) NULL,
	[orderkey] [varchar](200) NULL,
	[linkvaluecolumn] [varchar](32) NULL,
	[linkkey] [varchar](32) NULL,
	[href] [varchar](200) NULL,
	[target] [varchar](32) NULL,
	[transmethod] [varchar](100) NULL,
	[otherpara] [varchar](2000) NULL,
	[orders] [int] NULL,
	[width] [varchar](30) NULL,
	[_text] [varchar](400) NULL,
	[labelid] [varchar](50) NULL
) 
GO
ALTER TABLE [system_default_col] ADD  CONSTRAINT [DF_system_default_col_isdefault]  DEFAULT ((0)) FOR [isdefault]
GO
ALTER TABLE [system_default_col] ADD  CONSTRAINT [DF_system_default_col_align]  DEFAULT ('left') FOR [align]
GO
ALTER TABLE [system_default_col] ADD  CONSTRAINT [DF_system_default_col_target]  DEFAULT ('_self') FOR [target]
GO
ALTER TABLE [system_default_col] ADD  CONSTRAINT [DF_system_default_col_orders]  DEFAULT ((0)) FOR [orders]
GO

CREATE TABLE [table_col_base](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tablename] [varchar](200) NULL,
	[colName] [varchar](200) NOT NULL,
	[labelId] [int] NULL,
	[fieldid] [int] NULL
) 
GO
CREATE TABLE [user_default_col](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[systemid] [int] NOT NULL,
	[col_base_id] [int] NULL,
	[pageid] [varchar](200) NOT NULL,
	[userid] [int] NOT NULL,
	[orders] [int] NULL
) 
GO
CREATE TABLE [workflow_interfaces](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](200) NOT NULL,
	[deploy_status] [varchar](1) NULL,
	[memo] [varchar](200) NULL,
	[closed] [varchar](1) NULL,
) 
GO
ALTER TABLE [workflow_interfaces] ADD  DEFAULT ((0)) FOR [deploy_status]
GO
ALTER TABLE [workflow_interfaces] ADD  DEFAULT ((0)) FOR [closed]
GO
CREATE TABLE workflow_mould(
  ID integer IDENTITY(1,1) NOT NULL,
  workflowid integer not null,
  mouldid integer not null,
  mouldType integer null,
  visible integer null,
  seccategory integer null
)
GO
ALTER TABLE [workflow_mould] ADD  CONSTRAINT [DF_workflow_mould_visible]  DEFAULT ((1)) FOR [visible]
GO

