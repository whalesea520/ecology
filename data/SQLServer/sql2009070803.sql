alter table hpsetting_wfcenter add  showCopy varchar(5)
GO
update hpsetting_wfcenter set showCopy = '1'
GO