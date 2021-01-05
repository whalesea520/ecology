alter table MailSetting add emlsavedays int
/
update MailSetting set emlsavedays = 30 
/

alter table SystemSet add emlsavedays int
/
update SystemSet set emlsavedays = 30 
/

alter table mailresource add emltime varchar(30)
/
update mailresource set emltime = senddate
/

alter table mailresource add haseml int default 1
/
update mailresource set haseml = 1
/