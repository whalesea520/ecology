update workflow_billfield set type=1,fieldhtmltype=3 where billid = 158 and viewtype = 1 and fieldname = 'organizationid'
/
update workflow_selectitem set isdefault = 'n' where isbill = 1 and fieldid = (select id from workflow_billfield where billid = 158 and viewtype = 1 and fieldname = 'organizationtype')
/
update workflow_selectitem set isdefault = 'y' where isbill = 1 and fieldid = (select id from workflow_billfield where billid = 158 and viewtype = 1 and fieldname = 'organizationtype') and selectvalue = 3
/
