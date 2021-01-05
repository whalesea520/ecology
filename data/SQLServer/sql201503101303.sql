CREATE TABLE TB_NULL(
  id INT PRIMARY KEY,
  guid1 VARCHAR(250)
)
GO


CREATE TABLE fnaTmpTbLog(
  id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
  rptTypeName VARCHAR(100),
  guid1 VARCHAR(250),
	isTemp INT,
	tbName VARCHAR(500),
	tbDbName VARCHAR(250),
	description VARCHAR(4000),
	createDate char(10),
	createTime char(8),
	creater INT,
	qryConds text
)
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLog_rptTypeName] ON [fnaTmpTbLog] 
(
	[rptTypeName] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLog_guid1] ON [fnaTmpTbLog] 
(
	[guid1] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLog_creater] ON [fnaTmpTbLog] 
(
	[creater] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLog_isTemp] ON [fnaTmpTbLog] 
(
	[isTemp] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLog_createDate] ON [fnaTmpTbLog] 
(
	[createDate] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO



CREATE TABLE fnaTmpTbLogShare(
	id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	fnaTmpTbLogId INT,
	groupGuid1 VARCHAR(250),
	shareType INT,
	shareId INT,
	secLevel1 INT,
	secLevel2 INT,
	shareLevel INT
)
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLogShare_fkId] ON [fnaTmpTbLogShare] 
(
	[fnaTmpTbLogId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLogShare_gg1] ON [fnaTmpTbLogShare] 
(
	[groupGuid1] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLogShare_type] ON [fnaTmpTbLogShare] 
(
	[shareType] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLogShare_fkId2] ON [fnaTmpTbLogShare] 
(
	[shareId] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLogShare_sec1] ON [fnaTmpTbLogShare] 
(
	[secLevel1] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLogShare_sec2] ON [fnaTmpTbLogShare] 
(
	[secLevel2] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idx_fnaTmpTbLogShare_sl] ON [fnaTmpTbLogShare] 
(
	[shareLevel] ASC
)WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

Create function getFeeTypeFeeperiod(@pId INT) 
returns INT
as 
begin 
  declare @pCnt int;

	WITH allsub(id,name,supsubject,archive,feeperiod)
	as (
	SELECT id,name,supsubject,archive,feeperiod FROM FnaBudgetfeeType where id=@pId
	 UNION ALL SELECT aa.id,aa.name,aa.supsubject,aa.archive,aa.feeperiod FROM FnaBudgetfeeType aa,allsub b where aa.id = b.supsubject 
	) select DISTINCT @pCnt = feeperiod from allsub tt where tt.supsubject = 0 ; 
	
  return @pCnt 
end
GO

Create function getFeeTypeArchive1(@pId INT) 
returns INT
as 
begin 
  declare @pCnt int;

	WITH allsub(id,name,supsubject,archive,feeperiod)
	as (
	SELECT id,name,supsubject,archive,feeperiod FROM FnaBudgetfeeType where id=@pId
	 UNION ALL SELECT aa.id,aa.name,aa.supsubject,aa.archive,aa.feeperiod FROM FnaBudgetfeeType aa,allsub b where aa.id = b.supsubject 
	) select @pCnt = count(*) from allsub tt where tt.archive = 1 ; 
	
  return @pCnt 
end
GO