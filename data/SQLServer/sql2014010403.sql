ALTER TABLE workflow_base ADD isfnabudgetwf CHAR(1) 
GO

ALTER TABLE FnaBudgetfeeType ADD feeCtlLevel int 
GO

update FnaBudgetfeeType set feeCtlLevel = ''
GO




create table fnaBudgetSet(
	workflowid int primary key,
	km varchar(100),
	bxlx varchar(100),
	bxdw varchar(100),
	bxrq varchar(100),
	sqje varchar(100),
	grys varchar(100),
	bmys varchar(100),
	fbys varchar(100)
)
GO

alter table fnaBudgetSet add fkqd int
go

alter table fnaBudgetSet add cystxxx varchar(4000)
go


create table fnaWfFeeCtl(
	guid char(36) primary key,
	enable char(1)
)
GO

create table fnaWfFeeCtlFeeType(
	mainGuid char(36) not null,
	feeTypeId int not null,
	checkType char(4)
) ON [PRIMARY]
GO

ALTER TABLE fnaWfFeeCtlFeeType ADD CONSTRAINT
	PK_fnaWfFeeCtlFeeType PRIMARY KEY CLUSTERED 
	(
		mainGuid, feeTypeId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

create table fnaWfFeeCtlWf(
	mainGuid char(36) not null,
	workflowId int not null
) ON [PRIMARY]
GO

ALTER TABLE fnaWfFeeCtlWf ADD CONSTRAINT
	PK_fnaWfFeeCtlWf PRIMARY KEY CLUSTERED 
	(
		mainGuid, workflowId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE TABLE [fnabudgetCostControl](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[workflowid] [int] NULL,
	[km] [int] NULL,
	[fylx] [int] NULL,
	[fydw] [varchar](4000) NULL,
 CONSTRAINT [PK_fnabudgetCostControl] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [idx_fnabudgetCostControl1] ON [fnabudgetCostControl] 
(
	[workflowid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnabudgetCostControl2] ON [fnabudgetCostControl] 
(
	[fylx] ASC,
	[km] ASC,
	[workflowid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

alter table fnabudgetCostControl add jy int
go

alter table FnaExpenseInfo add guid char(32)
go