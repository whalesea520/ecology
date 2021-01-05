alter table workflow_base add isSignMustInput char(1) null
GO
update workflow_base set isSignMustInput='0'
GO
