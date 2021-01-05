delete from HtmlLabelIndex where id in (20023,20024,20025,20026)
go
delete from HtmlLabelInfo where indexid in (20023,20024,20025,20026)
go

INSERT INTO HtmlLabelIndex values(20023,'说明：请继续文件导入的字段映射操作，将右侧下拉框中的导入文件字段与左侧联系人字段进行对应。
如：导入文件中的“移动电话”字段与系统的“手机”字段对应。') 
GO
INSERT INTO HtmlLabelIndex values(20024,'说明：选择“以逗号为分隔符的CSV文件”可以将其它软件（如Outlook、Foxmail）导出的联系人信息导入邮件联系人中。') 
GO
INSERT INTO HtmlLabelIndex values(20025,'说明：选择“人力资源”类型可以将系统用户导入邮件联系人中。在联系人中删除导入的用户不会影响人力资源模块的数据。') 
GO
INSERT INTO HtmlLabelIndex values(20026,'说明：选择“客户联系人”类型可以将系统中的客户联系人导入邮件联系人中。在联系人中删除导入的用户不会影响客户资源模块的数据。') 
GO
INSERT INTO HtmlLabelInfo VALUES(20023,'说明：请继续文件导入的字段映射操作，将右侧下拉框中的导入文件字段与左侧联系人字段进行对应。如：导入文件中的“移动电话”字段与系统的“手机”字段对应。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20023,'Help: please establish field mapping between CSV and Mail Contacters.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20024,'说明：选择“以逗号为分隔符的CSV文件”可以将其它软件（如Outlook、Foxmail）导出的联系人信息导入邮件联系人中。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20024,'Help: you can import data from CSV into Mail Contacter.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20025,'说明：选择“人力资源”类型可以将系统用户导入邮件联系人中。在联系人中删除导入的用户不会影响人力资源模块的数据。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20025,'Help: you can import users from HRM into Mail Contacter.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20026,'说明：选择“客户联系人”类型可以将系统中的客户联系人导入邮件联系人中。在联系人中删除导入的用户不会影响客户资源模块的数据。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20026,'Help: you can import contacters from CRM into Mail Contacter.',8) 
GO
