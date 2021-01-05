INSERT INTO HtmlLabelIndex values(17743,'同步Ldap数据')
/
INSERT INTO HtmlLabelInfo VALUES(17743,'同步Ldap数据',7)
/
INSERT INTO HtmlLabelInfo VALUES(17743,'synchronize ldap data',8)
/

INSERT INTO HtmlLabelIndex values(17744,'更新')
/
INSERT INTO HtmlLabelInfo VALUES(17744,'更新',7)
/
INSERT INTO HtmlLabelInfo VALUES(17744,'update',8)
/

alter table hrmresource add account varchar2(60)
/
alter table hrmresource add lloginid varchar2(60)
/
call MMConfig_U_ByInfoInsert (46,14)
/
call MMInfo_Insert (375,17743,'同步Ldap数据','/hrm/resource/ExportHrmFromLdap.jsp','mainFrame',46,2,14,0,'HrmResourceAdd:Add',0,'',0,'MenuSwitch','canExportLdap',0,'','',2)
/

