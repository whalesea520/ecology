CREATE TABLE fnaRptRuleSet(
	id int IDENTITY(1,1) primary key,
	roleid int NOT NULL,
	allowZb int NOT NULL,
	name varchar(4000) NULL
)
GO

alter table fnaRptRuleSet add allowFb int 
GO
alter table fnaRptRuleSet add allowBm int 
GO
alter table fnaRptRuleSet add allowFcc int 
GO

CREATE INDEX idx_fnaRptRuleSet_1 ON fnaRptRuleSet (roleid) 
GO
CREATE INDEX idx_fnaRptRuleSet_2 ON fnaRptRuleSet (allowZb) 
GO
CREATE INDEX idx_fnaRptRuleSet_3 ON fnaRptRuleSet (allowFb) 
GO
CREATE INDEX idx_fnaRptRuleSet_4 ON fnaRptRuleSet (allowBm) 
GO
CREATE INDEX idx_fnaRptRuleSet_5 ON fnaRptRuleSet (allowFcc) 
GO

CREATE TABLE fnaRptRuleSetDtl(
	id int IDENTITY(1,1) primary key,
	mainid int NOT NULL,
	showid int NOT NULL,
	showidtype int NOT NULL
)
GO

CREATE INDEX idx_fnaRptRuleSetDtl_1 ON fnaRptRuleSetDtl (mainid) 
GO
CREATE INDEX idx_fnaRptRuleSetDtl_2 ON fnaRptRuleSetDtl (showid) 
GO
CREATE INDEX idx_fnaRptRuleSetDtl_3 ON fnaRptRuleSetDtl (showidtype) 
GO


alter table FnaSystemSet add enableRptCtrl int 
GO

update FnaSystemSet set enableRptCtrl = 0
GO