create table GroupAndContact
(
	id int identity(1,1) primary key,
	groupId int not null,
	contactId int not null
)
GO


create table webmail_domain(
	DOMAIN_ID integer ,
	DOMAIN varchar(100),
	POP_SERVER varchar(100),
	SMTP_SERVER varchar(100),
	IS_SMTP_AUTH varchar(100),
	POP_PORT varchar(100),
	SMTP_PORT varchar(100),
	IS_SSL_AUTH varchar(100),
	IS_POP varchar(100)
)
GO

CREATE TABLE email_label(
	id int IDENTITY(1,1) NOT NULL,
	accountid int NULL,
	name varchar(100) NULL,
	color varchar(100) NULL,
	createdate varchar(100) NULL,
	createtime varchar(100) NULL
) ;
GO


create table email_label_detail(
	id int IDENTITY(1,1) NOT NULL,
	labelid int ,
	mailid int
);
GO

alter table MailResource add originalMailId int
GO


alter table MailSign add isActive int
GO

alter table mailsetting add defaulttype int 
GO
update mailsetting set defaulttype = 1
GO

create table emailGuide
(
	id int primary key not null identity(1,1), 
	userid int
)
GO

create  PROCEDURE MailResource_Update
(
	@id_1        int, 
	@resourceid_2 	int, 
	@priority_3 	char(1),
	@sendfrom_4 	varchar(200), 
	@sendcc_5 	varchar(4000),
	@sendbcc_6 	varchar(4000),
	@sendto_7 	varchar(4000),
	@senddate_8 	varchar(30), 
	@size_9 	int, 
	@subject_10 	varchar(1200),
	@content_11 	text, 
	@mailtype_12	char(1) ,
	@hasHtmlImage_13	char(1) ,
	@mailAccountId_14 int,
	@status_15 char(1),
	@folderId_16 int,
	@flag	int	output,
	@msg	varchar(80)	output
) AS 
update MailResource 
set resourceid=@resourceid_2, priority=@priority_3, sendfrom=@sendfrom_4,
sendcc=@sendcc_5, sendbcc=@sendbcc_6, sendto=@sendto_7,
senddate=@senddate_8, size_n=@size_9, subject=@subject_10, 
content=@content_11, mailtype=@mailtype_12, 
hasHtmlImage=@hasHtmlImage_13, mailAccountId=@mailAccountId_14,
status=@status_15, folderId=@folderId_16
where  id=@id_1; 
 GO
