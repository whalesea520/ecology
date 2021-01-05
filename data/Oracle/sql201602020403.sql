delete from social_IMSessionkey
/
alter table social_IMSessionkey modify userid int
/
alter table social_IMSessionkey add loginStatus int
/
alter table social_IMSessionkey add updateTime varchar2(20)
/