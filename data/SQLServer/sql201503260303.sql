alter table workflow_agent add  isProxyDeal varchar(150)
GO

CREATE TABLE workflow_agentConditionSet(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[agentid] [varchar](250) NULL,
	[bagentuid] [varchar](350) NULL,
	[agentuid] [varchar](350) NULL,
	[conditionss] [text] NULL,
	[conditioncn] [text] NULL,
	[conditionkeyid] [varchar](450) NULL,
	[beginDate] [varchar](450) NULL,
	[beginTime] [varchar](450) NULL,
	[endDate] [varchar](450) NULL,
	[endTime] [varchar](450) NULL,
	[workflowid] [varchar](4500) NULL,
	[Recoverstate] [varchar](4500) NULL,
	[isCreateAgenter] [varchar](450) NULL,
	[agenttype] [varchar](450) NULL,
	[isProxyDeal] [varchar](450) NULL,
	[isPendThing] [varchar](450) NULL,
	[operatorid] [varchar](450) NULL,
	[operatordate] [varchar](450) NULL,
	[operatortime] [varchar](450) NULL,
	[isSet] [varchar](450) NULL,
	[backDate] [varchar](450) NULL,
	[backTime] [varchar](450) NULL,
	[agentconditionid] [varchar](4500) NULL,
	[agentbatch] [varchar](550) NULL,
 CONSTRAINT [PK_workflow_agentConditionSet] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO