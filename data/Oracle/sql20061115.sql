create table newstype(
  id integer  NOT NULL ,
  typename varchar2(50),
  typedesc varchar2(500),
  dspNum integer     
)
/
create sequence  newstype_id                                      
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger newstype_trigger		
	before insert on newstype
	for each row
	begin
	select newstype_id.nextval into :new.id from dual;
	end ;
/

insert into newstype(typename,typedesc,dspnum) values ('其它','其它',1000)
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (684,8,'新闻类型维护','新闻类型维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (684,7,'新闻类型维护','新闻类型维护') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4192,'新闻类型维护','newstype:maint',684) 
/

call MMConfig_U_ByInfoInsert (13,2)
/
call MMInfo_Insert (553,19859,'新闻类型设置','/docs/news/type/newstypeList.jsp','mainFrame',13,2,2,0,'',0,'',0,'','',0,'','',1)
/

INSERT INTO HtmlLabelIndex values(19859,'新闻类型设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19859,'新闻类型设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19859,'News type setting',8) 
/

alter table DocFrontpage add newstypeid integer
/
alter table DocFrontpage add typeordernum integer
/

create or replace PROCEDURE DocFrontpage_Update
(id_1 	integer,
frontpagename_2 	varchar2,
frontpagedesc_3 	varchar2,
isactive_4 	char,
departmentid_5 	integer,
hasdocsubject_7 	char,
hasfrontpagelist_8 	char,
newsperpage_9 	smallint,
titlesperpage_10 	smallint,
defnewspicid_11 	integer,
backgroundpicid_12 	integer,
importdocid_13 	varchar2,
headerdocid_14 	integer,
footerdocid_15 	integer,
secopt_16 	varchar2,
seclevelopt_17 	smallint,
departmentopt_18 	integer,
dateopt_19 	integer,
languageopt_20 	integer,
clauseopt_21 	clob,
newsclause_22 	clob,
languageid_23 	integer,
publishtype_24 	integer ,
newstypeid_25  integer,
typeordernum_26  integer,
flag out	integer,
msg out	varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
UPDATE DocFrontpage  SET  frontpagename	 = frontpagename_2,
frontpagedesc	 = frontpagedesc_3, 
isactive	 = isactive_4,
departmentid	 = departmentid_5,
hasdocsubject	 = hasdocsubject_7,
hasfrontpagelist	 = hasfrontpagelist_8,
newsperpage	 = newsperpage_9,
titlesperpage	 = titlesperpage_10,
defnewspicid	 = defnewspicid_11,
backgroundpicid	 = backgroundpicid_12,
importdocid	 = importdocid_13,
headerdocid	 = headerdocid_14,
footerdocid	 = footerdocid_15,
secopt	 = secopt_16,
seclevelopt	 = seclevelopt_17,
departmentopt	 = departmentopt_18,
dateopt	 = dateopt_19,
languageopt	 = languageopt_20,
clauseopt	 = clauseopt_21,
newsclause	 = newsclause_22,
languageid	 = languageid_23,
publishtype	 = publishtype_24,
newstypeid=newstypeid_25,
typeordernum=typeordernum_26 WHERE ( id = id_1);
end;

/

create or replace PROCEDURE DocFrontpage_Insert
(frontpagename_1 	varchar2,
frontpagedesc_2 	varchar2,
isactive_3 	char,
departmentid_4 	integer,
linktype_5 	varchar2,
hasdocsubject_6 	char,
hasfrontpagelist_7 	char,
newsperpage_8 	smallint,
titlesperpage_9 	smallint,
defnewspicid_10 	integer,
backgroundpicid_11 	integer,
importdocid_12 	varchar2,
headerdocid_13 	integer,
footerdocid_14 	integer,
secopt_15 	varchar2,
seclevelopt_16 	smallint,
departmentopt_17 	integer,
dateopt_18 	integer,
languageopt_19 	integer,
clauseopt_20 	clob,
newsclause_21 	clob,
languageid_22 	integer,
publishtype_23 	integer ,
newstypeid_24 	integer ,
typeordernum_25 integer,
flag out	integer,
msg out	varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
begin
INSERT INTO DocFrontpage
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
VALUES ( frontpagename_1,
frontpagedesc_2,
isactive_3,
departmentid_4,
linktype_5,
hasdocsubject_6,
hasfrontpagelist_7,
newsperpage_8,
titlesperpage_9,
defnewspicid_10,
backgroundpicid_11,
importdocid_12,
headerdocid_13,
footerdocid_14,
secopt_15,
seclevelopt_16,
departmentopt_17,
dateopt_18,
languageopt_19,
clauseopt_20,
newsclause_21,
languageid_22,
publishtype_23,
newstypeid_24,typeordernum_25);
open thecursor for
select max(id) from DocFrontpage;
end;

/

delete newstype where typename='其它' and  dspnum=1000
/