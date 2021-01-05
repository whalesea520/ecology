alter table workflow_base add wfdocownertype integer null
/
alter table workflow_base add wfdocownerfieldid integer null
/
update workflow_base set wfdocownertype=1 where wfdocowner>0
/
