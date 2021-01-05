alter table docseccategory add bacthDownload integer default 0
GO
update docseccategory set bacthDownload=0 where 1=1
go
alter table workflow_base add forbidAttDownload integer default 0
GO
update workflow_base set forbidAttDownload=0 where 1=1
GO