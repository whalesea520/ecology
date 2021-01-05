CREATE TABLE session_table(
	[sessionId] [varchar](50) NOT NULL,
	[accessTime] [bigint] NOT NULL,
	[userId] [int] NOT NULL,
	[fromnode][varchar](20),
UNIQUE NONCLUSTERED 
(
	[sessionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE session_item_table(
	[sessionId] [varchar](50) NOT NULL,
	[sessionKey] [varchar](200) NOT NULL,
	[sessionVal] [varbinary](max) NULL,
	[createTime] [bigint] NOT NULL
) ON [PRIMARY]

GO

alter table session_item_table add primary key(sessionId,sessionKey)

GO