CREATE TABLE scratchpad (
	userid integer NOT NULL ,
	padcontent varchar2(4000) NOT NULL 
)
/
CREATE TABLE picture (
	id integer NOT NULL ,
	pictureurl varchar2(1000) NOT NULL ,
	picturename varchar2(1000) ,
	picturelink varchar2(1000),
	pictureOrder integer DEFAULT 0,
	picturetype integer NOT NULL,
	eid varchar2(1000) not null
)
/
create sequence picture_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger  picture_Id_Tri
  before insert on picture
  for each row
begin
  select picture_Id.nextval into :new.id from dual;
end;
/

update mainmenuinfo set linkAddress='/homepage/maint/LoginPageContent.jsp' where menuname='登录前页面'
/
update mainmenuinfo set linkAddress='/page/maint/menu/MenuCenter.jsp?menutype=1' where menuname='登录前菜单'
/
update mainmenuinfo set linkAddress='/page/maint/menu/MenuCenter.jsp?menutype=2' where menuname='登录后菜单'
/
alter table SystemLoginTemplate add  modeid varchar2(100) NULL
/
alter table SystemLoginTemplate add  menuid varchar2(100) NULL
/
alter table SystemLoginTemplate add  menutype varchar2(50) NULL
/
alter table SystemLoginTemplate add  menutypeid varchar2(100) NULL
/

ALTER table  SystemLoginTemplate  ADD templateType_1 varchar2(20)
/
update  SystemLoginTemplate set templateType_1 = templateType
/
ALTER table  SystemLoginTemplate  drop column templateType
/
ALTER TABLE SystemLoginTemplate RENAME COLUMN templateType_1 TO templateType
/

alter table SystemLoginTemplate add  floatwidth varchar2(100) NULL
/
alter table SystemLoginTemplate add  floatheight varchar2(100) NULL
/
alter table SystemLoginTemplate add  windowwidth varchar2(100) NULL
/
alter table SystemLoginTemplate add  windowheight varchar2(100) NULL
/
alter table SystemLoginTemplate add  docId varchar2(100) NULL
/
alter table SystemLoginTemplate add  openWindowLink varchar2(1000) NULL
/
alter table SystemLoginTemplate add  defaultshow varchar2(1000) NULL
/


ALTER table  hpinfo  ADD styleid_1 varchar2(20)
/
update  hpinfo set styleid_1 = styleid
/
ALTER table  hpinfo  drop column styleid
/
ALTER TABLE hpinfo RENAME COLUMN styleid_1 TO styleid
/

CREATE TABLE menucenter (
	id varchar2(20) NULL ,
	menuname varchar2(100) NULL ,
	menudesc varchar2(300) NULL ,
	menutype varchar2(20),
	tblconfigname varchar2(100) NULL ,
	tblinfoname varchar2(100) NULL 
)
/

insert into menucenter(id,menuname,menudesc,menutype,tblconfigname,tblinfoname) values ('top','系统级菜单一(原系统顶部菜单)','原系统顶部菜单','sys','mainmenuinfo','mainmenuconfig') 
/
insert into menucenter(id,menuname,menudesc,menutype,tblconfigname,tblinfoname) values ('left','系统级菜单二(原系统左侧菜单)','原系统左侧菜单','sys','leftmenuinfo','leftmenuconfig') 
/
insert into menucenter(id,menuname,menudesc,menutype,tblconfigname,tblinfoname) values ('hp','系统级菜单三(原系统首页导航菜单)','原系统首页导航菜单','sys','','')
/
CREATE TABLE menucustom (
	id integer NOT NULL ,
	menuname varchar2(100) NULL ,
	menuicon varchar2(200),
	menuhref varchar2(300) NULL ,
	menutarget varchar2(100) NULL ,
	menuparentid varchar2(200) not null,	
	menuindex varchar2(20),
	menutype varchar2(20)
)
/ 

create table maintinnerhp(
	id integer NOT NULL ,
	hpid integer not null,
	type integer not null, 
	content integer not null,
	seclevel integer  default 0 not null,
	sharelevel integer default 1 not null 
)
/
create sequence maintinnerhp_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger trigge_maintinnerhp_Tri
before insert on maintinnerhp
for each row
begin
select maintinnerhp_id.nextval into :new.id from dual;
end;
/
create index mainthp_type_contnet on maintinnerhp(type,content)
/

insert into  hpbaseelement (id,elementtype,title,logo,perpage,linkmode,moreurl,elementdesc) values(33,2,'图表元素','/images/homepage/element/reportform.gif',-1,3,'getReportFormMore','图形化图表元素')
/
insert into hpextelement (id,extshow,description) values(33,'ReportForm.jsp','图表显示页面')
/
insert into hpWhereElement (id,elementid,settingshowmethod,getwheremethod) values(33,33,'getReportFormSettingStr','')
/
declare
  i integer;
 
begin
  select count(*) into i from user_tables where table_name='HPREPORTFORMTYPE';
  if i>0 then
    
    execute immediate 'drop table hpreportformtype';
  end if;
  execute immediate 'CREATE TABLE hpreportformtype (
	id integer NOT NULL ,
	name varchar2(50) NOT NULL ,
	src varchar2(200) not null
)';
end;
/
insert into hpreportformtype (id,name,src) values(1,'22883','FCF_Column2D.swf')
/
insert into hpreportformtype (id,name,src) values(2,'22882','FCF_Column3D.swf')
/
insert into hpreportformtype (id,name,src) values(3,'22884','FCF_Line.swf')
/
insert into hpreportformtype (id,name,src) values(4,'22885','FCF_Area2D.swf')
/
insert into hpreportformtype (id,name,src) values(5,'22889','FCF_Bar2D.swf')
/
insert into hpreportformtype (id,name,src) values(6,'22886','FCF_Pie2D.swf')
/
insert into hpreportformtype (id,name,src) values(7,'22887','FCF_Pie3D.swf')
/
insert into hpreportformtype (id,name,src) values(8,'22888','FCF_Doughnut2D.swf')
/
insert into hpreportformtype (id,name,src) values(9,'22897','FCF_MSColumn2DLineDY.swf')
/
insert into hpreportformtype (id,name,src) values(10,'22898','FCF_MSColumn3DLineDY.swf')
/
insert into hpreportformtype (id,name,src) values(11,'22901','g_speedometer_03.xml')
/

ALTER table  hpbaseelement  ADD id_1 varchar2(200)
/
update  hpbaseelement set id_1 = id
/
ALTER table  hpbaseelement  drop column id
/
ALTER TABLE hpbaseelement RENAME COLUMN id_1 TO id
/

create index hpBaseElement_id on hpbaseElement(id)
/

ALTER table  hpelement  ADD ebaseid_1 varchar2(200)
/
update  hpelement set ebaseid_1 = ebaseid
/
ALTER table  hpelement  drop column ebaseid
/
ALTER TABLE hpelement RENAME COLUMN ebaseid_1 TO ebaseid
/

alter table hpelement add styleid varchar2(50)
/
alter table hpelement add height integer
/

ALTER table  hpsqlelement  ADD elementid_1 varchar2(200)
/
update  hpsqlelement set elementid_1 = elementid
/
ALTER table  hpsqlelement  drop column elementid
/

ALTER TABLE hpsqlelement RENAME COLUMN elementid_1 TO elementid
/

create index hpSqlElement_eid on hpsqlelement(elementid)
/


ALTER table  hpextelement  ADD id_1 varchar2(200)
/
update  hpextelement set id_1 = id
/
ALTER table  hpextelement  drop column id
/
ALTER TABLE hpextelement RENAME COLUMN id_1 TO id
/

create index hpextelement_id on hpextelement(id)
/

ALTER table  hpFieldElement  ADD elementid_1 varchar2(200)
/
update  hpFieldElement set elementid_1 = elementid
/
ALTER table  hpFieldElement  drop column elementid
/
ALTER TABLE hpFieldElement RENAME COLUMN elementid_1 TO elementid
/

create index hpFieldElement_eid on hpFieldElement(elementid)
/

declare
  i integer;
 
begin
  select count(*) into i from user_tables where table_name='HPELEMENTSETTING';
  if i>0 then
    
    execute immediate 'drop table hpElementSetting';
  end if;
  execute immediate 'CREATE TABLE hpElementSetting (
	id integer NOT NULL ,
	eid integer NOT NULL ,
	name varchar2(200) not null,
	value varchar2(200) 
	
)';
end;
/

alter table hpsetting_wfcenter add  tabid varchar2(5)
/
update hpsetting_wfcenter set tabid = '0'
/
alter table hpsetting_wfcenter add  tabTitle varchar2(200)
/
update hpsetting_wfcenter  set tabTitle =  (select title from hpelement where id = hpsetting_wfcenter.eid) 
/
delete from hpsetting_wfcenter  where id not in (select max(id) as id  from hpsetting_wfcenter group by eid)
/

declare
  i integer;
 
begin
  select count(*) into i from user_tables where table_name='HPNEWSTABINFO';
  if i>0 then
    
    execute immediate 'drop table hpNewsTabInfo';
  end if;
  execute immediate 'CREATE TABLE hpNewsTabInfo (
	eid int NOT NULL ,
	tabid varchar2(5) not null,
	tabTitle varchar2(200) not null,
	sqlWhere varchar2(2000) 
	
)';
end;
/
declare
  i integer;
 
begin
  select count(*) into i from user_tables where table_name='PAGELAYOUT';
  if i>0 then
    
    execute immediate 'drop table pagelayout';
  end if;
  execute immediate 'CREATE TABLE pagelayout (
	id integer NOT NULL ,
	layoutname varchar2(200) not null,
	layoutdesc varchar2(200) not null,
	layouttype varchar2(200) not null,
	layoutdir varchar2(200),
	zipname varchar2(200) 
)';
end;
/

create sequence pagelayout_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger trigge_pagelayout_Tri
before insert on pagelayout
for each row
begin
select pagelayout_id.nextval into :new.id from dual;
end;
/

insert into hpNewsTabInfo (eid,tabid,tabTitle,sqlWhere) select id,1,title,strsqlwhere from hpelement where ebaseid in ('7','8') 
/
insert into pagelayout (layoutname,layoutdesc,layouttype,layoutdir,zipname) select layoutname,layoutdesc,'sys','','' from hpbaselayout
/

ALTER table  hpbaselayout  ADD ftl_1 varchar2(200)
/
update  hpbaselayout set ftl_1 = ftl
/
ALTER table  hpbaselayout  drop column ftl
/
ALTER TABLE hpbaselayout RENAME COLUMN ftl_1 TO ftl
/

declare
  i integer;
 
begin
  select count(*) into i from user_tables where table_name='PAGENEWSTEMPLATE';
  if i>0 then
    
    execute immediate 'drop table pagenewstemplate';
  end if;
  execute immediate 'CREATE TABLE pagenewstemplate (
	id integer NOT NULL ,
	templatename varchar2(200) not null,
	templatedesc varchar2(200) not null,
	templatetype varchar2(200) not null,
	templatedir varchar2(200) not null,
	zipname varchar2(200) not null,
	allowArea varchar2(200) 
)';
end;
/

create sequence pagenewstemplate_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger trigge_pagenewstemplate_Tri
before insert on pagenewstemplate
for each row
begin
select pagenewstemplate_id.nextval into :new.id from dual;
end;
/

declare
  i integer;
 
begin
  select count(*) into i from user_tables where table_name='PAGENEWSTEMPLATELAYOUT';
  if i>0 then
    
    execute immediate 'drop table pagenewstemplatelayout';
  end if;
  execute immediate 'CREATE TABLE pagenewstemplatelayout (
	templateid varchar2(200) not null,
	areaFlag varchar2(200) not null,
	areaElements varchar2(200) 
)';
end;
/

alter table hpFieldLength add newstemplate varchar2(200) null
/

alter table menucustom add righttype varchar2(200) 
/
alter table menucustom add rightvalue varchar2(200) 
/

update mainmenuinfo set linkaddress='/page/maint/template/login/List.jsp' where id=778
/


CREATE TABLE pagetemplate (
	id integer NOT NULL ,
	templatename varchar2(100) NULL ,
	templatedesc varchar2(300) NULL ,
	templatetype varchar2(20),
	templateusetype varchar2(20) NULL ,
	dir varchar2(500) NULL,
	zipName varchar2(200) NULL 
)
/

create sequence pagetemplate_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger trigger_pagetemplate_Tri
before insert on pagetemplate
for each row
begin
select pagetemplate_id.nextval into :new.id from dual;
end;
/



update mainmenuinfo set labelid=23029 ,menuName='自定义模板' where id=778
/

insert into extendHomepage(id,extendname,extenddesc,extendurl) values (2,'自定义模板','自定义模板','/portal/plugin/homepage/webcustom')
/


CREATE TABLE extendHpWebCustom (
	id integer NOT NULL ,
	templateid varchar2(100) NULL ,
	subCompanyId varchar2(100) NULL ,	
	pagetemplateid  varchar2(100) NULL ,
	menuid  varchar2(100) NULL ,
	menustyleid  varchar2(100) NULL ,
	useVoting  varchar2(10) NULL ,
	useRTX  varchar2(10) NULL ,
	useWfNote  varchar2(10) NULL ,
	useBirthdayNote  varchar2(10) NULL 
)
/


create sequence extendHpWebCustom_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger trigger_extendHpWebCustom_Tri
before insert on extendHpWebCustom
for each row
begin
select extendHpWebCustom_id.nextval into :new.id from dual;
end;
/

update hpelement set styleid = ( select styleid from hpinfo where id = hpelement.hpid)
/