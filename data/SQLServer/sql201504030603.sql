delete from MailBlacklist
GO
ALTER TABLE MailBlacklist ADD CONSTRAINT UNIQUE_mailblacelist_name  UNIQUE NONCLUSTERED(name)
GO
ALTER TABLE MailBlacklist ADD CONSTRAINT UNIQUE_mailblacelist_postfix  UNIQUE NONCLUSTERED(postfix)
GO