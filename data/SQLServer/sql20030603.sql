alter table HrmScheduleMaintance add
  totalday int default(0)
go

alter table HrmScheduleMaintance add
  totaltime varchar(10)
go

create table HrmResourceRpDefine
(id int identity(1,1) not null,
 resourceid int not null,
 colname varchar(30) null,
 showorder int default(0),
 header varchar(60) null)
go

alter table HrmCareerApplyOtherInfo alter column salaryneed int null
go

alter table HrmCareerApplyOtherInfo alter column salarynow int null
go

alter table HrmCareerApplyOtherInfo alter column worktime int null
go

create procedure HrmScheduleTotalTime
(@id_1 int,
 @totaltime_2 varchar(10),
 @flag int output, @msg varchar(30) output)
as update HrmScheduleMaintance set
 totaltime = @totaltime_2
where 
 id= @id_1
go

alter PROCEDURE HrmScheduleMain_Insert
	(@diffid_1 	[int],
	 @resourceid_2 	[int],
	 @startdate_3 	[char](10),
	 @starttime_4 	[char](8),
	 @enddate_5 	[char](10),
	 @endtime_6 	[char](8),
	 @memo_7 	[text],
	 @createtype_8 	[int],
	 @createrid_9 	[int],
	 @createdate_10 	[char](10),
	 @flag int output, @msg varchar(60) output)

AS INSERT INTO HrmScheduleMaintance 
	 ( [diffid],
	 [resourceid],
	 [startdate],
	 [starttime],
	 [enddate],
	 [endtime],
	 [memo],
	 [createtype],
	 [createrid],
	 [createdate]) 
 
VALUES 
	( @diffid_1,
	 @resourceid_2,
	 @startdate_3,
	 @starttime_4,
	 @enddate_5,
	 @endtime_6,
	 @memo_7,
	 @createtype_8,
	 @createrid_9,
	 @createdate_10)
select max(id) from HrmScheduleMaintance
GO

create procedure HrmScheduleTotalDay
(@id_1 int,
 @totalday_2 varchar(10),
 @flag int output, @msg varchar(30) output)
as update HrmScheduleMaintance set
 totalday = @totalday_2
where 
 id= @id_1
go


alter PROCEDURE HrmResourceBasicInfo_Insert 
 (@id_1 int, 
  @workcode_2 varchar(60), 
  @lastname_3 varchar(60), 
  @sex_5 char(1), 
  @resoureimageid_6 int, 
  @departmentid_7 int, 
  @costcenterid_8 int, 
  @jobtitle_9 int, 
  @joblevel_10 int, 
  @jobactivitydesc_11 varchar(200), 
  @managerid_12 int, 
  @assistantid_13 int, 
  @status_14 char(1), 
  @locationid_15 int, 
  @workroom_16 varchar(60), 
  @telephone_17 varchar(60), 
  @mobile_18 varchar(60), 
  @mobilecall_19 varchar(30) , 
  @fax_20 varchar(60), 
  @jobcall_21 int, 
  @subcompanyid1_22 int,
  @managerstr_23 varchar(200),
  @flag int output, @msg varchar(60) output) 
AS INSERT INTO HrmResource 
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
(@id_1, 
 @workcode_2, 
 @lastname_3, 
 @sex_5, 
 @resoureimageid_6, 
 @departmentid_7, 
 @costcenterid_8, 
 @jobtitle_9, 
 @joblevel_10, 
 @jobactivitydesc_11, 
 @managerid_12, 
 @assistantid_13, 
 @status_14, 
 @locationid_15, 
 @workroom_16, 
 @telephone_17, 
 @mobile_18, 
 @mobilecall_19, 
 @fax_20, 
 @jobcall_21,
 0,
  @subcompanyid1_22,
  @managerstr_23)
GO

create procedure HrmResRpDefine_Delete
(@resourceid_1 int,
 @flag int output, @msg varchar(60) output)
as delete from HrmResourceRpDefine 
where 
  resourceid = @resourceid_1
go

create procedure HrmResRpDefine_Insert
(@resourceid_1 int,
 @colname_2 varchar(30),
 @showorder_3 int,
 @header_4 varchar(60),
 @flag int output, @msg varchar(60) output)
as insert into HrmResourceRpDefine
(resourceid,
 colname,
 showorder,
 header)
values
(@resourceid_1,
 @colname_2,
 @showorder_3,
 @header_4)
go


alter table SystemSet add 
filesystem varchar(200),
filesystembackup varchar(200),
filesystembackuptime int ,
needzip char(1),
needzipencrypt char(1)
GO

update SystemSet set needzip='1' , needzipencrypt='1'
GO

alter table MailResourceFile add 
filerealpath  varchar(255) ,
iszip char(1) ,
isencrypt char(1)
GO


alter table ImageFile add 
filerealpath  varchar(255) ,
iszip char(1) ,
isencrypt char(1) 
GO


create table FileBackupIndex (
lastbackupimagefileid   int ,
lastbackupmailfileid   int ,
lastbackupdate  char(10) ,
lastbackuptime  char(8) 
)
GO

insert into FileBackupIndex ( lastbackupimagefileid , lastbackupmailfileid) values ( 0 , 0 )
GO

alter PROCEDURE SystemSet_Update 
 (@emailserver_1  varchar(60) , 
  @debugmode_2   char(1) , 
  @logleaveday_3  tinyint ,
  @defmailuser_4  varchar(60) ,
  @defmailpassword_5  varchar(60) ,
  @pop3server_6  varchar(60),
  @filesystem_7 varchar(200),
  @filesystembackup_8 varchar(200),
  @filesystembackuptime_9 int ,
  @needzip_10 char(1),
  @needzipencrypt_11 char(1),
  @flag int output, 
  @msg varchar(80) output) 
AS 
 update SystemSet set 
        emailserver=@emailserver_1 , 
        debugmode=@debugmode_2,
        logleaveday=@logleaveday_3 ,
        defmailuser=@defmailuser_4 , 
        defmailpassword=@defmailpassword_5 , 
        pop3server=@pop3server_6 ,
        filesystem=@filesystem_7,
        filesystembackup=@filesystembackup_8 ,
        filesystembackuptime=@filesystembackuptime_9 , 
        needzip=@needzip_10 , 
        needzipencrypt=@needzipencrypt_11 
GO


CREATE PROCEDURE MailResourceFile_Insert
	(@mailid_1 	int,
	 @filename_2 	varchar(100),
	 @filetype_3 	varchar(60),
	 @filerealpath_4 	varchar(255),
     @iszip_5 char(1) ,
	 @isencrypt_6 	char(1) ,
     @flag int output, 
     @msg varchar(80) output)

AS INSERT INTO MailResourceFile 
	 ( mailid,
	 filename,
	 filetype,
	 filerealpath,
     iszip,
	 isencrypt) 
 
VALUES 
	( @mailid_1,
	 @filename_2,
	 @filetype_3,
	 @filerealpath_4,
     @iszip_5 ,
     @isencrypt_6)
GO

CREATE PROCEDURE SequenceIndex_SelectFileid
	(@flag int output, 
     @msg varchar(80) output)

AS 
select currentid from SequenceIndex where indexdesc='imagefileid'
update SequenceIndex set currentid = currentid+1 where indexdesc='imagefileid'
GO

CREATE PROCEDURE ImageFile_Insert
	(@imagefileid_1 	int,
	 @imagefilename_2 	varchar(200),
	 @imagefiletype_3 	varchar(50),
	 @imagefileused_4 	int,
	 @filerealpath_5 	varchar(255),
     @iszip_6 char(1) ,
	 @isencrypt_7 	char(1) ,
     @flag int output, 
     @msg varchar(80) output)

AS INSERT INTO ImageFile 
	 ( imagefileid,
	 imagefilename,
	 imagefiletype,
	 imagefileused,
	 filerealpath,
     iszip,
	 isencrypt) 
 
VALUES 
	( @imagefileid_1,
	 @imagefilename_2,
	 @imagefiletype_3,
	 @imagefileused_4,
	 @filerealpath_5,
     @iszip_6,
	 @isencrypt_7)
GO


CREATE PROCEDURE DocImageFile_SelectByDocid
	(@docid_1 	int,
     @flag int output, 
     @msg varchar(80) output)

AS 
select * from DocImageFile where docid= @docid_1 and docfiletype = '2' 
GO


CREATE PROCEDURE DocImageFile_Insert
	(@docid_1 	int,
	 @imagefileid_2 	int,
	 @imagefilename_3 	varchar(200),
	 @imagefiledesc_4 	varchar(200),
	 @imagefilewidth_5 	smallint,
	 @imagefileheight_6 	smallint,
	 @imagefielsize_7 	smallint,
	 @docfiletype_8 	char(1) ,
     @flag int output, 
     @msg varchar(80) output)

AS INSERT INTO DocImageFile 
	 ( docid,
	 imagefileid,
	 imagefilename,
	 imagefiledesc,
	 imagefilewidth,
	 imagefileheight,
	 imagefielsize,
	 docfiletype) 
 
VALUES 
	( @docid_1,
	 @imagefileid_2,
	 @imagefilename_3,
	 @imagefiledesc_4,
	 @imagefilewidth_5,
	 @imagefileheight_6,
	 @imagefielsize_7,
	 @docfiletype_8)
GO


CREATE PROCEDURE DocImageFile_DByDocfileid
	(@docid_1 	int ,
     @imagefileid_2 	int ,
     @flag int output, 
     @msg varchar(80) output)

AS 
declare @docfiletype_3 char(1)
select @docfiletype_3 = docfiletype from DocImageFile where imagefileid=@imagefileid_2 and docid=@docid_1
delete from DocImageFile where imagefileid=@imagefileid_2 and docid=@docid_1
update ImageFile set imagefileused=imagefileused-1 where imagefileid = @imagefileid_2 
select filerealpath from ImageFile where imagefileid=@imagefileid_2 and imagefileused = 0 
delete ImageFile where imagefileid=@imagefileid_2 and imagefileused = 0
if @docfiletype_3 = '2' update DocDetail set accessorycount=accessorycount-1 where id = @docid_1
GO


CREATE PROCEDURE DocImageFile_DByDocid
	(@docid_1 	int ,
     @flag int output, 
     @msg varchar(80) output)

AS 
declare @imagefileid_2 int
declare imagefileid_cursor cursor for 
select imagefileid from DocImageFile where docid=@docid_1
open imagefileid_cursor 
fetch next from imagefileid_cursor into @imagefileid_2 
while @@fetch_status=0 
begin 
    update ImageFile set imagefileused=imagefileused-1 where imagefileid = @imagefileid_2  
    fetch next from imagefileid_cursor into @imagefileid_2 
end 
close imagefileid_cursor 
deallocate imagefileid_cursor
delete from DocImageFile where docid=@docid_1
select filerealpath from ImageFile where imagefileused = 0 
delete ImageFile where imagefileused = 0
GO


alter PROCEDURE MailResource_Delete 
	(@mailid_1  integer,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS
select filerealpath from MailResourceFile where mailid = @mailid_1
delete from MailResourceFile where mailid = @mailid_1
delete from MailResource where id = @mailid_1
GO



CREATE PROCEDURE FileBackupIndex_Select
	(@flag int output, 
     @msg varchar(80) output)

AS 
select * from FileBackupIndex 
GO


CREATE PROCEDURE ImageFile_SByBackup
	(@imagefileid_1 	int,
     @flag int output, 
     @msg varchar(80) output)

AS 
select imagefileid, filerealpath from ImageFile 
where imagefileid > @imagefileid_1 and ( filerealpath is not null or filerealpath <> '' ) 
order by imagefileid 
GO


CREATE PROCEDURE MailResourceFile_SByBackup
	(@mailid_1 	int,
     @flag int output, 
     @msg varchar(80) output)

AS 
select mailid , filerealpath from MailResourceFile  
where mailid > @mailid_1 and ( filerealpath is not null or filerealpath <> '' ) 
order by mailid 
GO



CREATE PROCEDURE FileBackupIndex_Update
	(@lastbackupimagefileid_1 	int,
	 @lastbackupmailfileid_2 	int,
	 @lastbackupdate_3 	char(10),
	 @lastbackuptime_4 	char(8),
     @flag int output, 
     @msg varchar(80) output)

AS update FileBackupIndex set 
             lastbackupimagefileid = @lastbackupimagefileid_1,
             lastbackupmailfileid = @lastbackupmailfileid_2,
             lastbackupdate = @lastbackupdate_3,
             lastbackuptime = @lastbackuptime_4
GO

insert into htmllabelindex values(7175, '部门＋安全级别')
go
insert into htmllabelindex values(7176, '角色＋安全级别＋级别')
go
insert into htmllabelindex values(7178, '用户类型＋安全级别')
go
insert into htmllabelindex values(7179, '用户类型')
go

insert into htmlnoteindex values(45, '分目录不能删除，还有下级分目录存在')
go
insert into htmlnoteinfo values(45, '该分目录下有下级分目录存在,不能被删除!', 7)
go
insert into htmlnoteinfo values(45, 'Unable to delete group,This group contains 1 or more other groups!', 8)
go


alter PROCEDURE CRM_SellChance_Statistics
(
    @userid_1 int,
    @usertype_1 char(1),
	@flag	int	output,
	@msg	varchar(80)	output)
as
declare
@result_1 int,
@sucess_1 int,
@failure_1 int,
@nothing_1 int

create table #temp( result  int , sucess  int, failure	int, nothing	int)
select @result_1= count(*) from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where  t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=@usertype_1  and t2.userid=@userid_1 

select @sucess_1= count(t1.id) from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where   t1.endtatusid ='1' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=@usertype_1  and t2.userid=@userid_1 

select @failure_1= count(t1.id)  from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where   t1.endtatusid ='2' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=@usertype_1  and t2.userid=@userid_1 

select @nothing_1= count(t1.id)  from CRM_SellChance t1,CrmShareDetail t2,CRM_CustomerInfo t3 where   t1.endtatusid ='0' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.crmid and t2.usertype=@usertype_1  and t2.userid=@userid_1 

insert INTO #temp(result,sucess,failure,nothing) values(@result_1,@sucess_1,@failure_1,@nothing_1)
select * from #temp
go

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'sumtime',7180,'int',1,2,8,0)
GO 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (46,'sumday',852,'int',1,2,9,0) 
GO 
alter table Bill_HrmScheduleHoliday add sumtime int null
GO 
alter table Bill_HrmScheduleHoliday add sumday int null
GO 

insert into HtmlLabelIndex (id,indexdesc) values (7180	,'总时间')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7180,'总时间',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (7180,'',8)
GO