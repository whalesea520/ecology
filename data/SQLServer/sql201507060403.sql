INSERT INTO workflow_browdef_fieldconf (id,fieldtype,fieldname,namelabel,conditionfieldtype,defaultshoworder) 
VALUES(91,22,'fnabudgetfeetype',854,'fnabudgetfeetype','1.5')
GO
INSERT INTO workflow_browdef_fieldconf (id,fieldtype,fieldname,namelabel,conditionfieldtype,defaultshoworder) 
VALUES(92,251,'fnacostcenter',515,'fnacostcenter','1.5')
GO

CREATE TABLE [FnaFeetypeWfbrowdef](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[workflowid] [int] NULL,
	[fieldId] [int] NULL,
	[viewType] [int] NULL,
	[fieldType] [int] NULL,
	[title] [varchar](2000) NULL,
 CONSTRAINT [PK_FnaFeetypeWfbrowdef] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [idx_FnaFeetypeWfbrowdef_workflowid] ON [FnaFeetypeWfbrowdef] 
(
	[workflowid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_FnaFeetypeWfbrowdef_fieldid] ON [FnaFeetypeWfbrowdef] 
(
	[fieldId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_FnaFeetypeWfbrowdef_fieldType] ON [FnaFeetypeWfbrowdef] 
(
	[fieldType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE TABLE [FnaFeetypeWfbrowdef_dt1](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[mainid] [int] NULL,
	[refid] [int] NULL,
 CONSTRAINT [PK_FnaFeetypeWfbrowdef_dt1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [idx_FnaFeetypeWfbrowdefD_mainid] ON [FnaFeetypeWfbrowdef_dt1] 
(
	[mainid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
