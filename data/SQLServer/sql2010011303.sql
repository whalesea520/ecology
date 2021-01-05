alter table workflow_formdict add imgheight int default(0)
GO
alter table workflow_formdict add imgwidth int default(0)
GO
alter table workflow_billfield add imgheight int default(0)
GO
alter table workflow_billfield add imgwidth int default(0)
GO
update workflow_formdict set textheight=0,imgheight=0,imgwidth=0 where fieldhtmltype='6'
GO
update workflow_billfield set textheight=0,imgheight=0,imgwidth=0 where fieldhtmltype='6'
GO
