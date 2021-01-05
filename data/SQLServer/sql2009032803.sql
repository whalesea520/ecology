alter table SystemSet add emailfilesize int
GO

UPDATE SystemSet set emailfilesize = 0
GO

alter PROCEDURE SystemSet_Update(
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
	@licenseRemind_17 char(1) ,
	@remindUsers_18 varchar(500) ,
	@remindDays_19 varchar(8) ,
	@emailfilesize_20 int ,
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
	licenseRemind=@licenseRemind_17 ,
	remindUsers=@remindUsers_18 ,
	remindDays=@remindDays_19 ,
	emailfilesize=@emailfilesize_20
GO
