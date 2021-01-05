ALTER TABLE MailResource RENAME COLUMN readdate TO readdate1
/
ALTER TABLE MailResource ADD readdate VARCHAR(30) DEFAULT '0'
/
UPDATE MailResource SET readdate = readdate1
/
ALTER TABLE MailResource DROP COLUMN readdate1
/
update MailResource set readdate='0' where readdate is null
/