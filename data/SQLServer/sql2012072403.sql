alter table workflow_base add isneeddelacc varchar(1)
GO
update workflow_base set isneeddelacc='0'
GO