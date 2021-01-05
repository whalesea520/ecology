ALTER table  hpElementSettingDetail  Add currentTab varchar2(2)
/
update  hpElementSettingDetail set currentTab = '0'
/
