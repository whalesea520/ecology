create table WorkflowToFinanceUrl(
  id int primary key IDENTITY(1,1) NOT NULL,
  guid1 varchar(50),
  sendUrl varchar(4000),

  requestid int,
  requestids text,
  fnaVoucherXmlId int,
  
  xmlSend text,
  xmlReceive text, 
  
  xmlObjSend text,
  xmlObjReceive text, 
  
  createDate char(10),
  createTime char(8)
)
GO

CREATE NONCLUSTERED INDEX [idx_WorkflowToFinanceUrl_1] ON [WorkflowToFinanceUrl](
	[guid1] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_WorkflowToFinanceUrl_2] ON [WorkflowToFinanceUrl](
	[requestid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

create table FnaCreateXmlSqlLog(
  id int primary key IDENTITY(1,1) NOT NULL,
  guid1 varchar(50),
  exeSql text
)
GO

CREATE NONCLUSTERED INDEX [idx_FnaCreateXmlSqlLog_1] ON [FnaCreateXmlSqlLog](
	[guid1] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

create table fnaVoucherXml(
  id int primary key IDENTITY(1,1) NOT NULL,
  xmlName char(100),
  xmlMemo varchar(4000),
  
  xmlVersion char(10),
  xmlEncoding char(50)
)
go

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXml_1] ON [fnaVoucherXml](
	[xmlName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

create table fnaVoucherXmlContent(
  id int primary key IDENTITY(1,1) NOT NULL,
  fnaVoucherXmlId int, 
  
  contentType char(1), 
  contentParentId int, 
  
  contentName varchar(100),
  contentValue text, 
  
  parameter text, 
  
  contentValueType char(1), 
  
  contentMemo varchar(4000),

  orderId decimal(5,2) 
)
go

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContent_1] ON [fnaVoucherXmlContent](
	[fnaVoucherXmlId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContent_2] ON [fnaVoucherXmlContent](
	[contentType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContent_3] ON [fnaVoucherXmlContent](
	[contentParentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContent_4] ON [fnaVoucherXmlContent](
	[contentValueType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContent_5] ON [fnaVoucherXmlContent](
	[orderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

create table fnaVoucherXmlContentDset(
  id int primary key IDENTITY(1,1) NOT NULL,
  fnaVoucherXmlId int, 
  fnaVoucherXmlContentId int, 
  dSetAlias varchar(200),

  initTiming int,
  
  fnaDataSetId int,
  
  parameter text, 
  
  dsetMemo varchar(4000),
  
  orderId decimal(5,2)
)
go

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContentDset_1] ON [fnaVoucherXmlContentDset](
	[fnaVoucherXmlContentId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContentDset_2] ON [fnaVoucherXmlContentDset](
	[fnaDataSetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaVoucherXmlContentDset_3] ON [fnaVoucherXmlContentDset](
	[orderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

create table fnaDataSet(
  id int primary key IDENTITY(1,1) NOT NULL,
  dSetName char(100),
  
  dataSourceName char(50),
  
  dsMemo varchar(4000),
    
  dSetType char(1), 
  dSetStr text  
)
go

CREATE NONCLUSTERED INDEX [idx_fnaDataSet_1] ON [fnaDataSet](
	[dSetName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaDataSet_2] ON [fnaDataSet](
	[dataSourceName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_fnaDataSet_3] ON [fnaDataSet](
	[dSetType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO




alter table Workflow_Report add fnaVoucherXmlId int
GO

alter table financeset add urlAddress VARCHAR(4000)
GO

alter table financeset add fnaVoucherXmlId int
GO

alter table fnaDataSet add fnaVoucherXmlId int 
GO

alter table fnaVoucherXml add workflowid int
GO

alter table fnaVoucherXml add typename VARCHAR(50)
GO

alter table fnaVoucherXml add datasourceid VARCHAR(500)
GO

create table fnaFinancesetting(
  guid1 CHAR(32) PRIMARY KEY, 
  fnaVoucherXmlId INT, 
  fieldName VARCHAR(100), 
  fieldValueType1 CHAR(20), 
  fieldValueType2 CHAR(20), 
  fieldValue VARCHAR(4000),
  fieldDbTbName CHAR(100), 
  detailTable INT, 
  fieldDbName CHAR(100), 
  fieldDbType CHAR(20) 
)
GO

CREATE NONCLUSTERED INDEX [idx_fnaFinancesetting_2] ON [fnaFinancesetting](
	[fnaVoucherXmlId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

alter table fnaFinancesetting add datasourceid VARCHAR(500)
GO
