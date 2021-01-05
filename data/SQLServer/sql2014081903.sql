alter table FnaBudgetfeeType add groupCtrl char(1)
GO

update FnaBudgetfeeType set groupCtrl = null where feelevel = 1 or feelevel = 2
GO

update FnaBudgetfeeType set groupCtrl = '1' where feelevel = 3
GO

ALTER TABLE FnaBudgetfeeType add isEditFeeType INT
GO

update FnaBudgetfeeType set isEditFeeType = 0 
GO




update workflow_browserurl set linkurl = '/fna/budget/FnaBudgetView.jsp?budgetinfoid=' where id = 134
GO

create table fnaRuleSet(
  id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  roleid INT not null,
  allowZb int not null,
	name VARCHAR(4000)
)
GO

create table fnaRuleSetDtl(
  id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  mainid INT not null,
  showid INT not null,
	showidtype int not null
)
GO

create table fnaRuleSetDtl1(
  id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  mainid INT not null,
  showid INT not null,
	showidtype int not null
)
GO

alter table FnaSystemSet add showHiddenSubject char(1)
GO

update FnaSystemSet set showHiddenSubject = '0'
GO



ALTER TABLE FnaSystemSet ADD remark VARCHAR(4000)
GO

ALTER TABLE FnaSystemSet ADD enableGlobalFnaCtrl int
GO

ALTER TABLE FnaSystemSet ADD alertvalue int
GO

ALTER TABLE FnaSystemSet ADD agreegap int
GO

update FnaSystemSet set enableGlobalFnaCtrl = 1
GO


CREATE TABLE fnaFeeWfInfo(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	workflowid INT,
	enable INT,
	lastModifiedDate CHAR(10)
)
GO

CREATE NONCLUSTERED INDEX [idx_fnaFeeWfInfo] ON [fnaFeeWfInfo](
	[workflowid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




CREATE TABLE fnaFeeWfInfoField(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	mainId INT,
	
	workflowid INT,
	formid INT,
	
	fieldType INT,
	fieldId INT,
	isDtl INT
)
GO

CREATE NONCLUSTERED INDEX [idx_fnaFeeWfInfoField] ON [fnaFeeWfInfoField](
	[mainId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



CREATE TABLE fnaFeeWfInfoLogic(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	mainId INT,
	
	kmIdsCondition INT,
	kmIds VARCHAR(4000),
	orgType INT,
	orgIdsCondition INT,
	orgIds VARCHAR(4000),
	
	intensity INT,
	
	promptSC VARCHAR(4000),
	promptTC VARCHAR(4000),
	promptEN VARCHAR(4000)
)
GO

CREATE NONCLUSTERED INDEX [idx_fnaFeeWfInfoLogic] ON [fnaFeeWfInfoLogic](
	[mainId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



CREATE TABLE fnaControlScheme(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	
	name char(60),
	code char(60),
	
	fnayearid INT,
	fnayearidEnd INT,
	
	enabled INT
)
GO

CREATE NONCLUSTERED INDEX [idx_fnaControlScheme_name] ON [fnaControlScheme](
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaControlScheme_code] ON [fnaControlScheme](
	[code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaControlScheme_fnayearid] ON [fnaControlScheme](
	[fnayearid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaControlScheme_enabled] ON [fnaControlScheme](
	[enabled] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



CREATE TABLE fnaControlSchemeDtl(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	mainId INT,
	
	kmIdsCondition INT,
	kmIds VARCHAR(4000),
	orgType INT,
	orgIdsCondition INT,
	orgIds VARCHAR(4000),
	
	intensity INT,
	
	promptSC VARCHAR(4000),
	promptTC VARCHAR(4000),
	promptEN VARCHAR(4000)
)
GO

CREATE NONCLUSTERED INDEX [idx_fnaControlSchemeDtl] ON [fnaControlSchemeDtl](
	[mainId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE TABLE fnaControlScheme_FeeWfInfo(
  fnaControlSchemeId int NOT NULL,
  fnaFeeWfInfoId int NOT NULL
)  ON [PRIMARY]
GO

ALTER TABLE fnaControlScheme_FeeWfInfo ADD CONSTRAINT
  PK_fnaControlScheme_FeeWfInfo PRIMARY KEY CLUSTERED(
    fnaControlSchemeId,
    fnaFeeWfInfoId
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



