exec sp_rename 'MailResource.readdate','readdate1','column'
GO
ALTER TABLE MailResource ADD readdate VARCHAR(30) DEFAULT '0'
GO
UPDATE MailResource SET readdate = readdate1
GO
ALTER TABLE MailResource DROP COLUMN readdate1
GO
update MailResource set readdate='0' where readdate is null
GO