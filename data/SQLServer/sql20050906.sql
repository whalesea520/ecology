INSERT INTO HtmlLabelIndex values(17887,'人员导入')
go
INSERT INTO HtmlLabelInfo VALUES(17887,'人员导入',7)
go
INSERT INTO HtmlLabelInfo VALUES(17887,'human resource import',8)
go

EXECUTE	MMConfig_U_ByInfoInsert 46,13
go
EXECUTE MMInfo_Insert 387,17887,'人员导入','/hrm/resource/HrmImport.jsp','mainFrame',46,2,13,0,'',0,'',0,'','',0,'','',2
go

