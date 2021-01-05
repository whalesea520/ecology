CREATE TABLE [Social_AllGroupInfos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[groupId] [varchar](100) NULL,
	[groupName] [varchar](1000) NULL,
	[createUserId] [varchar](100) NULL,
	[members] [varchar](4000) NULL
) ON [PRIMARY]
GO