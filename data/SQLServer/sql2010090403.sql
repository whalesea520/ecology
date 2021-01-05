ALTER table  hpElementSettingDetail  Add currentTab varchar(2)
GO
update  hpElementSettingDetail set currentTab = '0'
GO
