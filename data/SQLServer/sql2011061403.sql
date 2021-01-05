INSERT INTO extendHomepage (id, extendname, extenddesc, extendurl) VALUES (3, '软件模板2', '软件模板2','/portal/plugin/homepage/soft2')
GO


create table extendHpSoft2 (
	id int identity,
	templateId int,
	subcompanyid int,
	logo nvarchar(100),
	bgimg nvarchar(100),
	ostimg nvarchar(100),
	osdimg nvarchar(100),
	istimg nvarchar(100),
	iscimg1 nvarchar(100),
	iscimg2 nvarchar(100),
	isdimg nvarchar(100),
	fontFamily nvarchar(100),
	fontSize nvarchar(100),
	skin nvarchar(100)
)
GO


UPDATE SystemLoginTemplate SET loginTemplateName='Ecology默认登录页模板H2', loginTemplateTitle='泛微协同商务系统', templateType='H2',imageId=NULL,extendLoginId=NULL where loginTemplateid=3
GO


alter table SystemLoginTemplate add imageId2 varchar(200) null;
GO
alter table SystemLoginTemplate add backgroundColor varchar(200) null;
GO
update systemlogintemplate set backgroundColor='#106692' where loginTemplateId=3
GO




CREATE TABLE SlideElement(
	id int NOT NULL,
	title varchar(50),
	description varchar(50),
	url1 varchar(256) ,
	eid int NOT NULL,
	link varchar(256),
	url2 varchar(256),
	url3 varchar(256) 
) 
GO


update   leftmenuconfig set viewindex= 23 where infoid= -2908
GO
update   leftmenuconfig set viewindex= 6 where infoid= -2774
GO
update   leftmenuconfig set viewindex= 21 where infoid= -2741
GO
update   leftmenuconfig set viewindex= 22 where infoid= -2080
GO
update   leftmenuconfig set viewindex= 3 where infoid= 1
GO
update   leftmenuconfig set viewindex= 2 where infoid= 2
GO
update   leftmenuconfig set viewindex= 5 where infoid= 3
GO
update   leftmenuconfig set viewindex= 6 where infoid= 4
GO
update   leftmenuconfig set viewindex= 4 where infoid= 5
GO
update   leftmenuconfig set viewindex= 8 where infoid= 6
GO
update   leftmenuconfig set viewindex= 7 where infoid= 7
GO
update   leftmenuconfig set viewindex= 1 where infoid= 80
GO
update   leftmenuconfig set viewindex= 20 where infoid= 94
GO
update   leftmenuconfig set viewindex= 9 where infoid= 107
GO
update   leftmenuconfig set viewindex= 15 where infoid= 110
GO
update   leftmenuconfig set viewindex= 14 where infoid= 111
GO
update   leftmenuconfig set viewindex= 16 where infoid= 114
GO
update   leftmenuconfig set viewindex= 10 where infoid= 140
GO
update   leftmenuconfig set viewindex= 11 where infoid= 144
GO
update   leftmenuconfig set viewindex= 12 where infoid= 199
GO
update   leftmenuconfig set viewindex= 23 where infoid= 352 


CREATE TABLE SysSkinSetting (
	id int identity primary key,
	userid varchar(100),
	skin varchar(100),
	cutoverWay varchar(100),
	TransitionTime varchar(100),
	TransitionWay varchar(100)
)
GO

CREATE TABLE HrmUserMenuStatictics (
id int identity primary key,
userid int,
menuid varchar(100),
clickCnt bigint,
)
GO
