delete from MailBlacklist
/
alter table MailBlacklist add constraint  UNIQUE_mailblacelist_name unique (name)
/
alter table MailBlacklist add constraint  UNIQUE_mailblacelist_postfix unique (postfix)
/