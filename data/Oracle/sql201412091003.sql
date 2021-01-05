alter table MailResource add messageid VARCHAR(200)
/
UPDATE MailResource SET messageid = '0' 
/