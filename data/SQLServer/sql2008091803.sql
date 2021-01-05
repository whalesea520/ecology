alter table SystemSet add isUseOldWfMode char(1)
GO
update SystemSet set isUseOldWfMode='1'
GO
