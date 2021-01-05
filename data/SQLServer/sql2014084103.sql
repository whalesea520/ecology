alter table workflow_flownode add nodeorder int
GO
alter table workflow_nodelink add linkorder int
GO
alter table workflow_base add fieldNotImport text
GO
CREATE TABLE  [workflow_viewlog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[p_nodeid] [varchar](250) NULL,
	[p_opteruid] [varchar](250) NULL,
	[p_date] [varchar](250) NULL,
	[p_addip] [varchar](250) NULL,
	[p_number] [varchar](250) NULL,
	[requestid] [varchar](250) NULL,
	[p_nodename] [varchar](150) NULL,
	[requestname] [varchar](550) NULL,
	[workflowtype] [varchar](550) NULL,
	[workflowtypeid] [varchar](550) NULL,
	[workflowid] [varchar](550) NULL
)
GO

CREATE TABLE [Workflow_SetTitle](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[xh] [varchar](250) NULL,
	[fieldtype] [varchar](250) NULL,
	[fieldvalue] [varchar](250) NULL,
	[fieldlevle] [varchar](250) NULL,
	[fieldname] [varchar](350) NULL,
	[fieldzx] [varchar](150) NULL,
	[workflowid] [varchar](200) NULL,
	[trrowid] [varchar](200) NULL,
	[txtUserUse] [varchar](50) NULL,
	[showhtml] [varchar](500) NULL
)
GO


