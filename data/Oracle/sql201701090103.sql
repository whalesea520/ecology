update fnaRptRuleSet 
set allowFb = 4 
where exists (select 1 from fnaRptRuleSetDtl where showidtype=1 and fnaRptRuleSetDtl.mainid = fnaRptRuleSet.id) 
and allowFb = 1 
/

update fnaRptRuleSet 
set allowBm = 4 
where exists (select 1 from fnaRptRuleSetDtl where showidtype=2 and fnaRptRuleSetDtl.mainid = fnaRptRuleSet.id) 
and allowBm = 1 
/

update fnaRptRuleSet 
set allowFcc = 4 
where exists (select 1 from fnaRptRuleSetDtl where showidtype=18004 and fnaRptRuleSetDtl.mainid = fnaRptRuleSet.id) 
and allowFcc = 1 
/