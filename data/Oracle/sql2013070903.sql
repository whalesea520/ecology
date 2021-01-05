alter table SystemSet add  isaesencrypt int default 0
/
alter table imagefile add  isaesencrypt int default 0
/
alter table imagefile add  aescode varchar2(200)
/
alter table MailResourceFile add  isaesencrypt int default 0
/
alter table MailResourceFile add  aescode varchar2(200)
/