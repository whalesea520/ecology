alter table MailResource add messageid VARCHAR(200)
GO
UPDATE MailResource SET messageid = '0' 
GO