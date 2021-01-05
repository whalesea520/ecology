
/*以下是谭小鹏第二次补充的《ecology产品开发目录权限补充功能提交测试报告 V1.0》的新增他的table_2003-6-20.sql脚本。*/


ALTER TABLE DocSecCategoryShare modify (sharetype integer )
/   



/*以下是关于陈英杰Ecology产品开发--列表页面分页提交测试报告的脚本*/


alter table HrmResource 
  modify ( educationlevel integer)
/

alter table HrmCareerApply
  modify (educationlevel integer)
/

alter table HrmEducationInfo
  modify (educationlevel integer)
/

alter table HrmCareerApplyOtherInfo
  modify (salarynow integer)
/


/*以下是关于任舸的邮件模板的提交测试报告*/


/*调查项目表*/

create table T_SurveyItem (
inprepid  integer  primary key ,     /*id*/
mailid integer ,
inprepname    varchar2(200) ,
inpreptablename       varchar2(60) 
)
/

create sequence T_SurveyItem_inprepid
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger T_SurveyItem_Trigger
before insert on T_SurveyItem
for each row
begin
select T_SurveyItem_inprepid.nextval into :new.inprepid from dual;
end;

/


/*建立存放字段的表*/

CREATE TABLE T_fieldItem (
	 itemid   integer   NOT NULL ,
	 inprepid   integer  NULL ,
	 itemdspname   varchar2  (60)  NULL ,
	 itemfieldname   varchar2  (60)  NULL ,
	 itemfieldtype   char  (1)  NULL ,
	 itemfieldscale   integer  NULL ,
	 itemfieldunit   varchar2  (60)  NULL 
)
/

create sequence T_fieldItem_itemid
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger T_fieldItem_Trigger
before insert on T_fieldItem
for each row
begin
select T_fieldItem_itemid.nextval into :new.itemid from dual;
end;
/


/*可选项的值表*/

create table T_fieldItemDetail (
inprepitemdetailid  integer  primary key ,     /*id*/
itemid       integer ,
itemdsp      varchar2(100) ,
itemvalue    varchar2(100)
)
/

create sequence T_fieldItemDetail_inprepitem
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger T_fieldItemDetail_Trigger
before insert on T_fieldItemDetail
for each row
begin
select T_fieldItemDetail_inprepitem.nextval into :new.inprepitemdetailid from dual;
end;
/


/*建立退订表*/

create table T_FadeBespeak (
id integer  NOT NULL ,
crmid integer NULL ,           /*客户ID*/
inprepid integer NULL ,        /*调查种类的ID*/
contacterid integer NULL ,    /*退订人的ID*/
inputid integer NULL ,       /*调查ID*/
referdate char(10)  NULL           /*提交日期*/
)
/


create sequence T_FadeBespeak_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger T_FadeBespeak_Trigger
before insert on T_FadeBespeak
for each row
begin
select T_FadeBespeak_id.nextval into :new.id from dual;
end;
/

/*建立总表*/

create table T_InceptForm  (
id integer  NOT NULL ,
inputid integer NULL ,/*调查ID*/
crmid integer NULL ,/*客户ID*/
contacterid integer NULL ,/*联系人的ID*/
email varchar2  (60)  NULL ,/*客户的email地址*/
state char(10) NULL /*状态*/
)
/


create sequence T_InceptForm_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger T_InceptForm_Trigger
before insert on T_InceptForm
for each row
begin
select T_InceptForm_id.nextval into :new.id from dual;
end;
/

/*调查表*/

create table T_ResearchTable (
inputid integer  NOT NULL ,
inprepid integer NULL,/*调查种类的ID*/
rsearchname varchar2  (60)  NULL ,/*调查名称*/
rsearchdate char(10) NULL ,/*调查发布日期*/
countfrom integer NULL ,/*应提交的总客户*/
countemial integer NULL,/*邮件发送成功的总客户*/
fromcount integer NULL,/*实际提交的总客户*/
countfade integer NULL, /*退订的总客户*/
state integer NULL/*有无联系人*/
)
/

create sequence T_ResearchTable_inputid
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger T_ResearchTable_Trigger
before insert on T_ResearchTable
for each row
begin
select T_ResearchTable_inputid.nextval into :new.inputid from dual;
end;
/



/*显示*/

create or replace  PROCEDURE T_SurveyItem_SelectAll
	(flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)
AS 
     begin
     open thecursor for 
select * from T_SurveyItem;
close thecursor;
     end;
/



/*建立调查项目*/

create or replace PROCEDURE T_SurveyItem_Insert 
	(mailid_2 integer ,
	 inprepname_3	 varchar2 ,
	 inpreptablename_4 	 varchar2 ,
	flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO  T_SurveyItem  
	 (mailid,
	  inprepname ,
	  inpreptablename)
 
VALUES 
	(mailid_2 ,
	 inprepname_3 ,
	 inpreptablename_4);
end;
/


/*显示字段表*/

create or replace PROCEDURE T_fieldItem_SelectByItemtypeid
	(inprepid_1  integer ,
	 flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for 
select * from T_fieldItem where inprepid = inprepid_1 order by itemid;
close thecursor;
end;
/


/*显示调查项目*/

create or replace PROCEDURE T_SurveyItem_SelectByInprepid
	(inprepid_1  integer ,
	flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for 
select * from T_SurveyItem where inprepid =inprepid_1;
close thecursor;
end;
/


/*显示*/

create or replace PROCEDURE T_fieldItem_SelectByItemid
	(itemid_1  integer ,
	flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
begin
open thecursor for 
select * from T_fieldItem where itemid =itemid_1;
close thecursor;
end;
/


/*建立字段表存储过程*/

create or replace PROCEDURE  T_fieldItem_Insert 
	(inprepid_2   integer ,
	 itemdspname_3   varchar2   ,
	 itemfieldname_4   varchar2   ,
	 itemfieldtype_5   char    ,
	 itemfieldscale_6   integer   ,
	 itemfieldunit_7  varchar2 ,
	 flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)
	

AS
begin
INSERT INTO  T_fieldItem  
	( inprepid ,
	  itemdspname ,
	  itemfieldname ,
	  itemfieldtype ,
	  itemfieldscale ,
	  itemfieldunit
	 ) 
 
VALUES 
	(inprepid_2,
	 itemdspname_3,
	 itemfieldname_4,
	 itemfieldtype_5,
	 itemfieldscale_6,
	 itemfieldunit_7
	 );
end;
/



/*显示*/

create or replace PROCEDURE T_fieldItemDetail_Itemid
	(itemid_1  integer ,
	 flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for
select * from T_fieldItemDetail where itemid = itemid_1;
close thecursor;
end;
/


/*修改字段表*/

create or replace PROCEDURE  T_fieldItem_Update 
	(itemid_1 	 integer ,
	 inprepid_2   integer ,
	 itemdspname_3   varchar2 ,
	 itemfieldname_4   varchar2   ,
	 itemfieldtype_5   char   ,
	 itemfieldscale_6   integer   ,
	 itemfieldunit_7 varchar2  ,
	 flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE  T_fieldItem  
SET       inprepid = inprepid_2 ,  
          itemdspname  = itemdspname_3 ,
	  itemfieldname = itemfieldname_4 ,
	  itemfieldtype = itemfieldtype_5 ,
	  itemfieldscale = itemfieldscale_6 ,
          itemfieldunit  = itemfieldunit_7 
WHERE 
	itemid =  itemid_1 ;
end;
/



/*删除*/

create or replace PROCEDURE  T_fieldItemDetail_Delete 
	(itemid_1 	 int  ,
	flag out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
DELETE  T_fieldItemDetail  
WHERE 
	 itemid = itemid_1;
end;
/


/*添加*/

create or replace PROCEDURE  T_fieldItemDetail_Insert 
	(itemid_1 	 integer ,
	 itemdsp_2 	 varchar2,
	 itemvalue_3 	 varchar2 ,
	 flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO  T_fieldItemDetail  
	 (itemid ,
	  itemdsp ,
	  itemvalue ) 
 VALUES 
	(itemid_1,
	 itemdsp_2,
	 itemvalue_3);
end;
/


/*删除*/

create or replace PROCEDURE  T_fieldItem_Delete 
	(itemid_1 	 integer,
	 flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
 begin
 DELETE T_fieldItem  WHERE itemid = itemid_1;
 end;
/


/*修改调查项目表*/

create or replace PROCEDURE  T_SurveyItem_Update 
	(inprepid_1 	 integer ,
	 mailid_2 integer,
	 inprepname_3 	 varchar2,
	 inpreptablename_4 	 varchar2,
	 flag out integer,
     msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE  T_SurveyItem  SET 
mailid    =   mailid_2,
inprepname 	 = inprepname_3 ,
inpreptablename 	 = inpreptablename_4
WHERE 
	 inprepid = inprepid_1;
end;
/


/*显示*/

create or replace PROCEDURE T_fieldItem_SelectByInprepid
	(inprepid_1  integer ,
	 flag out integer,
         msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for 
select * from T_fieldItem where inprepid = inprepid_1;
close thecursor;
end;
/


/*删除*/

CREATE or REPLACE PROCEDURE  T_SurveyItem_Delete 
	(inprepid_1 	 integer ,
	 flag out integer,
         msg out varchar2,
         thecursor IN OUT cursor_define.weavercursor)

AS
begin
DELETE  T_SurveyItem  
WHERE 
	 inprepid 	 = inprepid_1;
end;
/


/*建立退订的存储过程*/

CREATE or REPLACE  PROCEDURE T_FadeBespeak_Insert 
	(crmid_2   integer ,
	 inprepid_3   integer,
	 contacterid_4	 integer ,
	 inputid_5   integer ,
	 date_6   char,
	 flag out   integer,
         msg out   varchar2,
         thecursor IN OUT cursor_define.weavercursor)

AS 
begin
insert into  T_FadeBespeak  
	 (crmid,
	  inprepid,
	  contacterid ,
	  inputid ,
	  referdate)
values 
	(crmid_2 ,
	 inprepid_3 ,
	 contacterid_4 ,
	 inputid_5 ,
	 date_6 );
end;
/
update CRM_CustomizeOption set fieldname='fullname' where id=203
/
INSERT INTO CRM_CustomizeOption (id,tabledesc,fieldname,labelid,labelname) values (213,2,'customerid',144,'客户名称')
/


/*以下是陈英杰招聘管理中学历以及应聘人员搜索修改提交测试报告的脚本*/

alter table HrmResource 
  modify ( educationlevel integer)
/

alter table HrmCareerApply
  modify (educationlevel integer)
/

alter table HrmEducationInfo
  modify (educationlevel integer)
/

alter table HrmCareerApplyOtherInfo
  modify (salarynow integer)
/


CREATE or REPLACE PROCEDURE HrmResourcePersonalInfo_Insert 
( id_1 integer, 
  birthday_2 char , 
  folk_3 varchar2 , 
  nativeplace_4 varchar2 , 
  regresidentplace_5 varchar2 , 
  maritalstatus_6 char , 
  policy_7 varchar2 ,
  bememberdate_8 char , 
  bepartydate_9 char , 
  islabouunion_10 char , 
  educationlevel_11 integer , 
  degree_12 varchar2 , 
  healthinfo_13  char , 
  height_14 integer , 
  weight_15 integer , 
  residentplace_16 varchar2, 
  homeaddress_17 varchar2, 
  tempresidentnumber_18 varchar2, 
  certificatenum_19 varchar2, 
  flag out   integer,
         msg out   varchar2,
         thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE HrmResource SET 
  birthday = birthday_2, 
  folk = folk_3, 
  nativeplace =nativeplace_4, 
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
  homeaddress = homeaddress_17, 
  tempresidentnumber = tempresidentnumber_18, 
  certificatenum = certificatenum_19 
WHERE 
  id = id_1;
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
  educationlevel_11 integer, 
  degree_12 varchar2, 
  healthinfo_13  char, 
  height_14 integer,
  weight_15 integer, 
  residentplace_16 varchar2, 
  tempresidentnumber_18 varchar2, 
  certificatenum_19 varchar2,
  flag out   integer,
         msg out   varchar2,
         thecursor IN OUT cursor_define.weavercursor)
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


CREATE or REPLACE  PROCEDURE HrmEducationInfo_Insert
(resourceid_1 	integer, 
 startdate_2 	char, 
 enddate_3 	char, 
 school_4 	varchar2, 
 speciality_5 	varchar2 , 
 educationlevel_6 	integer, 
 studydesc_7 	varchar2, 
 flag out   integer,
         msg out   varchar2,
         thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmEducationInfo 
( resourceid, 
  startdate, 
  enddate, 
  school, 
  speciality, 
  educationlevel, 
  studydesc) 
VALUES 
( resourceid_1, 
  startdate_2, 
  enddate_3, 
  school_4, 
  speciality_5, 
  educationlevel_6 , 
  studydesc_7);
end;
/




/*关于任舸2003-06-30的《e-cology项目邮件模板定义及群发提交测试报告V1.0 》提交测试报告的脚本*/

alter table T_SurveyItem add urlname   varchar2(200)
/


CREATE or REPLACE PROCEDURE T_SurveyItem_Insert 
	(mailid_2 integer ,
	 inprepname_3	 varchar2,
	 inpreptablename_4 	 varchar2,
	 urlname_5    varchar2,
	 flag out   integer,
         msg out   varchar2,
         thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO  T_SurveyItem  
	 (mailid,
	  inprepname ,
	  inpreptablename,
	  urlname)
 
VALUES 
	(mailid_2 ,
	 inprepname_3 ,
	 inpreptablename_4,
	 urlname_5);
end;
/

CREATE or REPLACE PROCEDURE  T_SurveyItem_Update 
	(inprepid_1 	 integer ,
	 mailid_2 integer,
	 inprepname_3 	 varchar2,
	 inpreptablename_4 	 varchar2,
	 urlname_5    varchar2,
	 flag out   integer,
         msg out   varchar2,
         thecursor IN OUT cursor_define.weavercursor)

AS 
begin
UPDATE  T_SurveyItem  
SET       
mailid  = mailid_2 ,
inprepname 	 = inprepname_3 ,
inpreptablename = inpreptablename_4,
urlname  = urlname_5
WHERE 
	inprepid = inprepid_1;
end;
/



/*关于刘煜2003-06-30的《Ecology产品开发-系统工作流优化V1.0提交测试报告》的脚本*/

create  INDEX wrkcuoper_requestid_in on workflow_currentoperator(requestid)
/

create  INDEX wrkcuoper_user_in on workflow_currentoperator(userid,usertype) 
/

create  INDEX wrkreqlog_request_in on workflow_requestLog(requestid,logtype)
/

create  INDEX wrkreqview_request_in on workflow_requestViewLog(id,currentnodeid)
/

create  INDEX wrkreqbase_request_in on workflow_requestbase(workflowid,requestid) 
/

create  INDEX wrkform_request_in on workflow_form(requestid,billid)
/

create  INDEX wrkfieldlable_form_in on workflow_fieldlable(formid,fieldid)
/