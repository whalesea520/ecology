alter table CRM_SellChance add sufactor int null
/
alter table CRM_SellChance add defactor int null
/



CREATE or REPLACE PROCEDURE CRM_SellChance_insert
(
	creater_1 integer ,
	subject_1 varchar2 ,
	customerid_1 integer ,
	comefromid_1 integer ,
	sellstatusid_1 integer ,
	endtatusid_1 char ,
	predate_1 char ,
	preyield_1 number ,
	currencyid_1 integer ,
	probability_1 number ,
	createdate_1 char ,
	createtime_1 char,
	content_1 varchar2 ,
	sufactor_1 integer,
	defactor_1 integer,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
insert INTO CRM_SellChance
(
	creater ,
	subject ,
	customerid ,
	comefromid ,
	sellstatusid ,
	endtatusid ,
	predate ,
	preyield ,
	currencyid ,
	probability ,
	createdate ,
	createtime ,
	content,
	sufactor,
	defactor)
	values
	(
	creater_1  ,
	subject_1  ,
	customerid_1  ,
	comefromid_1  ,
	sellstatusid_1  ,
	endtatusid_1  ,
	predate_1  ,
	preyield_1  ,
	currencyid_1  ,
	probability_1 ,
	createdate_1  ,
	createtime_1  ,
	content_1 ,
	sufactor_1,
	defactor_1);
end;
/


CREATE or REPLACE PROCEDURE CRM_SellChance_Update
(
	creater_1 integer ,
	subject_1 varchar2 ,
	customerid_1 integer ,
	comefromid_1 integer ,
	sellstatusid_1 integer ,
	endtatusid_1 char ,
	predate_1 char ,
	preyield_1 number ,
	currencyid_1 integer ,
	probability_1 number ,
	content_1 varchar2 ,
	id_1 integer,
	sufactor_1 integer,
	defactor_1 integer,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
update CRM_SellChance set

	creater = creater_1,
	subject = subject_1,
	customerid =customerid_1,
	comefromid =comefromid_1,
	sellstatusid=sellstatusid_1 ,
	endtatusid =endtatusid_1,
	predate=predate_1 ,
	preyield =preyield_1,
	currencyid =currencyid_1,
	probability =probability_1,
	content= content_1,
	sufactor = sufactor_1,
	defactor = defactor_1
WHERE id=id_1;
end;
/

alter table Prj_ProjectInfo add contractids varchar(1000) null
/

CREATE or REPLACE PROCEDURE Prj_ProjectInfo_UConids
(
	prj_id integer ,
	contractids_1 varchar2 ,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
	update Prj_ProjectInfo set
	contractids = contractids_1 WHERE id=prj_id;
end;
/



alter table CRM_CreditInfo add highamount decimal(12,3) null
/


 CREATE or REPLACE PROCEDURE CRM_CreditInfo_Insert 
 (
	fullname_1 	varchar2, 
	creditamount_1 	varchar2,
	highamout_1  varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 AS 
 begin
 INSERT INTO  CRM_CreditInfo ( fullname, creditamount,highamount) 
 VALUES ( fullname_1, to_number(creditamount_1),to_number(highamout_1));
end;
/


 CREATE or REPLACE PROCEDURE CRM_CreditInfo_Update 
 (
	id_1 	integer, 
	fullname_1 	varchar2,
	creditamount_1 	varchar2,
	highamout_1  varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 AS 
 begin
 UPDATE CRM_CreditInfo  SET 
 fullname	 = fullname_1,
 creditamount	 = to_number(creditamount_1 ) ,
 highamount	 = to_number(highamout_1 ) 
 WHERE ( id	 = id_1);
end;
/



create table CRM_SelltimeSpan
( 
id integer  NOT NULL ,
timespan  integer null,
spannum   integer null
)
/
create sequence CRM_SelltimeSpan_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CRM_SelltimeSpan_Trigger
before insert on CRM_SelltimeSpan
for each row
begin
select CRM_SelltimeSpan_id.nextval INTO :new.id from dual;
end;
/


CREATE or REPLACE PROCEDURE CRM_SellTimespan_SelectAll
(
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 as
 begin
 open thecursor for
 select * from CRM_SelltimeSpan ;
 end;
/


 CREATE or REPLACE PROCEDURE CRM_SellTimespan_insert
(
	time_1 integer,
	spannum_1 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 as
 begin
 insert INTO CRM_SelltimeSpan
 (timespan,spannum)values(time_1,spannum_1);
 end;
/


 CREATE or REPLACE PROCEDURE CRM_SellTimespan_update
( 
	time_1 integer,
	spannum_1 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 as
 begin
 update CRM_SelltimeSpan set
 timespan = time_1,
 spannum = spannum_1;
 end;
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2252,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2252,'成功关键因数',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2252,'成功关键因数')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2253,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2253,'失败关键因数',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2253,'失败关键因数')
/


/* 2003-04-22 建立考核种类表 */
CREATE TABLE HrmCheckKind (
	id integer NOT NULL  ,
	checkname varchar (60)  NULL ,
	checkcycle char (1)   NULL ,
	checkexpecd integer NULL,
	checkstartdate char(10)  NULL ,
	checkenddate char(10)  NULL 
) 
/
create sequence HrmCheckKind_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCheckKind_Trigger
before insert on HrmCheckKind
for each row
begin
select HrmCheckKind_id.nextval INTO :new.id from dual;
end;
/


/* 2003-04-22 建立考核种类项目表 */
CREATE TABLE HrmCheckKindItem (
	id integer  NOT NULL  ,
	checktypeid integer  NULL ,
	checkitemid integer   NULL ,
	checkitemproportion integer NULL 
) 
/
create sequence HrmCheckKindItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCheckKindItem_Trigger
before insert on HrmCheckKindItem
for each row
begin
select HrmCheckKindItem_id.nextval INTO :new.id from dual;
end;
/


/* 2003-04-22 建立考核岗位表 */
CREATE TABLE HrmCheckPost
(	id integer  NOT NULL  ,
	checktypeid integer  NULL ,
	jobid integer   NULL 
	) 
/
create sequence HrmCheckPost_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCheckPost_Trigger
before insert on HrmCheckPost
for each row
begin
select HrmCheckPost_id.nextval INTO :new.id from dual;
end;
/


/* 2003-04-22 建立考核参与人表 */
CREATE TABLE HrmCheckActor (
	id integer  NOT NULL  ,
	checktypeid integer  NULL ,
	typeid integer   NULL ,
	resourseid integer NULL,
	checkproportion integer NULL	
) 
/
create sequence HrmCheckActor_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCheckActor_Trigger
before insert on HrmCheckActor
for each row
begin
select HrmCheckActor_id.nextval INTO :new.id from dual;
end;
/
/* 2003-04-28 建立被考核人表 */
CREATE TABLE HrmByCheckPeople (
	id integer  NOT NULL  ,
	checktypeid integer  NULL ,/*考核id*/
	resourseid integer NULL,/*员工ID*/
	checkcycle char (1)   NULL ,/*周期*/
	checkexpecd integer NULL,/*考核期*/
	checkstartdate char(10)  NULL ,/*开始日期*/
    checkenddate char(10)  NULL ,
	result char (8) NULL/*成绩*/	
) 
/
create sequence HrmByCheckPeople_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmByCheckPeople_Trigger
before insert on HrmByCheckPeople
for each row
begin
select HrmByCheckPeople_id.nextval INTO :new.id from dual;
end;
/

/* 2003-04-28 建立考核表 */
CREATE TABLE HrmCheckList (
	id integer  NOT NULL  ,
	name varchar2 (60) NULL,
	checktypeid integer  NULL ,/*考核id*/
	startdate char NULL,/*开始日期*/
	enddate char NULL ,/*结束日期*/
	status varchar2(10) NULL/*考核状态*/		
) 
/
create sequence HrmCheckList_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCheckList_Trigger
before insert on HrmCheckList
for each row
begin
select HrmCheckList_id.nextval INTO :new.id from dual;
end;
/

/* 2003-04-28 建立考核成绩表 */
CREATE TABLE HrmCheckGrade (
	id integer NOT NULL  ,
	resourseid integer NULL,/*员工ID*/
	checktypeid integer  NULL ,/*考核id*/
	itemid integer NULL,/*项目ID*/
	result number(12,3)  NULL /*成绩*/			
) 
/
create sequence HrmCheckGrade_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCheckGrade_Trigger
before insert on HrmCheckGrade
for each row
begin
select HrmCheckGrade_id.nextval INTO :new.id from dual;
end;
/



/* 2003-4-25建立考核种类存储过程 */
CREATE or REPLACE PROCEDURE HrmCheckKind_Insert
(
	checkname_2 varchar2,
	checkcycle_3 char,
	checkexpecd_4 integer,
	checkstartdate_5 char,
	checkenddate_6 char,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 AS
 BEGIN
   insert into HrmCheckKind (checkname,checkcycle,checkexpecd,checkstartdate,checkenddate) 
   values (checkname_2,checkcycle_3,   checkexpecd_4, checkstartdate_5,checkenddate_6);
end;
/


 /* 2003-4-25建立针对的岗位存储过程 */
CREATE or REPLACE PROCEDURE HrmCheckPost_Insert
(
	checktypeid_2 integer,
	jobid_3 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 AS
 begin
   insert into HrmCheckPost (checktypeid,jobid) values (checktypeid_2,jobid_3);
 end;
/


 /* 2003-4-25建立考核项目存储过程 */
CREATE or REPLACE PROCEDURE HrmCheckKindItem_Insert
(
	checktypeid_2 integer,
	checkitemid_3 integer,
	checkitemproportion_4 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 AS
 begin
   insert into HrmCheckKindItem (checktypeid,checkitemid,checkitemproportion) 
   values (checktypeid_2,checkitemid_3,checkitemproportion_4);
 end;
/

  /* 2003-4-25建立考核参与人表的存储过程 */
CREATE or REPLACE PROCEDURE HrmCheckActor_Insert
(
	checktypeid_2 integer,
	typeid_3 integer,
	resourseid_4 integer,
	checkproportion_5 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 AS
 begin
   insert into HrmCheckActor (checktypeid,typeid,resourseid,checkproportion) 
   values (checktypeid_2,typeid_3,resourseid_4,checkproportion_5);
end;
/
/*2003-4-28显示考核种类的一条记录*/
CREATE or REPLACE PROCEDURE HrmCheckKind_SByid
(
	id_1 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS
begin 
open thecursor for
 select * from HrmCheckKind where id= id_1;
end;
/

/*2003-4-28显示针对的岗位的一条记录*/
CREATE or REPLACE PROCEDURE HrmCheckPost_SByid
(
	id_1 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS
begin
open thecursor for
 select * from HrmCheckPost where id= id_1;
end;
/

 /*2003-4-17修改考核种类存储过程*/
CREATE or REPLACE PROCEDURE HrmCheckKind_Update
	(id_1 integer,
	checkname_2 varchar2,
	checkcycle_3 char,
	checkexpecd_4 integer,
	checkstartdate_5 char,
	checkenddate_6 char,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
UPDATE HrmCheckKind set
checkname = checkname_2,
checkcycle = checkcycle_3,
checkexpecd = checkexpecd_4,
checkstartdate= checkstartdate_5,
checkenddate = checkenddate_6
WHERE
 id = id_1;
end;
/


/*2003年4月22日 建立了一个新的标签*/
insert into HtmlLabelIndex (id,indexdesc) values (6124,'考核实施')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6124,'考核实施',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6124,'',8)
/

/*2003年4月22日 建立了一个新的标签*/
insert into HtmlLabelIndex (id,indexdesc) values (6125,'考核报告')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6125,'考核报告',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6125,'',8)
/


alter table HrmCareerInvite add 
  careerplanid integer null
/

alter table HrmCareerInvite add 
  isweb integer default(1)
  /*1:yes;2:no*/
/

create table HrmCareerInviteStep
(id integer  not null,
 inviteid integer null,
 name varchar2(60) null,
 startdate char(10) null,
 enddate char(10) null,
 assessor integer null,
 assessstartdate char(10) null,
 assessenddate char(10) null,
 informdate char(10) null
 )
/
create sequence HrmCareerInviteStep_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCareerInviteStep_Trigger
before insert on HrmCareerInviteStep
for each row
begin
select HrmCareerInviteStep_id.nextval INTO :new.id from dual;
end;
/


alter table HrmTrainRecord drop
 column createid
 /*trainunit 记录 培训资源id，traintype 记录 培训活动id,trainour 记录 培训成绩，trainrecord 记录培训考评*/
/

alter table HrmTrainRecord drop
 column createdate
/

alter table HrmTrainRecord drop
 column createtime
/

alter table HrmTrainRecord drop
 column lastmoderid
/

alter table HrmTrainRecord drop
 column lastmoddate
/

alter table HrmTrainRecord drop
 column lastmodtime
/



alter table HrmCareerApply add
  careerinviteid integer null
/

alter table HrmCareerApply add
  folk varchar2(30) null
/

alter table HrmCareerApply add
  islabouunion char(1) null
/

alter table HrmCareerApply add
  weight integer null
/

alter table HrmCareerApply add
  tempresidentnumber varchar2(60) null
/

create table HrmInterview
(id integer not null,
 resourceid integer null,
 stepid integer null,
 date_n char(10) null,
 time char(8) null,
 address varchar(200) null,
 notice varchar2(4000) null,
 status integer default(0),
 /*0、未考核；1、通过；2、备份*/
 interviewer varchar2(200) null)
/
create sequence HrmInterview_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmInterview_Trigger
before insert on HrmInterview
for each row
begin
select HrmInterview_id.nextval INTO :new.id from dual;
end;
/


alter table HrmCareerApply add
  nowstep integer default(0)
/

alter table HrmCareerApply add
  isinform integer default(0)
  /*0、未通知；1、已通知*/
/

create table HrmInterviewAssess
(id integer  not null,
 resourceid integer null,
 stepid integer null,
 result integer null,
 remark varchar2(4000) null,
 assessor integer null,
 assessdate char(10) null)
/
create sequence HrmInterviewAssess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmInterviewAssess_Trigger
before insert on HrmInterviewAssess
for each row
begin
select HrmInterviewAssess_id.nextval INTO :new.id from dual;
end;
/


create table HrmInterviewResult
(id integer  not null,
 resourceid integer null,
 stepid integer null,
 result integer null,
 /*0、淘汰；1、通过；2、备案*/
 remark varchar2(4000) null,
 tester integer null,
 testdate char(10) null)
/
create sequence HrmInterviewResult_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmInterviewResult_Trigger
before insert on HrmInterviewResult
for each row
begin
select HrmInterviewResult_id.nextval INTO :new.id from dual;
end;
/


 CREATE or REPLACE  procedure HrmResourceDateCheck
	(today_1 char,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 as 
 begin
 update HrmResource set
   status = 7
 where
    (status = 0 or status = 1 or status = 2 or status = 3) and enddate < today_1 and enddate <>'';
 update HrmResource set
   status = 3
 where
   status = 0 and probationenddate < today_1;
end;
/

 CREATE or REPLACE PROCEDURE HrmCareerInvite_Insert 
 (careername_1 	varchar2, 
  careerpeople_2 	char, 
  careerage_3 	varchar2, 
  careersex_4 	char, 
  careeredu_5 	char, 
  careermode_6 	varchar2, 
  careeraddr_7 	varchar2, 
  careerclass_8 	varchar2, 
  careerdesc_9 	varchar2, 
  careerrequest_10 	varchar2, 
  careerremark_11 	varchar2, 
  createrid_12 	integer, 
  createdate_13 	char, 
  planid_14 	char, 
  isweb_15 	char, 
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
INSERT INTO HrmCareerInvite 
( careername, 
  careerpeople, 
  careerage, 
  careersex, 
  careeredu, 
  careermode, 
  careeraddr, 
  careerclass, 
  careerdesc, 
  careerrequest, 
  careerremark, 
  createrid, 
  createdate,
  careerplanid,
  isweb) 
VALUES 
( careername_1, 
  careerpeople_2, 
  careerage_3, 
  careersex_4, 
  careeredu_5, 
  careermode_6, 
  careeraddr_7, 
  careerclass_8, 
  careerdesc_9, 
  careerrequest_10, 
  careerremark_11, 
  createrid_12, 
  createdate_13,
  planid_14,
  isweb_15);
open thecursor for
select max(id) from HrmCareerInvite;
end;
/

 CREATE or REPLACE PROCEDURE HrmCareerInvite_Update 
 (id_1 	integer, 
  careername_2 	varchar2, 
  careerpeople_3 	char,
  careerage_4 	varchar2, 
  careersex_5 	char, 
  careeredu_6 	char, 
  careermode_7 	varchar2, 
  careeraddr_8 	varchar2,
  careerclass_9 	varchar2,
  careerdesc_10 	varchar2, 
  careerrequest_11 	varchar2, 
  careerremark_12 	varchar2,
  lastmodid_13 	integer, 
  lastmoddate_14 	char,
  planid_15 	char, 
  isweb_16 	char,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)  
 AS
 begin
 UPDATE HrmCareerInvite  SET  
  careername	 = careername_2, 
  careerpeople	 = careerpeople_3, 
  careerage	 = careerage_4, 
  careersex	 = careersex_5, 
  careeredu	 = careeredu_6, 
  careermode	 = careermode_7, 
  careeraddr	 = careeraddr_8, 
  careerclass	 = careerclass_9, 
  careerdesc	 = careerdesc_10, 
  careerrequest	 = careerrequest_11, 
  careerremark	 = careerremark_12, 
  lastmodid	 = lastmodid_13, 
  lastmoddate	 = lastmoddate_14,
  careerplanid = planid_15,
  isweb = isweb_16
WHERE ( id	 = id_1) ;
end;
/


CREATE or REPLACE PROCEDURE HrmCareerInviteStep_Insert
	(inviteid_1 	integer,
	 name_2 	varchar2,
	 startdate_3 	char,
	 enddate_4 	char,
	 assessor_5 	integer,
	 assessstartdate_6 	char,
	 assessenddate_7 	char,
	 informdate_8 	char,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)

AS
begin
INSERT INTO HrmCareerInviteStep 
	 ( inviteid,
	 name,
	 startdate,
	 enddate,
	 assessor,
	 assessstartdate,
	 assessenddate,
	 informdate) 
 
VALUES 
	(inviteid_1,
	 name_2,
	 startdate_3,
	 enddate_4,
	 assessor_5,
	 assessstartdate_6,
	 assessenddate_7,
	 informdate_8);
end;
/


 CREATE or REPLACE PROCEDURE HrmCareerInvite_Delete 
 (id_1 	integer, 
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)  
 AS 
 begin
 DELETE HrmCareerInvite  
 WHERE  
  id	 = id_1 ;
 delete HrmCareerInviteStep 
 where
  inviteid = id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmTrainRecord_Insert 
 (resourceid_1 	integer, 
	trainstartdate_2 	char, 
	trainenddate_3 	char, 
	traintype_4 	integer, 
	trainrecord_5 	varchar2, 
	trainhour_6		number, 
	trainunit_7		varchar2, 
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	) 
AS 
begin
INSERT INTO  HrmTrainRecord 
( resourceid, 
  trainstartdate, 
  trainenddate, 
  traintype, 
  trainrecord, 
  trainhour, 
  trainunit )  
VALUES 
( resourceid_1, 
  trainstartdate_2, 
  trainenddate_3, 
  traintype_4, 
  trainrecord_5, 
  trainhour_6, 
  trainunit_7); 
end;
/

CREATE or REPLACE PROCEDURE HrmCareerApply_InsertBasic
	(id_1 integer,
	lastname_2 varchar2,
	sex_3 char,
	jobtitle_4 integer,
	homepage_5 varchar2,
	email_6 varchar2,
	homeaddress_7 varchar2,
	homepostcode_8 varchar2,
	homephone_9 varchar2,
	inviteid_10 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as 
begin
insert into HrmCareerApply
(id,
 lastname,
 sex,
 jobtitle,
 homepage,
 email,
 homeaddress,
 homepostcode,
 homephone,
 careerinviteid)
values
(id_1,
 lastname_2,
 sex_3,
 jobtitle_4,
 homepage_5,
 email_6, 
 homeaddress_7,
 homepostcode_8,
 homephone_9,
 inviteid_10);
end;
/



CREATE or REPLACE PROCEDURE HrmCareerApplyOtherIndo_In
	(applyid_2 	integer,
	category_3 	char,
	contactor_4 	varchar2,
	salarynow_5 	varchar2,
	worktime_6 	varchar2,
	salaryneed_7 	varchar2,
	currencyid_8 	integer,
	reason_9 	varchar2,
	otherrequest_10 	varchar2,
	selfcomment_11 	varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS
begin
INSERT INTO HrmCareerApplyOtherInfo 
	 (applyid,
	 category,
	 contactor,
	 salarynow,
	 worktime,
	 salaryneed,
	 currencyid,
	 reason,
	 otherrequest,
	 selfcomment) 
 
VALUES 
	(applyid_2,
	 category_3,
	 contactor_4,
	 salarynow_5,
	 worktime_6,
	 salaryneed_7,
	 currencyid_8,
	 reason_9,
	 otherrequest_10,
	 selfcomment_11);
end;
/

CREATE or REPLACE PROCEDURE HrmCareerApply_InsertPer
( id_1 integer, 
	birthday_2 char, 
	folk_3 varchar2, 
	nativeplace_4 varchar2, 
	regresidentplace_5 varchar2, 
	maritalstatus_6 char, 
	policy_7 varchar2,
	bememberdate_8 char, 
	bepartydate_9 char, 
	islabouunion_10 char,
	educationlevel_11 char, 
	degree_12 varchar2, 
	healthinfo_13  char, 
	height_14 integer,
	weight_15 integer, 
	residentplace_16 varchar2, 
	tempresidentnumber_18 varchar2, 
	certificatenum_19 varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS
begin
UPDATE HrmCareerApply SET 
  birthday = birthday_2,
  folk = folk_3,
  nativeplace = nativeplace_4,
  regresidentplace = regresidentplace_5,
  maritalstatus = maritalstatus_6,
  policy = policy_7,
  bememberdate = bememberdate_8,
  bepartydate = bepartydate_9,
  islabouunion = islabouunion_10,
  educationlevel = educationlevel_11,
  degree = degree_12,
  healthinfo = healthinfo_13,
  height = height_14,
  weight = weight_15,
  residentplace = residentplace_16,
  tempresidentnumber = tempresidentnumber_18,
  certificatenum = certificatenum_19
WHERE
  id = id_1;
end;
/


CREATE or REPLACE PROCEDURE HrmInterview_Insert
	(resourceid_1 	integer,
	stepid_2 	integer,
	date_3 	char,
	time_4 	char,
	address_5 	varchar2,
	notice_6 	varchar2,
	interviewer_8 	varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS
begin
INSERT INTO HrmInterview 
	 ( resourceid,
	 stepid,
	 date_n,
	 time,
	 address,
	 notice,
	 interviewer)  
VALUES 
	(resourceid_1,
	 stepid_2,
	 date_3,
	 time_4,
	 address_5,
	 notice_6,
	 interviewer_8);
end;
/


CREATE or REPLACE PROCEDURE HrmInterview_Delete
	(id_1 	integer,
	stepid_2 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
DELETE from HrmInterview 
WHERE 
	 resourceid	 = id_1 and    stepid = stepid_2;
end;
/


CREATE or REPLACE PROCEDURE HrmInterviewAssess_Delete
	(
	id_1 	integer,
	stepid_2 integer,
	userid_3 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
DELETE from HrmInterviewAssess 
WHERE 
	 resourceid	 = id_1 and  stepid = stepid_2 and  assessor = userid_3;
end;
/


CREATE or REPLACE PROCEDURE HrmInterviewAssess_Insert
	(resourceid_1 	integer,
	 stepid_2 	integer,
	 result_3 	integer,
	 remark_4 	varchar2,
	 userid_5 	integer,
	 assessdate_6 	char,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
INSERT INTO HrmInterviewAssess 
	 (resourceid,
	 stepid,
	 result,
	 remark,
	 assessor,
	 assessdate)
VALUES 
	(resourceid_1,
	 stepid_2,
	 result_3,
	 remark_4,
	 userid_5,
	 assessdate_6);
end;
/


CREATE or REPLACE PROCEDURE HrmCareerApply_Inform
	(id_1 	integer,	 
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)

AS 
begin
update HrmCareerApply set
  isinform = 1
WHERE 
	 id	 = id_1 ;
end;
/


CREATE or REPLACE PROCEDURE HrmInterviewResult_Insert
	(resourceid_1 	integer,
	 stepid_2 	integer,
	 result_3 	integer,
	 remark_4 	varchar2,
	 userid_5 	integer,
	 testdate_6 	char,
		flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
AS 
begin
INSERT INTO HrmInterviewResult 
	 (resourceid,
	 stepid,
	 result,
	 remark,
	 tester,
	 testdate)
VALUES 
	(resourceid_1,
	 stepid_2,
	 result_3,
	 remark_4,
	 userid_5,
	 testdate_6);
update HrmInterview set 
  status = 1;
end;
/

CREATE or REPLACE PROCEDURE HrmCareerApply_Pass
	(resourceid_1 	integer,
	stepid_2 	integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as 
begin
update HrmCareerApply set
 nowstep = stepid_2,
 isinform = 0
where
 id = resourceid_1;
end;
/


CREATE or REPLACE PROCEDURE HrmCareerApply_Backup
(resourceid_1 	integer, 
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as 
begin
update HrmCareerApply set
 nowstep = 0,
 careerinviteid = 0 where
 id = resourceid_1;
end;
/

CREATE or REPLACE PROCEDURE HrmCareerApply_Delete
	(resourceid_1 	integer, 
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
delete HrmCareerApply 
where
 id = resourceid_1;

delete HrmInterview
where 
 resourceid = resourceid_1;

delete HrmInterviewAssess
where
 resourceid = resourceid_1;

delete HrmInterviewResult
where
 resourceid = resourceid_1;

delete HrmCareerApplyOtherInfo
where 
  applyid = resourceid_1;

delete HrmEducationInfo
where
 resourceid = resourceid_1;

delete HrmFamilyInfo
where
 resourceid = resourceid_1;

delete HrmLanguageAbility
where
 resourceid = resourceid_1;

delete HrmWorkResume
where
 resourceid = resourceid_1;

delete HrmTrainBeforeWork
where
 resourceid = resourceid_1;

delete HrmRewardBeforeWork
where
 resourceid = resourceid_1;

delete HrmCertification
where
 resourceid = resourceid_1;
end;
/

insert into SystemRights (id, rightdesc,righttype) 
  values (374,'用工需求维护',3) 
/
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(374,4,1)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3019,'用工需求添加','HrmUseDemandAdd:Add',374)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3020,'用工需求编辑','HrmUseDemandEdit:Edit',374)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3021,'用工需求删除','HrmUseDemandDelete:Delete',374)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3022,'用工需求日志','HrmUseDemand:Log',374)
/
insert into SystemRights (id, rightdesc,righttype) 
  values (375,'招聘计划维护',3) 
/
insert into SystemRightRoles(rightid,roleid,rolelevel)
  values(375,4,1)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3023,'招聘计划添加','HrmCareerPlanAdd:Add',375)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3024,'招聘计划编辑','HrmCareerPlanEdit:Edit',375)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3025,'招聘计划删除','HrmCareerPlanDelete:Delete',375)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3026,'招聘计划日志','HrmCareerPlan:Log',375)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid)
  values(3027,'招聘计划结束','HrmCareerPlanFinish:Finish',375)
/

CREATE or REPLACE PROCEDURE HrmResource_UpdateSubCom
	(id_1 integer,
	subcompanyid1_2 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
update HrmResource set
  subcompanyid1 = subcompanyid1_2
where
  id = id_1;
end;
/


insert into SystemLogItem (itemid,lableid,itemdesc) values(66,807,'培训类型')
/

insert into HtmlLabelIndex (id,indexdesc) values (6128,'培训规划')
/

insert into HtmlLabelInfo (indexid,labelname,languageid) values (6128,'培训规划',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6128,'TrainLayout',8)
/

insert into SystemLogItem (itemid,lableid,itemdesc) values(67,6128,'培训规划')
/

CREATE or REPLACE PROCEDURE HrmResourceDateCheck
 (today_1 char,
 	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 as 
 begin
 update HrmResource set   status = 7
 where
    (status = 0 or status = 1 or status = 2 or status = 3) and enddate < today_1 and enddate <>'';
 update HrmResource set
   status = 3
 where
   status = 0 and probationenddate > today_1;
end;
/
