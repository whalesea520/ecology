ALTER TABLE MailAccount ADD sendStatus CHAR(1)
GO
ALTER TABLE MailAccount ADD receiveStatus CHAR(1) 
GO
UPDATE MailAccount SET sendStatus = 1 ,receiveStatus = 1
GO