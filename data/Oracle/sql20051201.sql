alter table SystemSet add licenseRemind char(1)
/
alter table SystemSet add remindUsers varchar2(500)
/
alter table SystemSet add remindDays varchar2(8)
/
alter table SystemSet add lastRemindDate varchar2(10)
/
update SystemSet set licenseRemind='1',remindUsers='1',remindDays='14'
/

INSERT INTO HtmlLabelIndex values(18012,'授权信息提醒设置') 
/
INSERT INTO HtmlLabelInfo VALUES(18012,'授权信息提醒设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18012,'License Remind Settings',8) 
/

INSERT INTO HtmlLabelIndex values(18013,'提醒对象') 
/
INSERT INTO HtmlLabelInfo VALUES(18013,'提醒对象',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18013,'Remind User',8) 
/

INSERT INTO HtmlLabelIndex values(18014,'授权信息') 
/
INSERT INTO HtmlLabelInfo VALUES(18014,'授权信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18014,'License Info',8) 
/

call MMConfig_U_ByInfoInsert (11,13)
/
call MMInfo_Insert (426,18014,'授权信息','/system/licenseInfo.jsp','mainFrame',11,1,13,0,'',0,'',0,'','',0,'','',9)
/


CREATE OR REPLACE PROCEDURE systemset_update (emailserver_1 VARCHAR2, debugmode_2 CHAR,
logleaveday_3 SMALLINT, defmailuser_4 VARCHAR2, defmailpassword_5 VARCHAR2, pop3server_6 VARCHAR2,
filesystem_7 VARCHAR2, filesystembackup_8 VARCHAR2, filesystembackuptime_9 INTEGER,
needzip_10 CHAR, needzipencrypt_11 CHAR, defmailserver_12 VARCHAR2, defmailfrom_13 VARCHAR2,
defneedauth_14 CHAR, smsserver_15 VARCHAR2,licenseremind_16 CHAR, 	remindusers_17 VARCHAR2,
reminddays_18 VARCHAR2, flag OUT INTEGER, msg OUT VARCHAR2, thecursor IN OUT cursor_define.weavercursor)
 
AS
BEGIN
   UPDATE systemset SET emailserver = emailserver_1, debugmode = debugmode_2, 
   logleaveday = logleaveday_3, defmailuser = defmailuser_4, defmailpassword =
   defmailpassword_5, pop3server = pop3server_6, filesystem = filesystem_7, 
   filesystembackup = filesystembackup_8, filesystembackuptime =
   filesystembackuptime_9, needzip = needzip_10, needzipencrypt =
   needzipencrypt_11, defmailserver = defmailserver_12, defmailfrom =
   defmailfrom_13, defneedauth = defneedauth_14, smsserver = smsserver_15, 			
   licenseremind = licenseremind_16,remindusers = remindusers_17, reminddays
   = reminddays_18 ;
END;
/
