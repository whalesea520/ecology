create table newstype(
  id int IDENTITY (1, 1) NOT NULL ,
  typename varchar(50),
  typedesc varchar(500),
  dspNum int     
)

insert into newstype(typename,typedesc,dspnum) values ('其它','其它',1000)
go

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (684,8,'新闻类型维护','新闻类型维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (684,7,'新闻类型维护','新闻类型维护') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4192,'新闻类型维护','newstype:maint',684) 
GO

EXECUTE MMConfig_U_ByInfoInsert 13,2
GO
EXECUTE MMInfo_Insert 553,19859,'新闻类型设置','/docs/news/type/newstypeList.jsp','mainFrame',13,2,2,0,'',0,'',0,'','',0,'','',1
GO

INSERT INTO HtmlLabelIndex values(19859,'新闻类型设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19859,'新闻类型设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19859,'News type setting',8) 
GO

alter table DocFrontpage add newstypeid int
go
alter table DocFrontpage add typeordernum int
go

Alter PROCEDURE DocFrontpage_Update
(@id_1 	int,
@frontpagename_2 	varchar(200),
@frontpagedesc_3 	varchar(200),
@isactive_4 	char(1),
@departmentid_5 	int,
@hasdocsubject_7 	char(1),
@hasfrontpagelist_8 	char(1),
@newsperpage_9 	tinyint,
@titlesperpage_10 	tinyint,
@defnewspicid_11 	int,
@backgroundpicid_12 	int,
@importdocid_13 	varchar(200),
@headerdocid_14 	int,
@footerdocid_15 	int,
@secopt_16 	varchar(2),
@seclevelopt_17 	tinyint,
@departmentopt_18 	int,
@dateopt_19 	int,
@languageopt_20 	int,
@clauseopt_21 	text,
@newsclause_22 	text,
@languageid_23 	int,
@publishtype_24 	int ,
@newstypeid_25  int,
@typeordernum_26  int,
@flag	int	output,
@msg	varchar(80)	output)
AS UPDATE DocFrontpage  SET  frontpagename	 = @frontpagename_2,
frontpagedesc	 = @frontpagedesc_3, 
isactive	 = @isactive_4,
departmentid	 = @departmentid_5,
hasdocsubject	 = @hasdocsubject_7,
hasfrontpagelist	 = @hasfrontpagelist_8,
newsperpage	 = @newsperpage_9,
titlesperpage	 = @titlesperpage_10,
defnewspicid	 = @defnewspicid_11,
backgroundpicid	 = @backgroundpicid_12,
importdocid	 = @importdocid_13,
headerdocid	 = @headerdocid_14,
footerdocid	 = @footerdocid_15,
secopt	 = @secopt_16,
seclevelopt	 = @seclevelopt_17,
departmentopt	 = @departmentopt_18,
dateopt	 = @dateopt_19,
languageopt	 = @languageopt_20,
clauseopt	 = @clauseopt_21,
newsclause	 = @newsclause_22,
languageid	 = @languageid_23,
publishtype	 = @publishtype_24,
newstypeid=@newstypeid_25,
typeordernum=@typeordernum_26 WHERE ( id = @id_1)

GO

Alter PROCEDURE DocFrontpage_Insert
(@frontpagename_1 	varchar(200),
@frontpagedesc_2 	varchar(200),
@isactive_3 	char(1),
@departmentid_4 	int,
@linktype_5 	varchar(2),
@hasdocsubject_6 	char(1),
@hasfrontpagelist_7 	char(1),
@newsperpage_8 	tinyint,
@titlesperpage_9 	tinyint,
@defnewspicid_10 	int,
@backgroundpicid_11 	int,
@importdocid_12 	varchar(200),
@headerdocid_13 	int,
@footerdocid_14 	int,
@secopt_15 	varchar(2),
@seclevelopt_16 	tinyint,
@departmentopt_17 	int,
@dateopt_18 	int,
@languageopt_19 	int,
@clauseopt_20 	text,
@newsclause_21 	text,
@languageid_22 	int,
@publishtype_23 	int ,
@newstypeid_24 	int ,
@typeordernum_25 int,
@flag	int	output,
@msg	varchar(80)	output)
AS INSERT INTO DocFrontpage
( frontpagename,
frontpagedesc,
isactive,
departmentid,
linktype,
hasdocsubject,
hasfrontpagelist,
newsperpage,
titlesperpage,
defnewspicid,
backgroundpicid,
importdocid,
headerdocid,
footerdocid,
secopt,
seclevelopt,
departmentopt,
dateopt,
languageopt,
clauseopt,
newsclause,
languageid,
publishtype,
newstypeid,
typeordernum)
VALUES ( @frontpagename_1,
@frontpagedesc_2,
@isactive_3,
@departmentid_4,
@linktype_5,
@hasdocsubject_6,
@hasfrontpagelist_7,
@newsperpage_8,
@titlesperpage_9,
@defnewspicid_10,
@backgroundpicid_11,
@importdocid_12,
@headerdocid_13,
@footerdocid_14,
@secopt_15,
@seclevelopt_16,
@departmentopt_17,
@dateopt_18,
@languageopt_19,
@clauseopt_20,
@newsclause_21,
@languageid_22,
@publishtype_23,
@newstypeid_24,@typeordernum_25)
select max(id) from DocFrontpage

GO

delete newstype where typename='其它' and  dspnum=1000
GO