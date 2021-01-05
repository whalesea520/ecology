alter table HrmScheduleMaintance add
  totalday integer default(0)
/

alter table HrmScheduleMaintance add
  totaltime varchar2(10)
/

create table HrmResourceRpDefine
(id integer not null,
resourceid integer not null,
colname varchar2(30) null,
showorder integer default(0),
header varchar2(60) null)
/
create sequence HrmResourceRpDefine_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmResourceRpDefine_Trigger
before insert on HrmResourceRpDefine
for each row
begin
select HrmResourceRpDefine_id.nextval into :new.id from dual;
end;
/

alter table HrmCareerApplyOtherInfo modify( salaryneed integer   )
/

alter table HrmCareerApplyOtherInfo modify ( salarynow integer  )
/

alter table HrmCareerApplyOtherInfo modify  (worktime integer   )
/

CREATE OR REPLACE PROCEDURE HrmScheduleTotalTime
(id_1 integer,
totaltime_2 varchar2,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
update HrmScheduleMaintance set
 totaltime = totaltime_2
where 
 id= id_1;
end;
/

CREATE OR REPLACE PROCEDURE HrmScheduleMain_Insert
	(
    diffid_1 	integer,
    resourceid_2 	integer,
    startdate_3 	char,
    starttime_4 	char,
    enddate_5 	char,
    endtime_6 	char,
    memo_7 	varchar2,
    createtype_8 	integer,
    createrid_9 	integer,
    createdate_10 	char,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
)
AS
begin
INSERT INTO HrmScheduleMaintance 
	 ( diffid,
	 resourceid,
	 startdate,
	 starttime,
	 enddate,
	 endtime,
	 memo,
	 createtype,
	 createrid,
	 createdate) 
 
VALUES 
	( diffid_1,
	 resourceid_2,
	 startdate_3,
	 starttime_4,
	 enddate_5,
	 endtime_6,
	 memo_7,
	 createtype_8,
	 createrid_9,
	 createdate_10);
open thecursor for
select max(id) from HrmScheduleMaintance;
end;
/


CREATE OR REPLACE PROCEDURE HrmScheduleTotalDay
(id_1 integer,
totalday_2 varchar2,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
update HrmScheduleMaintance set
 totalday = totalday_2
where 
 id= id_1;
end;
/



CREATE OR REPLACE PROCEDURE HrmResourceBasicInfo_Insert 
 (id_1 integer, 
  workcode_2 varchar2, 
  lastname_3 varchar2, 
  sex_5 char, 
  resoureimageid_6 integer, 
  departmentid_7 integer, 
  costcenterid_8 integer, 
  jobtitle_9 integer, 
  joblevel_10 integer, 
  jobactivitydesc_11 varchar2, 
  managerid_12 integer, 
  assistantid_13 integer, 
  status_14 char, 
  locationid_15 integer,
  workroom_16 varchar2, 
  telephone_17 varchar2, 
  mobile_18 varchar2, 
  mobilecall_19 varchar2 , 
  fax_20 varchar2, 
  jobcall_21 integer, 
  subcompanyid1_22 integer,
  managerstr_23 varchar2,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 
AS
BEGIN
INSERT INTO HrmResource 
(id, 
 workcode, 
 lastname, 
 sex, 
 resourceimageid, 
 departmentid, 
 costcenterid, 
 jobtitle, 
 joblevel, 
 jobactivitydesc, 
 managerid, 
 assistantid, 
 status, 
 locationid, 
 workroom, 
 telephone, 
 mobile, 
 mobilecall, 
 fax, 
 jobcall,
 seclevel,
 subcompanyid1,
 managerstr) 
VALUES 
(id_1, 
 workcode_2, 
 lastname_3, 
 sex_5, 
 resoureimageid_6, 
 departmentid_7, 
 costcenterid_8, 
 jobtitle_9, 
 joblevel_10, 
 jobactivitydesc_11, 
 managerid_12, 
 assistantid_13, 
 status_14, 
 locationid_15, 
 workroom_16, 
 telephone_17, 
 mobile_18, 
 mobilecall_19, 
 fax_20, 
 jobcall_21,
 0,
  subcompanyid1_22,
  managerstr_23);
end;
/


CREATE OR REPLACE PROCEDURE HrmResRpDefine_Delete
(resourceid_1 integer,
 flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
delete from HrmResourceRpDefine 
where 
  resourceid = resourceid_1;
end;
/

CREATE OR REPLACE PROCEDURE HrmResRpDefine_Insert
(resourceid_1 integer,
colname_2 varchar2,
showorder_3 integer,
header_4 varchar2,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into HrmResourceRpDefine
(resourceid,
 colname,
 showorder,
 header)
values
(resourceid_1,
 colname_2,
 showorder_3,
 header_4);
end;
/



alter table SystemSet add 
filesystem varchar2(200)
/
alter table SystemSet add 
filesystembackup varchar2(200)
/
alter table SystemSet add 
filesystembackuptime integer
/
alter table SystemSet add 
needzip char(1)
/
alter table SystemSet add 
needzipencrypt char(1)
/

update SystemSet set needzip='1' , needzipencrypt='1'
/

alter table MailResourceFile add 
filerealpath  varchar2(255) 
/
alter table MailResourceFile add 
iszip char(1) 
/
alter table MailResourceFile add 
isencrypt char(1)
/


alter table ImageFile add 
filerealpath  varchar2(255) 
/
alter table ImageFile add 
iszip char(1) 
/
alter table ImageFile add 
isencrypt char(1) 
/


create table FileBackupIndex (
lastbackupimagefileid   integer ,
lastbackupmailfileid   integer ,
lastbackupdate  char(10) ,
lastbackuptime  char(8) 
)
/

insert into FileBackupIndex ( lastbackupimagefileid , lastbackupmailfileid) values ( 0 , 0 )
/

CREATE OR REPLACE PROCEDURE SystemSet_Update 
    (emailserver_1  varchar2 , 
    debugmode_2   char , 
    logleaveday_3  smallint ,
    defmailuser_4  varchar2 ,
    defmailpassword_5  varchar2 ,
    pop3server_6  varchar2,
    filesystem_7 varchar2,
    filesystembackup_8 varchar2,
    filesystembackuptime_9 integer ,
    needzip_10 char,
    needzipencrypt_11 char,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
 update SystemSet set 
    emailserver=emailserver_1 , 
    debugmode=debugmode_2,
    logleaveday=logleaveday_3 ,
    defmailuser=defmailuser_4 , 
    defmailpassword=defmailpassword_5 , 
    pop3server=pop3server_6 ,
    filesystem=filesystem_7,
    filesystembackup=filesystembackup_8 ,
    filesystembackuptime=filesystembackuptime_9 , 
    needzip=needzip_10 , 
    needzipencrypt=needzipencrypt_11 ;
end;
/


CREATE OR REPLACE PROCEDURE MailResourceFile_Insert
	(mailid_1 	integer,
	 filename_2 	varchar2,
	 filetype_3 	varchar2,
	 filerealpath_4 	varchar2,
     iszip_5 char ,
	 isencrypt_6 	char ,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO MailResourceFile 
	 ( mailid,
	 filename,
	 filetype,
	 filerealpath,
     iszip,
	 isencrypt) 
 
VALUES 
	( mailid_1,
	 filename_2,
	 filetype_3,
	 filerealpath_4,
     iszip_5 ,
     isencrypt_6);
end;
/

CREATE OR REPLACE PROCEDURE SequenceIndex_SelectFileid
	(flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for 
select currentid from SequenceIndex where indexdesc='imagefileid';
update SequenceIndex set currentid = currentid+1 where indexdesc='imagefileid';
end;
/


CREATE OR REPLACE PROCEDURE ImageFile_Insert
	(imagefileid_1 	integer,
	 imagefilename_2 	varchar2,
	 imagefiletype_3 	varchar2,
	 imagefileused_4 	integer,
	 filerealpath_5 	varchar2,
     iszip_6 char ,
	 isencrypt_7 	char ,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO ImageFile 
	 ( imagefileid,
	 imagefilename,
	 imagefiletype,
	 imagefileused,
	 filerealpath,
     iszip,
	 isencrypt) 
 
VALUES 
	( imagefileid_1,
	 imagefilename_2,
	 imagefiletype_3,
	 imagefileused_4,
	 filerealpath_5,
     iszip_6,
	 isencrypt_7);
end;
/



CREATE OR REPLACE PROCEDURE DocImageFile_SelectByDocid
	(docid_1 	integer,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for
select * from DocImageFile where docid= docid_1 and docfiletype = '2' ;
end;
/




CREATE OR REPLACE PROCEDURE DocImageFile_Insert
	(docid_1 	integer,
	 imagefileid_2 	integer,
	 imagefilename_3 	varchar2,
	 imagefiledesc_4 	varchar2,
	 imagefilewidth_5 	smallint,
	 imagefileheight_6 	smallint,
	 imagefielsize_7 	smallint,
	 docfiletype_8 	char ,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
begin
INSERT INTO DocImageFile 
	 ( docid,
	 imagefileid,
	 imagefilename,
	 imagefiledesc,
	 imagefilewidth,
	 imagefileheight,
	 imagefielsize,
	 docfiletype) 
 
VALUES 
	( docid_1,
	 imagefileid_2,
	 imagefilename_3,
	 imagefiledesc_4,
	 imagefilewidth_5,
	 imagefileheight_6,
	 imagefielsize_7,
	 docfiletype_8);
end;
/



CREATE OR REPLACE PROCEDURE DocImageFile_DByDocfileid
	(docid_1 	integer ,
     imagefileid_2 	integer ,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
docfiletype_3 char(1);
begin
select  docfiletype into docfiletype_3 from DocImageFile where imagefileid=imagefileid_2 and docid=docid_1;
delete from DocImageFile where imagefileid=imagefileid_2 and docid=docid_1;
update ImageFile set imagefileused=imagefileused-1 where imagefileid = imagefileid_2 ;
open thecursor for
select filerealpath from ImageFile where imagefileid=imagefileid_2 and imagefileused = 0 ;
delete ImageFile where imagefileid=imagefileid_2 and imagefileused = 0;
if docfiletype_3 = '2' then
update DocDetail set accessorycount=accessorycount-1 where id = docid_1;
end if;
end;
/


CREATE OR REPLACE PROCEDURE DocImageFile_DByDocid
	(docid_1 	integer ,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
imagefileid_2 integer;
begin
for imagefileid_cursor in(select imagefileid from DocImageFile where docid=docid_1)
loop
    imagefileid_2 := imagefileid_cursor.imagefileid;
    update ImageFile set imagefileused=imagefileused-1 where imagefileid = imagefileid_2  ;
end loop;

delete from DocImageFile where docid=docid_1;
open thecursor for
select filerealpath from ImageFile where imagefileused = 0 ;
delete ImageFile where imagefileused = 0;
end;
/



CREATE OR REPLACE PROCEDURE MailResource_Delete 
	(mailid_1  integer,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
select filerealpath from MailResourceFile where mailid = mailid_1;
delete from MailResourceFile where mailid = mailid_1;
delete from MailResource where id = mailid_1;
end;
/




CREATE OR REPLACE PROCEDURE FileBackupIndex_Select
	(flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for
select * from FileBackupIndex ;
end;
/


CREATE OR REPLACE PROCEDURE ImageFile_SByBackup
	(imagefileid_1 	integer,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for
select imagefileid, filerealpath from ImageFile 
where imagefileid > imagefileid_1 and ( filerealpath is not null ) 
order by imagefileid ;
end;
/



CREATE OR REPLACE PROCEDURE MailResourceFile_SByBackup
	(mailid_1 	integer,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for
select mailid , filerealpath from MailResourceFile  
where mailid > mailid_1 and ( filerealpath is not null  ) 
order by mailid ;
end;
/




CREATE OR REPLACE PROCEDURE FileBackupIndex_Update
	(lastbackupimagefileid_1 	integer,
	 lastbackupmailfileid_2 	integer,
	 lastbackupdate_3 	char,
	 lastbackuptime_4 	char,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS
begin
update FileBackupIndex set 
             lastbackupimagefileid = lastbackupimagefileid_1,
             lastbackupmailfileid = lastbackupmailfileid_2,
             lastbackupdate = lastbackupdate_3,
             lastbackuptime = lastbackuptime_4;
end;
/


insert into htmllabelindex values(7175, '部门＋安全级别')
/
insert into htmllabelindex values(7176, '角色＋安全级别＋级别')
/
insert into htmllabelindex values(7178, '用户类型＋安全级别')
/
insert into htmllabelindex values(7179, '用户类型')
/

insert into htmlnoteindex values(45, '分目录不能删除，还有下级分目录存在')
/
insert into htmlnoteinfo values(45, '该分目录下有下级分目录存在,不能被删除!', 7)
/
insert into htmlnoteinfo values(45, 'Unable to delete group,This group contains 1 or more other groups!', 8)
/


CREATE OR REPLACE PROCEDURE CRM_SellChance_Statistics
(
    userid_1 integer,
    usertype_1 char,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
as
result_1 integer;
sucess_1 integer;
failure_1 integer;
nothing_1 integer;
begin
select count(*) INTO result_1 from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where  t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=usertype_1  and t2.userid=userid_1 ;

select  count(t1.id) into sucess_1 from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where   t1.endtatusid ='1' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=usertype_1  and t2.userid=userid_1 ;

select  count(t1.id) into  failure_1 from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where   t1.endtatusid ='2' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=usertype_1  and t2.userid=userid_1 ;

select  count(t1.id) into nothing_1 from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where   t1.endtatusid ='0' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=usertype_1  and t2.userid=userid_1 ;

insert INTO temp_sell_table_01(result,sucess,failure,nothing) values(result_1,sucess_1,failure_1,nothing_1);
open thecursor for
select * from temp_sell_table_01;
end;
/




INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'sumtime',7180,'integer',1,2,8,0)
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'sumday',852,'integer',1,2,9,0) 
/ 
alter table Bill_HrmScheduleHoliday add sumtime integer null
/
alter table Bill_HrmScheduleHoliday add sumday integer null
/ 

insert into HtmlLabelIndex (id,indexdesc) values (7180	,'总时间')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7180,'总时间',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7180,'',8)
/