INSERT INTO HtmlLabelIndex values(18116,'默认机构') 
/
INSERT INTO HtmlLabelInfo VALUES(18116,'默认机构',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18116,'default subcompany',8) 
/

alter table SystemSet add dftsubcomid integer
/

update SystemSet set detachable=0
/

CREATE OR REPLACE PROCEDURE systemset_update 
(emailserver_1 VARCHAR2,
debugmode_2 CHAR,
logleaveday_3 SMALLINT,
defmailuser_4 VARCHAR2,
defmailpassword_5 VARCHAR2,
pop3server_6 VARCHAR2,
filesystem_7 VARCHAR2,
filesystembackup_8 VARCHAR2,
filesystembackuptime_9 INTEGER,
needzip_10 CHAR,
needzipencrypt_11 CHAR,
defmailserver_12 VARCHAR2,
defmailfrom_13 VARCHAR2,
defneedauth_14 CHAR,
smsserver_15 VARCHAR2,
detachable_16 char ,
licenseRemind_17 char ,
remindUsers_18 VARCHAR2 ,
remindDays_19 VARCHAR2 ,
dftsubcomid_20 INTEGER ,
flag OUT INTEGER,
msg OUT VARCHAR2,
thecursor IN OUT cursor_define.weavercursor)
 
AS
BEGIN
UPDATE systemset SET emailserver = emailserver_1,
debugmode = debugmode_2,
logleaveday = logleaveday_3,
defmailuser = defmailuser_4,
defmailpassword = defmailpassword_5,
pop3server = pop3server_6,
filesystem = filesystem_7,
filesystembackup = filesystembackup_8,
filesystembackuptime = filesystembackuptime_9,
needzip = needzip_10,
needzipencrypt = needzipencrypt_11,
defmailserver = defmailserver_12,
defmailfrom = defmailfrom_13,
defneedauth = defneedauth_14,
smsserver = smsserver_15,
detachable = detachable_16 ,
licenseRemind = licenseRemind_17 ,
remindUsers = remindUsers_18 ,
remindDays = remindDays_19 ,
dftsubcomid = dftsubcomid_20 ;
END;
/

CREATE or REPLACE PROCEDURE SystemSet_DftSCUpdate(
	dftsubcomid_1 integer,
	flag OUT INTEGER,
	msg OUT VARCHAR2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	update HrmRoles set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0;
	update workflow_formdict set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0;
	update workflow_formdictdetail set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0;
	update workflow_formbase set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0;
	update workflow_base set subcompanyid=dftsubcomid_1 where subcompanyid is null or subcompanyid=0;
end;
/
