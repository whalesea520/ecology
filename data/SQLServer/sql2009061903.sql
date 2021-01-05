alter table hpelement add styleid varchar(50)
GO

alter table hpelement add height int
GO

alter table hpinfo  alter column styleid  varchar(20)
GO

CREATE TABLE pagetemplate (
	id int IDENTITY (1, 1) NOT NULL,
	templatename varchar(100) NULL ,
	templatedesc varchar(300) NULL ,
	templatetype varchar(20),
	templateusetype varchar (20) NULL ,
	dir varchar (500) NULL,
	zipName varchar (200) NULL 
)
GO


CREATE TABLE menucenter (
	id varchar(20) NOT NULL ,
	menuname varchar(100) NULL ,
	menudesc varchar(300) NULL ,
	menutype varchar(20),
	tblconfigname varchar (100) NULL ,
	tblinfoname varchar (100) NULL 
)
GO
insert menucenter(id,menuname,menudesc,menutype,tblconfigname,tblinfoname) values ('top','系统级菜单一(原系统顶部菜单)','原系统顶部菜单','sys','mainmenuinfo','mainmenuconfig') ;
GO

insert menucenter(id,menuname,menudesc,menutype,tblconfigname,tblinfoname) values ('left','系统级菜单二(原系统左侧菜单)','原系统左侧菜单','sys','leftmenuinfo','leftmenuconfig') ;
GO

insert menucenter(id,menuname,menudesc,menutype,tblconfigname,tblinfoname) values ('hp','系统级菜单三(原系统首页导航菜单)','原系统首页导航菜单','sys','','') ;
GO 


CREATE TABLE menucustom (
	id int NOT NULL, 
	menuname varchar(100) NULL ,
	menuicon varchar(200),
	menuhref varchar (300) NULL ,
	menutarget varchar (100) NULL ,
	menuparentid varchar(200) not null,	
	menuindex varchar(20),
	menutype varchar(20)
)
GO 
create table maintinnerhp(
	id int IDENTITY (1, 1) NOT NULL,
	hpid int not null,
	type int not null, 
	content int not null,
	seclevel int not null default 0,
	sharelevel int not null default 1
)
create index mainthp_type_contnet on maintinnerhp(type,content)
GO

insert into  hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) values(33,2,'图表元素','/images/homepage/element/reportform.gif',-1,3,'getReportFormMore','图形化图表元素')
GO
insert into hpextelement (id,extshow,description) values(33,'ReportForm.jsp','图表显示页面')
GO
insert into hpWhereElement (id,elementid,settingshowmethod,getwheremethod) values(33,33,'getReportFormSettingStr','')
GO

if exists (select * from dbo.sysobjects where id = object_id(N'hpreportformtype') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table hpreportformtype
GO

CREATE TABLE hpreportformtype (
	id int NOT NULL ,
	name varchar(50) NOT NULL ,
	src varchar (200) not null
)
GO

insert into hpreportformtype (id,name,src) values(1,'22883','FCF_Column2D.swf')
GO
insert into hpreportformtype (id,name,src) values(2,'22882','FCF_Column3D.swf')
GO
insert into hpreportformtype (id,name,src) values(3,'22884','FCF_Line.swf')
GO
insert into hpreportformtype (id,name,src) values(4,'22885','FCF_Area2D.swf')
GO
insert into hpreportformtype (id,name,src) values(5,'22889','FCF_Bar2D.swf')
GO
insert into hpreportformtype (id,name,src) values(6,'22886','FCF_Pie2D.swf')
GO
insert into hpreportformtype (id,name,src) values(7,'22887','FCF_Pie3D.swf')
GO
insert into hpreportformtype (id,name,src) values(8,'22888','FCF_Doughnut2D.swf')
GO
insert into hpreportformtype (id,name,src) values(9,'22897','FCF_MSColumn2DLineDY.swf')
GO
insert into hpreportformtype (id,name,src) values(10,'22898','FCF_MSColumn3DLineDY.swf')
GO
insert into hpreportformtype (id,name,src) values(11,'22901','g_speedometer_03.xml')
GO



drop index hpbaseElement.hpBaseElement_id
GO
ALTER   TABLE   hpbaseelement   ALTER   COLUMN   id   varchar(200)
GO
create index hpBaseElement_id on hpbaseElement(id)
GO
ALTER   TABLE   hpelement   ALTER   COLUMN   ebaseid   varchar(200)
GO
drop index hpsqlelement.hpSqlElement_eid
GO
ALTER   TABLE   hpsqlelement   ALTER   COLUMN   elementid   varchar(200)
GO
create index hpSqlElement_eid on hpsqlelement(elementid)
GO
drop index hpextelement.hpextelement_id
GO
ALTER   TABLE   hpextelement   ALTER   COLUMN   id   varchar(200)
GO
create index hpextelement_id on hpextelement(id)
GO
drop index hpFieldElement.hpFieldElement_eid
GO
drop index hpFieldElement.hpFieldElement_eid_ordernum
GO
alter table hpFieldElement alter column elementid  varchar(200)
GO
create index hpFieldElement_eid on hpFieldElement(elementid)
GO
create index hpFieldElement_eid_ordernum on hpFieldElement(elementid)
GO


if exists (select * from dbo.sysobjects where id = object_id(N'hpElementSetting') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table hpElementSetting
GO

CREATE TABLE hpElementSetting (
	id int NOT NULL ,
	eid int NOT NULL ,
	name varchar (200) not null,
	value varchar (200) 
	
)
GO


alter table hpsetting_wfcenter add  tabid varchar(5)
GO
update hpsetting_wfcenter set tabid = '1'
GO
alter table hpsetting_wfcenter add  tabTitle varchar(200)
GO
update hpsetting_wfcenter  set tabTitle =  (select title from hpelement where id = hpsetting_wfcenter.eid) 
GO
delete from hpsetting_wfcenter  where id not in (select max(id) as id  from hpsetting_wfcenter group by eid)
GO
if exists (select * from dbo.sysobjects where id = object_id(N'hpNewsTabInfo') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table hpNewsTabInfo
GO

CREATE TABLE hpNewsTabInfo (
	eid int NOT NULL ,
	tabid varchar (5) not null,
	tabTitle varchar (200) not null,
	sqlWhere varchar (2000) 
	
)
GO

insert into hpNewsTabInfo (eid,tabid,tabTitle,sqlWhere) select id,1,title,strsqlwhere from hpelement where ebaseid in ('7','8') 
GO
if exists (select * from dbo.sysobjects where id = object_id(N'pagelayout') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table pagelayout
GO

CREATE TABLE pagelayout (
	id int IDENTITY(1,1) NOT NULL ,
	layoutname varchar (200) not null,
	layoutdesc varchar (200) not null,
	layouttype varchar (200) not null,
	layoutdir varchar(200) not null,
	zipname varchar(200) not null
)
GO

insert into pagelayout (layoutname,layoutdesc,layouttype,layoutdir,zipname) 
select layoutname,layoutdesc,'sys','','' from hpbaselayout
GO

alter table hpbaselayout alter column ftl  varchar(200)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'pagenewstemplate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table pagenewstemplate
GO

CREATE TABLE pagenewstemplate (
	id int   IDENTITY(1,1)  NOT NULL ,
	templatename varchar (200) not null,
	templatedesc varchar (200) not null,
	templatetype varchar (200) not null,
	templatedir varchar(200) not null,
	zipname varchar(200) not null,
	allowArea varchar(200) 
)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'pagenewstemplatelayout') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table pagenewstemplatelayout
GO

CREATE TABLE pagenewstemplatelayout (
	templateid varchar(200) not null,
	areaFlag varchar (200) not null,
	areaElements varchar (200) 
)
GO

alter table hpFieldLength add newstemplate varchar(200) null
GO

alter table pagetemplate alter column zipName varchar(200)
GO

alter table menucustom add righttype varchar(200) 
GO
alter table menucustom add rightvalue varchar(200) 
GO


CREATE TABLE [scratchpad] (
	[userid] [int] NOT NULL ,
	[padcontent] [varchar] (5000) NOT NULL 
) 
GO

CREATE TABLE [picture] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[pictureurl] [varchar] (1000)  NOT NULL ,
	[picturename] [varchar] (1000) NULL ,
	[picturelink] [varchar] (1000) NULL ,
	[pictureOrder] [int] NULL  DEFAULT (0),
	[picturetype] [int] NOT NULL ,
	[eid] [varchar] (1000) not null
)
GO

update mainmenuinfo set linkaddress='/page/maint/template/login/List.jsp' where id=778
GO

update mainmenuinfo set labelid=23029 ,menuName='自定义模板' where id=778
GO

insert into extendHomepage(id,extendname,extenddesc,extendurl) values (2,'自定义模板','自定义模板','/portal/plugin/homepage/webcustom')
GO


CREATE TABLE extendHpWebCustom (
	id int IDENTITY (1, 1) NOT NULL,
	templateid varchar(100) NULL ,
	subCompanyId varchar(100) NULL ,	
	pagetemplateid  varchar(100) NULL ,
	menuid  varchar(100) NULL ,
	menustyleid  varchar(100) NULL ,
	useVoting  varchar(10) NULL ,
	useRTX  varchar(10) NULL ,
	useWfNote  varchar(10) NULL ,
	useBirthdayNote  varchar(10) NULL 
)
GO



update mainmenuinfo set linkAddress='/homepage/maint/LoginPageContent.jsp' where menuname='登录前页面'
GO
update mainmenuinfo set linkAddress='/page/maint/menu/MenuCenter.jsp?menutype=1' where menuname='登录前菜单'
GO
update mainmenuinfo set linkAddress='/page/maint/menu/MenuCenter.jsp?menutype=2' where menuname='登录后菜单'
GO

alter table SystemLoginTemplate add  modeid varchar(100) NULL
GO
alter table SystemLoginTemplate add  menuid varchar(100) NULL
GO
alter table SystemLoginTemplate add  menutype varchar(50) NULL
GO
alter table SystemLoginTemplate add  menutypeid varchar(100) NULL
GO
alter table SystemLoginTemplate alter column templateType [varchar] (20)
GO
alter table SystemLoginTemplate add  floatwidth varchar(100) NULL
GO
alter table SystemLoginTemplate add  floatheight varchar(100) NULL
GO
alter table SystemLoginTemplate add  windowwidth varchar(100) NULL
GO
alter table SystemLoginTemplate add  windowheight varchar(100) NULL
GO
alter table SystemLoginTemplate add  docId varchar(100) NULL
GO
alter table SystemLoginTemplate add  openWindowLink varchar(1000) NULL
GO
alter table SystemLoginTemplate add  defaultshow varchar(1000) NULL
GO

update hpelement set styleid = ( select styleid from hpinfo where id = hpelement.hpid)
GO
