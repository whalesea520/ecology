CREATE TABLE ImageFileBackUp (
	id	Int	IDENTITY (1, 1) NOT NULL,
        imageFileId int NULL 
) 
GO

CREATE TABLE MailResourceFileBackUp (
	id	Int	IDENTITY (1, 1) NOT NULL,
        mailResourceFileId int NULL 
) 
GO

create TRIGGER Tri_MailResourceFile_BackUp ON MailResourceFile WITH ENCRYPTION
FOR UPDATE
AS
Declare @mailResourceFileId_1 int
select @mailResourceFileId_1 = id from deleted
insert into MailResourceFileBackUp(mailResourceFileId) values(@mailResourceFileId_1)
GO

create TRIGGER Tri_ImageFile_BackUp ON ImageFile WITH ENCRYPTION
FOR UPDATE
AS
Declare @imageFileId_1 int
select @imageFileId_1 = imageFileId from deleted
insert into ImageFileBackUp(imageFileId) values(@imageFileId_1)
GO
