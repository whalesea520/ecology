alter table BudgetAuditMapping add fccId INT
GO

create table FnaRuleSetDtlFcc(
  id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  mainid INT not null,
  showid INT not null,
	showidtype int not null
)
GO

create table FnaCostCenter(
  id int IDENTITY(1,1) PRIMARY KEY,
  supFccId int,
  type int,
  name char(100),
  code char(50),
  Archive int,
  description varchar(4000)
)
go

CREATE NONCLUSTERED INDEX [idx_FnaCostCenter_1] ON [FnaCostCenter](
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_FnaCostCenter_2] ON [FnaCostCenter](
	[code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


create table FnaCostCenterDtl(
  id int IDENTITY(1,1) PRIMARY KEY,
  fccId int,
  type int,
  objId int
)
go

CREATE NONCLUSTERED INDEX [idx_FnaCostCenterDtl_1] ON [FnaCostCenterDtl](
	[fccId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [idx_FnaCostCenterDtl_2] ON [FnaCostCenterDtl](
	[type] ASC,
	[fccId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

ALTER TABLE FnaSystemSet ADD fnaBudgetOAOrg INT
GO

ALTER TABLE FnaSystemSet ADD fnaBudgetCostCenter INT
GO

update FnaSystemSet set fnaBudgetOAOrg=1
GO

update FnaSystemSet set fnaBudgetCostCenter=0
GO

Create function getFccArchive1(@pId INT) 
returns INT
as 
begin 
  declare @pCnt int;

	WITH allsub(id,name,supFccId,archive,code)
	as (
	SELECT id,name,supFccId,archive,code FROM FnaCostCenter where id=@pId
	 UNION ALL SELECT aa.id,aa.name,aa.supFccId,aa.archive,aa.code FROM FnaCostCenter aa,allsub b where aa.id = b.supFccId 
	) select @pCnt = count(*) from allsub tt where tt.archive = 1 

  return @pCnt 
end
GO



INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) 
VALUES (158,'fccremain',515,'varchar(4000)',1,1,246,1,'Bill_FnaWipeApplyDetail')
GO

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) 
VALUES (156,'fccremain',515,'varchar(4000)',1,1,61,1,'Bill_FnaPayApplyDetail')
GO




INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) 
VALUES ( 251,515,'int','/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/single/FccBrowser.jsp','FnaCostCenter','name','id','')
GO




INSERT INTO workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault, isaccordtosubcom) 
VALUES (717, 1, 18004, '成本中心', 3.00, 'n', 0)
GO



INSERT INTO workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault, isaccordtosubcom) 
VALUES (715, 1, 18004, '成本中心', 3.00, 'n', 0)
GO




INSERT INTO workflow_SelectItem (fieldid, isbill, selectvalue, selectname, listorder, isdefault, isaccordtosubcom) 
VALUES (716, 1, 18004, '成本中心', 3.00, 'n', 0)
GO



ALTER TABLE Bill_FnaWipeApplyDetail ADD fccremain varchar(4000)
GO


ALTER TABLE Bill_FnaPayApplyDetail ADD fccremain varchar(4000)
GO