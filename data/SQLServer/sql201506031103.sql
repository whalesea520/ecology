update workflow_base set isshowchart=''   where formid in(42,40,154,152,49,241,38,10,41,39,13)
GO
update workflow_billfunctionlist set indShowChart='0' where billid in(42,40,154,152,49,241,38,10,41,39,13)
GO