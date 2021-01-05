insert into SequenceIndex select 'mailusergroup', nvl(max(mailgroupid),0) from MailUserGroup
/
insert into SequenceIndex select 'mailuseraddress', nvl(max(id),0) from MailUserAddress
/
insert into SequenceIndex select 'mailinboxfolder', nvl(max(id),0) from MailInboxFolder
/


CREATE TABLE Tmp_MailUserGroup
(
mailgroupid integer NOT NULL,
mailgroupname varchar2(200) NULL,
operatedesc varchar2(255) NULL,
createrid integer NULL,
createrdate char(10) NULL,
parentId integer NULL,
subCount integer NULL
)
/
INSERT INTO Tmp_MailUserGroup (mailgroupid, mailgroupname, operatedesc, createrid, createrdate, parentId, subCount)
		SELECT mailgroupid, mailgroupname, operatedesc, createrid, createrdate, parentId, subCount FROM MailUserGroup TABLOCKX
/
DROP TABLE MailUserGroup
/
alter table Tmp_MailUserGroup rename to MailUserGroup
/



CREATE TABLE Tmp_MailInboxFolder
(
id integer NOT NULL,
webfxTreeId varchar2(50) NULL,
userId integer NULL,
folderName varchar2(50) NULL,
parentId integer NULL,
subCount integer NULL
)
/
INSERT INTO Tmp_MailInboxFolder (id, webfxTreeId, userId, folderName, parentId, subCount)
		SELECT id, webfxTreeId, userId, folderName, parentId, subCount FROM MailInboxFolder TABLOCKX
/
DROP TABLE MailInboxFolder
/
alter table Tmp_MailInboxFolder rename to MailInboxFolder
/



create or replace procedure MailSequence_Get(
indexdesc_1 varchar2,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
id_1 integer;
recordcount integer;

begin
select count(*) INTO recordcount  from SequenceIndex where  indexdesc=indexdesc_1;
if recordcount>0 then 
select currentid into id_1 from SequenceIndex where indexdesc=indexdesc_1;
update SequenceIndex set currentid = id_1+1 where indexdesc=indexdesc_1;
open thecursor for
select id_1 from dual;

end if;

end;
/