CREATE TABLE [social_ImSignatures](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [varchar](100) NULL,
	[signatures] [varchar](1000) NULL,
	[signdate] [varchar](100) NULL
) ON [PRIMARY]
GO