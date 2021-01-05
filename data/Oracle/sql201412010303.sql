ALTER TABLE MailAccount ADD sendStatus CHAR(1)
/
ALTER TABLE MailAccount ADD receiveStatus CHAR(1) 
/
UPDATE MailAccount SET sendStatus = 1 ,receiveStatus = 1
/