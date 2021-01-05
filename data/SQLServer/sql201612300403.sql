CREATE TABLE Social_WithdrawMsg(
	id int IDENTITY(1,1) NOT NULL,
	msgid varchar(50) NULL,
	userid int NULL,
	targetid varchar(50) NULL
)
GO
create index social_wdmsgid_index on Social_WithdrawMsg(msgid)
GO