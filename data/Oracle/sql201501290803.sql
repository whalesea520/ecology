create table meeting_remind_type(
  id int ,
	name VARCHAR(100),
	label int,
	hastitle char(1),
	clazzname varchar(200)
)
/
INSERT into meeting_remind_type (id,name,label,hastitle,clazzname) VALUES(2,'短信提醒',17586,'0','weaver.meeting.remind.RemindSms')
/
INSERT into meeting_remind_type (id,name,label,hastitle,clazzname) VALUES(3,'邮件提醒',18845,'1','weaver.meeting.remind.RemindMail')
/
INSERT into meeting_remind_type (id,name,label,hastitle,clazzname) VALUES(5,'微信提醒',32812,'0','weaver.meeting.remind.RemindWechat')
/

create table meeting_week_type(
  id int ,
	name VARCHAR(100),
	label int
)
/
INSERT into meeting_week_type (id,name,label) VALUES(1,'周一',16100)
/
INSERT into meeting_week_type (id,name,label) VALUES(2,'周二',16101)
/
INSERT into meeting_week_type (id,name,label) VALUES(3,'周三',16102)
/
INSERT into meeting_week_type (id,name,label) VALUES(4,'周四',16103)
/
INSERT into meeting_week_type (id,name,label) VALUES(5,'周五',16104)
/
INSERT into meeting_week_type (id,name,label) VALUES(6,'周六',16105)
/
INSERT into meeting_week_type (id,name,label) VALUES(7,'周日',16106)
/

create table meeting_remind_mode(
type varchar(100),
name varchar(100)
)
/
INSERT into meeting_remind_mode (type,name) VALUES('create','创建会议')
/
INSERT into meeting_remind_mode (type,name) VALUES('cancel','取消会议')
/
INSERT into meeting_remind_mode (type,name) VALUES('start','开始前提醒')
/
INSERT into meeting_remind_mode (type,name) VALUES('end','结束前提醒')
/

create table Meeting_Service_Type(
id int NOT NULL primary key ,
name VARCHAR(255),
desc_n varchar(255)
)
/
create sequence Meeting_Service_Type_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Meeting_Service_Type_Tr before insert on Meeting_Service_Type for each row 
begin select Meeting_Service_Type_ID.nextval into :new.id from dual; end;
/
create table Meeting_Service_Item(
id int NOT NULL primary key ,
type int,
itemname VARCHAR(255)
)
/
create sequence Meeting_Service_Item_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Meeting_Service_Item_Tr before insert on Meeting_Service_Item for each row 
begin select Meeting_Service_Item_ID.nextval into :new.id from dual; end;
/

create table Meeting_Service_New(
id int NOT NULL primary key ,
meetingid	int not null,
items varchar(1000),
hrmids VARCHAR(255),
otheritem varchar(255)
)
/
create sequence Meeting_Service_New_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Meeting_Service_New_Tr before insert on Meeting_Service_New for each row 
begin select Meeting_Service_New_ID.nextval into :new.id from dual; end;
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) 
VALUES ( 268,81911,'varchar(20)','/systeminfo/BrowserMain.jsp?url=/meeting/multiWeek.jsp?selectedids=','meeting_week_type','name','id','')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) 
VALUES ( 269,81916,'varchar(100)','/systeminfo/BrowserMain.jsp?url=/meeting/multiRemideType.jsp?selectedids=','meeting_remind_type','name','id','')
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) 
VALUES ( 270,2157,'varchar(1000)','/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingServiceItemBrowser.jsp?resourceids=','Meeting_Service_Item','itemname','id','')
/

alter table meeting add remindTypeNew varchar(100)
/
alter table meeting add remindImmediately char(1)
/
alter table meeting add remindHoursBeforeStart int
/
alter table meeting add remindHoursBeforeEnd int
/
alter table meeting add hrmmembers varchar2(4000)
/
alter table meeting add crmmembers varchar2(4000)
/
alter table meeting add crmtotalmember int
/
update meeting set remindTypeNew=remindType where remindType<>1
/
update meeting set remindHoursBeforeStart=trunc(remindTimesBeforeStart/60)
/
update meeting set remindTimesBeforeStart=mod(remindTimesBeforeStart,60)
/
update meeting set remindHoursBeforeEnd=trunc(remindTimesBeforeEnd/60)
/
update meeting set remindTimesBeforeEnd=mod(remindTimesBeforeStart,60)
/

create table meeting_defined (
   scopeid           int    primary key,
   base_datatable    varchar(255)     not null,
   tablelabel   int     null,
   isdetail		int,
   dsporder		int
)
/
INSERT INTO meeting_defined (scopeid, base_datatable,tablelabel,isdetail,dsporder)
VALUES(1,'meeting',24249,0,1)
/
INSERT INTO meeting_defined (scopeid, base_datatable,tablelabel,isdetail,dsporder)
VALUES(2,'Meeting_Topic',31327,1,2)
/
INSERT INTO meeting_defined (scopeid, base_datatable,tablelabel,isdetail,dsporder)
VALUES(3,'Meeting_Service_New',2107,1,3)
/

create table meeting_fieldgroup (
   id                   int      primary key           not null,
   grouplabel           int                  null,
   grouporder           int                  null,
   grouptype            int                  null
)
/
create sequence meeting_fieldgroup_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger meeting_fieldgroup_Tr before insert on meeting_fieldgroup for each row 
begin select meeting_fieldgroup_ID.nextval into :new.id from dual; end;
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(1361,1,1)
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(81901,2,1)
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(81902,3,1)
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(16169,4,1)
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(1361,1,2)
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(1361,1,3)
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(1361,1,4)
/
INSERT INTO meeting_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(1361,1,5)
/



CREATE TABLE meeting_SelectItem (
id int NOT NULL primary key ,
fieldid int NOT NULL ,
selectvalue int NOT NULL ,
selectname varchar(250) NULL ,
selectlabel varchar(250) NULL ,
listorder int NOT NULL ,
isdel int  DEFAULT ((0)) NULL,
isdefault char(1)  NULL 
)
/
create sequence meeting_SelectItem_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger meeting_SelectItem_Tr before insert on meeting_SelectItem for each row 
begin select meeting_SelectItem_ID.nextval into :new.id from dual; end;
/
INSERT INTO meeting_SelectItem(fieldid,selectvalue,selectname,selectlabel,listorder,isdefault)
values(8,1,'按天重复',25895,1,'y')
/
INSERT INTO meeting_SelectItem(fieldid,selectvalue,selectname,selectlabel,listorder)
values(8,2,'按周重复',25896,2)
/
INSERT INTO meeting_SelectItem(fieldid,selectvalue,selectname,selectlabel,listorder)
values(8,3,'按月重复',25897,3)
/
INSERT INTO meeting_SelectItem(fieldid,selectvalue,selectname,selectlabel,listorder,isdefault)
values(14,0,'非工作日时：日期不变','81929',1,'y')
/
INSERT INTO meeting_SelectItem(fieldid,selectvalue,selectname,selectlabel,listorder)
values(14,1,'非工作日时：推迟到下一工作日','81930',2)
/
INSERT INTO meeting_SelectItem(fieldid,selectvalue,selectname,selectlabel,listorder)
values(14,2,'非工作日时：取消会议','81931',3)
/




create table meeting_formfield (
   fieldid              int       PRIMARY KEY NOT null,
   fielddbtype          varchar(40)          null,
   fieldname            varchar(30)          null,
   sysfieldlabel        VARCHAR(100)         null,
   fieldlabel           VARCHAR(100)         null,
   fieldhtmltype        char(1)              null,
   type                 int                  null,
   fieldorder           int                  null,
   ismand               char(1)              null,
   isuse                char(1)              null,
   groupid              int                  null,
   grouptype		int			default((1)),
   allowhide            int                  null,
   issystem		int		     null,
   isrepeat		int		     null
)
/

INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 1,'meetingtype',2104,2104,'int',3,89,1,1,1,1,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 2,'name',2151,2151,'varchar(255)',1,1,1,1,1,1,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 3,'caller',2152,2152,'int',3,1,1,1,1,1,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 4,'contacter',572,572,'int',3,1,1,1,1,1,1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 5,'address',2105,2105,'int',3,87,1,1,1,1,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 6,'customizeAddress',20392,20392,'varchar(400)',1,1,1,1,1,1,1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 7,'desc_n',22462,22462,'varchar(4000)',2,1,1,0,1,1,1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 8,'repeatType',25894,25894,'int',5,1,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 9,'repeatdays',32579,32579,'int',1,2,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 10,'repeatweeks',32580,32580,'int',1,2,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 11,'rptWeekDays',32582 ,32582 ,'varchar(20)',3,268,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 12,'repeatmonths',32581,32581,'int',1,2,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 13,'repeatmonthdays',32583,32583,'int',1,2,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 14,'repeatStrategy',33018,33018,'int',5,1,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 15,'repeatbegindate',25902,25902,'char(10)',3,2,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 16,'repeatenddate',25903,25903,'char(10)',3,2,1,1,1,2,-1,1,1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 17,'begindate',740,740,'char(10)',3,2,1,1,1,2,-1,1,0)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 18,'begintime',742,742,'char(8)',3,19,1,1,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 19,'enddate',741,741,'char(10)',3,2,1,1,1,2,-1,1,0)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 20,'endtime',743,743,'char(8)',3,19,1,1,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 21,'remindTypeNew',18713,18713,'varchar(100)',3,269,1,0,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 22,'remindImmediately',81917,81917,'char(1)',4,1,1,0,1,2,-1,1,0)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 23,'remindBeforeStart',23807,23807,'int',4,1,1,0,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 24,'remindBeforeEnd',23806,23806,'int',4,1,1,0,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 25,'remindHoursBeforeStart',81918,81918,'int',1,2,1,0,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 26,'remindTimesBeforeStart',81919,81919,'int',1,2,1,0,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 27,'remindHoursBeforeEnd',81920,81920,'int',1,2,1,0,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 28,'remindTimesBeforeEnd',81921,81921,'int',1,2,1,0,1,2,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 29,'hrmmembers',2106,2106,'varchar2(4000)',3,17,1,1,1,3,-1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 30,'othermembers',2168,2168,'varchar(255)',1,1,1,0,1,3,1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 31,'totalmember',2166,2166,'int',1,2,1,0,1,3,1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 32,'crmmembers',2167,2167,'varchar2(4000)',3,18,1,0,1,3,1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 33,'crmtotalmember',32591,32591,'int',1,2,1,0,1,3,1,1,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 34,'projectid',782,782,'int',3,8,1,0,1,4,1,0,-1)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,isrepeat)
VALUES  ( 35,'accessorys',22194,22194,'varchar(2000)',6,1,1,0,1,4,1,0,-1)
/


INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 41,'subject',344,344,'varchar(255)',1,1,1,1,1,5,-1,1,2)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 42,'hrmids',2097,2097,'varchar(255)',3,17,1,1,1,5,-1,1,2)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 43,'projid',782,782,'int',3,8,1,0,1,5,1,1,2)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 44,'crmids',783,783,'varchar(4000)',3,18,1,0,1,5,1,1,2)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 45,'isopen',2161,2161,'tinyint',4,1,1,0,1,5,-1,1,2)
/

INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 46,'items',2157,2157,'varchar(255)',3,270,1,1,1,6,-1,1,3)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 47,'hrmids',2097,2097,'varchar(255)',3,17,1,1,1,6,-1,1,3)
/
INSERT INTO meeting_formfield(fieldid,fieldname ,sysfieldlabel,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide,issystem,grouptype)
VALUES  ( 48,'otheritem',81936,81936,'varchar(255)',1,1,1,0,1,6,1,1,3)
/


CREATE TABLE meeting_remind_template  (
id int NOT NULL primary key ,
type int NOT NULL ,
desc_n varchar(1000) NULL ,
title varchar(1000) NULL ,
body varchar(2000) NULL ,
modetype VARCHAR(100)
)
/
create sequence meeting_remind_template_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger meeting_remind_template_Tr before insert on meeting_remind_template for each row 
begin select meeting_remind_template_ID.nextval into :new.id from dual; end;
/
INSERT INTO meeting_remind_template(type,desc_n,title,body,modetype)
values(2,'','','您有会议#[name]，于#[begindate] #[begintime]在#[address]召开,请提前10分钟入场！','create')
/
INSERT INTO meeting_remind_template(type,desc_n,title,body,modetype)
values(3,'','会议提醒-#[name]','您有会议#[name]。会议时间:#[begindate] #[begintime]至#[enddate] #[endtime]。会议地点:#[address],请提前10分钟入场！','create')
/
INSERT INTO meeting_remind_template(type,desc_n,title,body,modetype)
values(5,'','','您有会议#[name]，于#[begindate] #[begintime]在#[address]召开,请提前10分钟入场！','create')
/
INSERT INTO meeting_remind_template(type,desc_n,title,body,modetype)
values(2,'','','您好，于#[begindate] #[begintime]召开的会议#[name]，已经取消，请知晓！','cancel')
/
INSERT INTO meeting_remind_template(type,desc_n,title,body,modetype)
values(3,'','取消会议提醒-#[name]','您好，于#[begindate] #[begintime]召开的会议#[name]，已经取消，请知晓！','cancel')
/
INSERT INTO meeting_remind_template(type,desc_n,title,body,modetype)
values(5,'','','您好，于#[begindate] #[begintime]召开的会议#[name]，已经取消，请知晓！','cancel')
/

CREATE TABLE meeting_remind  (
id int NOT NULL primary key ,
meeting int NOT NULL ,
remindTime varchar(20),
modetype VARCHAR(100)
)
/
create sequence meeting_remind_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger meeting_remind_Tr before insert on meeting_remind for each row 
begin select meeting_remind_ID.nextval into :new.id from dual; end;
/

create table meeting_docshare(
meetingid int,
docid int,
type int,
discussId int
)
/
create table meeting_bill(
billid int,
defined int,
tablename VARCHAR(100)
)
/
INSERT into meeting_bill values(85,1,'Bill_Meeting')
/
INSERT into meeting_bill values(85,2,'Bill_Meeting_dt1_Topic')
/
INSERT into meeting_bill values(85,3,'Bill_Meeting_dt2_Service')
/

create table meeting_wf_relation(
defined int,
fieldid int,
fieldname  varchar(30),
billid int,
bill_fieldname varchar(60)
)
/
INSERT INTO meeting_wf_relation VALUES (1, 24, 'remindBeforeEnd', 85, 'remindBeforeEnd')
/
INSERT INTO meeting_wf_relation VALUES (1, 25, 'remindHoursBeforeStart', 85, 'remindHoursBeforeStart')
/
INSERT INTO meeting_wf_relation VALUES (1, 26, 'remindTimesBeforeStart', 85, 'remindTimesBeforeStart')
/
INSERT INTO meeting_wf_relation VALUES (1, 27, 'remindHoursBeforeEnd', 85, 'remindHoursBeforeEnd')
/
INSERT INTO meeting_wf_relation VALUES (1, 28, 'remindTimesBeforeEnd', 85, 'remindTimesBeforeEnd')
/
INSERT INTO meeting_wf_relation VALUES (1, 29, 'hrmmembers', 85, 'resources')
/
INSERT INTO meeting_wf_relation VALUES (3, 46, 'items', 85, 'items')
/
INSERT INTO meeting_wf_relation VALUES (3, 47, 'hrmids', 85, 'hrmids')
/
INSERT INTO meeting_wf_relation VALUES (3, 48, 'otheritem', 85, 'otheritem')
/
INSERT INTO meeting_wf_relation VALUES (2, 41, 'subject', 85, 'subject')
/
INSERT INTO meeting_wf_relation VALUES (1, 30, 'othermembers', 85, 'others')
/
INSERT INTO meeting_wf_relation VALUES (1, 10, 'repeatweeks', 85, 'repeatweeks')
/
INSERT INTO meeting_wf_relation VALUES (1, 11, 'rptWeekDays', 85, 'rptWeekDays')
/
INSERT INTO meeting_wf_relation VALUES (1, 12, 'repeatmonths', 85, 'repeatmonths')
/
INSERT INTO meeting_wf_relation VALUES (1, 13, 'repeatmonthdays', 85, 'repeatmonthdays')
/
INSERT INTO meeting_wf_relation VALUES (1, 14, 'repeatStrategy', 85, 'repeatType')
/
INSERT INTO meeting_wf_relation VALUES (1, 15, 'repeatbegindate', 85, 'BeginDate')
/
INSERT INTO meeting_wf_relation VALUES (1, 16, 'repeatenddate', 85, 'EndDate')
/
INSERT INTO meeting_wf_relation VALUES (1, 17, 'begindate', 85, 'BeginDate')
/
INSERT INTO meeting_wf_relation VALUES (1, 18, 'begintime', 85, 'BeginTime')
/
INSERT INTO meeting_wf_relation VALUES (1, 19, 'enddate', 85, 'EndDate')
/
INSERT INTO meeting_wf_relation VALUES (1, 35, 'accessorys', 85, 'accessorys')
/
INSERT INTO meeting_wf_relation VALUES (1, 31, 'totalmember', 85, 'resourcenum')
/
INSERT INTO meeting_wf_relation VALUES (1, 32, 'crmmembers', 85, 'crms')
/
INSERT INTO meeting_wf_relation VALUES (1, 33, 'crmtotalmember', 85, 'crmsNumber')
/
INSERT INTO meeting_wf_relation VALUES (1, 34, 'projectid', 85, 'projectid')
/
INSERT INTO meeting_wf_relation VALUES (2, 42, 'hrmids', 85, 'hrmids')
/
INSERT INTO meeting_wf_relation VALUES (2, 43, 'projid', 85, 'projid')
/
INSERT INTO meeting_wf_relation VALUES (2, 44, 'crmids', 85, 'crmids')
/
INSERT INTO meeting_wf_relation VALUES (2, 45, 'isopen', 85, 'isopen')
/
INSERT INTO meeting_wf_relation VALUES (1, 1, 'meetingtype', 85, 'MeetingType')
/
INSERT INTO meeting_wf_relation VALUES (1, 2, 'name', 85, 'MeetingName')
/
INSERT INTO meeting_wf_relation VALUES (1, 3, 'caller', 85, 'Caller')
/
INSERT INTO meeting_wf_relation VALUES (1, 4, 'contacter', 85, 'Contacter')
/
INSERT INTO meeting_wf_relation VALUES (1, 5, 'address', 85, 'Address')
/
INSERT INTO meeting_wf_relation VALUES (1, 6, 'customizeAddress', 85, 'customizeAddress')
/
INSERT INTO meeting_wf_relation VALUES (1, 7, 'desc_n', 85, 'description')
/
INSERT INTO meeting_wf_relation VALUES (1, 8, 'repeatType', 85, 'repeatType')
/
INSERT INTO meeting_wf_relation VALUES (1, 9, 'repeatdays', 85, 'repeatdays')
/
INSERT INTO meeting_wf_relation VALUES (1, 20, 'endtime', 85, 'EndTime')
/
INSERT INTO meeting_wf_relation VALUES (1, 21, 'remindTypeNew', 85, 'remindTypeNew')
/
INSERT INTO meeting_wf_relation VALUES (1, 22, 'remindImmediately', 85, 'remindImmediately')
/
INSERT INTO meeting_wf_relation VALUES (1, 23, 'remindBeforeStart', 85, 'remindBeforeStart')
/


create table Bill_Meeting_dt1_Topic
(
  id      int NOT NULL primary key ,
  mainid  int,
  subject VARCHAR(255),
  hrmids  VARCHAR(255),
  projid  int,
  crmids  VARCHAR(4000),
  isopen  int
)
/
create sequence Bill_Meeting_dt1_Topic_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Bill_Meeting_dt1_Topic_Tr before insert on Bill_Meeting_dt1_Topic for each row 
begin select Bill_Meeting_dt1_Topic_ID.nextval into :new.id from dual; end;
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'subject', 344, 'varchar(255)', '1', 1, 1, 'Bill_Meeting_dt1_Topic', '1', 1.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'hrmids', 2097, 'varchar(255)', '3', 17, 1, 'Bill_Meeting_dt1_Topic', '1', 2.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'projid', 782, 'int', '3', 8, 1, 'Bill_Meeting_dt1_Topic', '1', 3.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'crmids', 783, 'varchar(4000)', '3', 18, 1, 'Bill_Meeting_dt1_Topic', '1', 4.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'isopen', 2161, 'tinyint', '4', 1, 1, 'Bill_Meeting_dt1_Topic', '1', 5.00)
/

create table Bill_Meeting_dt2_Service(
id int NOT NULL primary key ,
mainid  int,
items varchar(2000),
hrmids VARCHAR(255),
otheritem varchar(2000)
)
/
create sequence Bill_Meeting_dt2_Service_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger Bill_Meeting_dt2_Service_Tr before insert on Bill_Meeting_dt2_Service for each row 
begin select Bill_Meeting_dt2_Service_ID.nextval into :new.id from dual; end;
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'items', 2157, 'varchar(2000)', '3', 270, 1, 'Bill_Meeting_dt2_Service', '1', 1.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'hrmids', 2097, 'varchar(255)', '3', 17, 1, 'Bill_Meeting_dt2_Service', '1', 2.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'otheritem', 81936, 'varchar(2000)', '1', 1, 1, 'Bill_Meeting_dt2_Service', '1', 3.00)
/


update workflow_bill set detailkeyfield = 'mainid' where id = 85
/
insert into Workflow_billdetailtable(billid,tablename,orderid) values(85,'Bill_Meeting_dt1_Topic',1)
/
insert into Workflow_billdetailtable(billid,tablename,orderid) values(85,'Bill_Meeting_dt2_Service',2)
/

alter table bill_meeting add remindTypeNew varchar(100)
/
alter table bill_meeting add remindImmediately char(1)
/
alter table bill_meeting add remindHoursBeforeStart int
/
alter table bill_meeting add remindHoursBeforeEnd int
/
alter table Bill_Meeting add accessorys varchar(2000)
/

update bill_meeting set remindTypeNew=remindType where remindType<>1
/
update bill_meeting set remindHoursBeforeStart=trunc(remindTimesBeforeStart/60)
/
update bill_meeting set remindTimesBeforeStart=mod(remindTimesBeforeStart,60)
/
update bill_meeting set remindHoursBeforeEnd=trunc(remindTimesBeforeEnd/60)
/
update bill_meeting set remindTimesBeforeEnd=mod(remindTimesBeforeEnd,60)
/


update workflow_billfield set fieldhtmltype=4 , type=4 ,fielddbtype='char(1)' where billid=85 and (fieldname='remindBeforeStart' or fieldname='remindBeforeEnd')
/
update workflow_billfield set fieldhtmltype=3 , type=268 where billid=85 and fieldname='rptWeekDays' 
/
update workflow_billfield set type=2,fieldlabel=81919 where billid=85 and fieldname='remindTimesBeforeStart' 
/
update workflow_billfield set type=2,fieldlabel=81921 where billid=85 and fieldname='remindTimesBeforeEnd'
/
delete from workflow_billfield  where billid=85 and fieldname='remindType'
/

insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'remindTypeNew', 18713, 'varchar(100)', '3', 269, 0, '', '1', 37.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'remindImmediately', 81917, 'char(1)', '4', 1, 0, '', '1', 37.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'remindHoursBeforeStart', 81918, 'int', '1', 2, 0, '', '1', 37.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'remindHoursBeforeEnd', 81920, 'int', '1', 2, 0, '', '1', 37.00)
/
insert into workflow_billfield (BILLID, FIELDNAME, FIELDLABEL, FIELDDBTYPE, FIELDHTMLTYPE, TYPE, VIEWTYPE, DETAILTABLE, FROMUSER,DSPORDER)
values ( 85, 'accessorys', 22194, 'varchar(2000)', '6', 1, 0, '', '1', 37.00)
/

alter table Meeting_Type add approver1 int
/
update Meeting_Type set approver1=approver
/