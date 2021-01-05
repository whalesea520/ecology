INSERT INTO extendHomepage (id, extendname, extenddesc, extendurl) VALUES (3, '软件模板2', '软件模板2','/portal/plugin/homepage/soft2')
/


create table extendHpSoft2 (
	id integer NOT NULL ,
	templateId int,
	subcompanyid int,
	logo varchar2(100),
	bgimg varchar2(100),
	ostimg varchar2(100),
	osdimg varchar2(100),
	istimg varchar2(100),
	iscimg1 varchar2(100),
	iscimg2 varchar2(100),
	isdimg varchar2(100),
	fontFamily varchar2(100),
	fontSize varchar2(100),
	skin varchar2(100)
)
/

create sequence extendHpSoft2_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger extendHpSoft2_Trigger
before insert on extendHpSoft2
for each row
begin
select extendHpSoft2_id.nextval into :new.id from dual;
end;
/


UPDATE SystemLoginTemplate SET loginTemplateName='Ecology默认登录页模板H2', loginTemplateTitle='泛微协同商务系统', templateType='H2',imageId=NULL,extendLoginId=NULL where loginTemplateid=3
/


alter table SystemLoginTemplate add imageId2 varchar2(200) null
/
alter table SystemLoginTemplate add backgroundColor varchar2(200) null
/
update systemlogintemplate set backgroundColor='#106692' where loginTemplateId=3
/




CREATE TABLE SlideElement(
	id integer NOT NULL,
	title varchar2(50),
	description varchar2(50),
	url1 varchar2(256) ,
	eid integer NOT NULL,
	link varchar2(256),
	url2 varchar2(256),
	url3 varchar2(256) 
) 
/


update   leftmenuconfig set viewindex= 23 where infoid= -2908
/
update   leftmenuconfig set viewindex= 6 where infoid= -2774
/
update   leftmenuconfig set viewindex= 21 where infoid= -2741
/
update   leftmenuconfig set viewindex= 22 where infoid= -2080
/
update   leftmenuconfig set viewindex= 3 where infoid= 1
/
update   leftmenuconfig set viewindex= 2 where infoid= 2
/
update   leftmenuconfig set viewindex= 5 where infoid= 3
/
update   leftmenuconfig set viewindex= 6 where infoid= 4
/
update   leftmenuconfig set viewindex= 4 where infoid= 5
/
update   leftmenuconfig set viewindex= 8 where infoid= 6
/
update   leftmenuconfig set viewindex= 7 where infoid= 7
/
update   leftmenuconfig set viewindex= 1 where infoid= 80
/
update   leftmenuconfig set viewindex= 20 where infoid= 94
/
update   leftmenuconfig set viewindex= 9 where infoid= 107
/
update   leftmenuconfig set viewindex= 15 where infoid= 110
/
update   leftmenuconfig set viewindex= 14 where infoid= 111
/
update   leftmenuconfig set viewindex= 16 where infoid= 114
/
update   leftmenuconfig set viewindex= 10 where infoid= 140
/
update   leftmenuconfig set viewindex= 11 where infoid= 144
/
update   leftmenuconfig set viewindex= 12 where infoid= 199
/
update   leftmenuconfig set viewindex= 23 where infoid= 352 
/
CREATE TABLE SysSkinSetting (
	id integer,
	userid varchar(100),
	skin varchar(100),
	cutoverWay varchar(100),
	TransitionTime varchar(100),
	TransitionWay varchar(100)
)

/
CREATE TABLE HrmUserMenuStatictics (
id integer,
userid integer,
menuid varchar(100),
clickCnt integer
)
/