CREATE TABLE [social_imAllowWinDepart](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PERMISSIONTYPE] [int],
	[CONTENTS] [int],
	[SECLEVEL] [int],
	[SECLEVELMAX] [int] default(100),
	[JOBTITLEID] [varchar](1000),
	[JOBLEVEL] [int] default(0),
	[SCOPEID] [varchar](800)
) ON [PRIMARY]
GO