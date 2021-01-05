alter table FnaSystemSet add fnaBackgroundValidator int default 0
GO

CREATE TABLE [FnaMobileErrorMsg](
	[id] [int] IDENTITY(1,1) NOT NULL primary key,
	[userid] [int] NULL,
	[requestid] [int] NULL,
	[msg] [varchar](2000) NULL 
) 
GO