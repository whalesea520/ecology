alter table workflow_formdict add imgheight integer default(0)
/
alter table workflow_formdict add imgwidth integer default(0)
/
alter table workflow_billfield add imgheight integer default(0)
/
alter table workflow_billfield add imgwidth integer default(0)
/
update workflow_formdict set textheight=0,imgheight=0,imgwidth=0 where fieldhtmltype='6'
/
update workflow_billfield set textheight=0,imgheight=0,imgwidth=0 where fieldhtmltype='6'
/
