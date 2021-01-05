CREATE TABLE social_IMRecentConver (
	id int NOT NULL IDENTITY(1,1) ,
	userid int NULL ,
	targetid varchar(100) NULL 
)
GO
alter table social_IMConversation add senderid int
GO


