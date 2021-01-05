CREATE TABLE MailDeleteFile(
	 id                   int                  identity,
	 mailfileid               int              not null,
	 timeMillis           varchar(200)         null,
	 filerealpath         varchar(200)         null,
	 constraint PK_MAIL_MailDeleteFile primary key (id)
)
GO
