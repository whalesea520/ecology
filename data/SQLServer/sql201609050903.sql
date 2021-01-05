if object_id(N'fullSearch_FaqDetail',N'U') is not null
drop table fullSearch_FaqDetail
else 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [fullSearch_FaqDetail](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[faqLabel] [varchar](1000) NULL,
	[faqDesc] [varchar](1000) NULL,
	[faqlastmoddate] [char](10) NULL,
	[faqlastmodtime] [char](8) NULL,
	[faqAnswer] [text] NULL,
	[faqStatus] [int]  NOT NULL,
	[faqcreateDate] [char](10) NOT NULL,
	[faqCreateTime] [char](8) NOT NULL,
	[faqcreateId] [int] NOT NULL,
	[faqlasteditId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO