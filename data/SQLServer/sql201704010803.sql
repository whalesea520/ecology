alter table FnaRuleSet add allowFb int 
GO

alter table FnaRuleSet add allowBm int 
GO

alter table FnaRuleSet add allowFcc int 
GO


update FnaRuleSet set allowFb = (CASE WHEN (select count(*) cnt from fnaRuleSetDtl1 where FnaRuleSet.id = fnaRuleSetDtl1.mainid) > 0 THEN 4 ELSE 1 END)
GO

update FnaRuleSet set allowBm = (CASE WHEN (select count(*) cnt from fnaRuleSetDtl where FnaRuleSet.id = fnaRuleSetDtl.mainid) > 0 THEN 4 ELSE 1 END)
GO

update FnaRuleSet set allowFcc = (CASE WHEN (select count(*) cnt from FnaRuleSetDtlFcc where FnaRuleSet.id = FnaRuleSetDtlFcc.mainid) > 0 THEN 4 ELSE 1 END)
GO

update FnaRuleSetDtl set showidtype = 2
GO

INSERT INTO FnaRuleSetDtl (mainid, showid, showidtype) 
select mainid, showid, 1 from FnaRuleSetDtl1 
GO

INSERT INTO FnaRuleSetDtl (mainid, showid, showidtype) 
select mainid, showid, 18004 from FnaRuleSetDtlFcc 
GO