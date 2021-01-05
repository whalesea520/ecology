drop table MailBlacklist
GO
CREATE TABLE MailBlacklist(
	 id                   int                  identity,
	 userid               int                  not null,
	 name                 varchar(100)         null,
	 postfix	      varchar(50)          null, 
	 constraint PK_MAIL_MailBlacklist primary key (id)
)
GO
ALTER TABLE MailBlacklist ADD CONSTRAINT UNIQUE_mailblacelist_name_postfix  UNIQUE NONCLUSTERED(name, postfix)
GO