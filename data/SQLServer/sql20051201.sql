alter table SystemSet add licenseRemind char(1)
GO
alter table SystemSet add remindUsers varchar(500)
GO
alter table SystemSet add remindDays varchar(8)
GO
alter table SystemSet add lastRemindDate varchar(10)
GO

update SystemSet set licenseRemind='1',remindUsers='1',remindDays='14'
go

INSERT INTO HtmlLabelIndex values(18012,'授权信息提醒设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(18012,'授权信息提醒设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18012,'License Remind Settings',8) 
GO

INSERT INTO HtmlLabelIndex values(18013,'提醒对象') 
GO
INSERT INTO HtmlLabelInfo VALUES(18013,'提醒对象',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18013,'Remind User',8) 
GO

INSERT INTO HtmlLabelIndex values(18014,'授权信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(18014,'授权信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18014,'License Info',8) 
GO

EXECUTE MMConfig_U_ByInfoInsert 11,13
GO
EXECUTE MMInfo_Insert 426,18014,'授权信息','/system/licenseInfo.jsp','mainFrame',11,1,13,0,'',0,'',0,'','',0,'','',9
GO


Alter PROCEDURE SystemSet_Update(
	@emailserver_1  varchar(60) , 
	@debugmode_2   char(1) , 
	@logleaveday_3  tinyint ,
	@defmailuser_4  varchar(60) ,
	@defmailpassword_5  varchar(60) ,
	@pop3server_6  varchar(60) ,
	@filesystem_7 varchar(200) ,
	@filesystembackup_8 varchar(200) ,
	@filesystembackuptime_9 int ,
	@needzip_10 char(1) ,
	@needzipencrypt_11 char(1) ,
	@defmailserver_12 varchar(60) ,
	@defmailfrom_13 varchar(60) ,
	@defneedauth_14 char(1) ,
	@smsserver_15 varchar(50) ,
	@licenseRemind_16 char(1) ,
	@remindUsers_17 varchar(500) ,
	@remindDays_18 varchar(8) ,
	@flag int output , 
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
        needzipencrypt=@needzipencrypt_11 ,
        defmailserver=@defmailserver_12 ,
        defmailfrom=@defmailfrom_13 ,
        defneedauth=@defneedauth_14 ,
        smsserver=@smsserver_15 ,
	licenseRemind=@licenseRemind_16 ,
	remindUsers=@remindUsers_17 ,
	remindDays=@remindDays_18 

GO

