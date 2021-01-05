alter table hpsetting_wfcenter add isExclude char(1) default '0'
GO
update hpsetting_wfcenter set isExclude='0'
GO
