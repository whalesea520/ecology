insert into SequenceIndex select 'mailusergroup', isnull(max(mailgroupid),0) from MailUserGroup
go
insert into SequenceIndex select 'mailuseraddress', isnull(max(id),0) from MailUserAddress
go
insert into SequenceIndex select 'mailinboxfolder', isnull(max(id),0) from MailInboxFolder
go


CREATE TABLE Tmp_MailUserGroup
(
mailgroupid int NOT NULL,
mailgroupname varchar(200) NULL,
operatedesc varchar(255) NULL,
createrid int NULL,
createrdate char(10) NULL,
parentId int NULL,
subCount int NULL
)
GO
EXEC('INSERT INTO Tmp_MailUserGroup (mailgroupid, mailgroupname, operatedesc, createrid, createrdate, parentId, subCount)
		SELECT mailgroupid, mailgroupname, operatedesc, createrid, createrdate, parentId, subCount FROM MailUserGroup TABLOCKX')
GO
DROP TABLE MailUserGroup
GO
EXECUTE sp_rename N'Tmp_MailUserGroup', N'MailUserGroup', 'OBJECT'
GO



CREATE TABLE Tmp_MailInboxFolder
(
id int NOT NULL,
webfxTreeId varchar(50) NULL,
userId int NULL,
folderName varchar(50) NULL,
parentId int NULL,
subCount int NULL
)
GO
EXEC('INSERT INTO Tmp_MailInboxFolder (id, webfxTreeId, userId, folderName, parentId, subCount)
		SELECT id, webfxTreeId, userId, folderName, parentId, subCount FROM MailInboxFolder TABLOCKX')
GO
DROP TABLE MailInboxFolder
GO
EXECUTE sp_rename N'Tmp_MailInboxFolder', N'MailInboxFolder', 'OBJECT'
GO



create procedure MailSequence_Get(
@indexdesc varchar(40),
@flag int output, 
@msg varchar(60) output)
as 
declare @id_1 integer
select @id_1=currentid from SequenceIndex where indexdesc=@indexdesc
update SequenceIndex set currentid = @id_1+1 where indexdesc=@indexdesc
select @id_1
GO