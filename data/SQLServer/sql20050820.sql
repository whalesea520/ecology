INSERT INTO HtmlLabelIndex values(17743,'同步Ldap数据')
GO
INSERT INTO HtmlLabelInfo VALUES(17743,'同步Ldap数据',7)
GO
INSERT INTO HtmlLabelInfo VALUES(17743,'synchronize ldap data',8)
GO

INSERT INTO HtmlLabelIndex values(17744,'更新')
GO
INSERT INTO HtmlLabelInfo VALUES(17744,'更新',7)
GO
INSERT INTO HtmlLabelInfo VALUES(17744,'update',8)
GO

alter table hrmresource add account varchar(60)
go
alter table hrmresource add lloginid varchar(60)
go
EXECUTE MMConfig_U_ByInfoInsert 46,14
GO
EXECUTE MMInfo_Insert 375,17743,'同步Ldap数据','/hrm/resource/ExportHrmFromLdap.jsp','mainFrame',46,2,14,0,'HrmResourceAdd:Add',0,'',0,'MenuSwitch','canExportLdap',0,'','',2
GO

