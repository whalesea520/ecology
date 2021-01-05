delete from HtmlLabelIndex  where id=20098
GO
delete from HtmlLabelInfo   where indexId=20098
GO
INSERT INTO HtmlLabelIndex values(20098,'工作人员') 
GO
INSERT INTO HtmlLabelInfo VALUES(20098,'工作人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20098,'employee',8) 
GO
delete from HtmlLabelIndex  where id=20388
GO
delete from HtmlLabelInfo   where indexId=20388
GO
INSERT INTO HtmlLabelIndex values(20388,'新建工作记录') 
GO
INSERT INTO HtmlLabelInfo VALUES(20388,'新建工作记录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20388,'New Working Record',8) 
GO
delete from HtmlLabelIndex  where id=20389
GO
delete from HtmlLabelInfo   where indexId=20389
GO
INSERT INTO HtmlLabelIndex values(20389,'服务器正在处理客户联系人导入,请稍等...') 
GO
INSERT INTO HtmlLabelInfo VALUES(20389,'服务器正在处理客户联系人导入,请稍等...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20389,'Customer contacter loading,please wait...',8) 
GO

delete from HtmlLabelIndex  where id=20390
GO
delete from HtmlLabelInfo   where indexId=20390
GO
INSERT INTO HtmlLabelIndex values(20390,'客户联系人导入成功！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20390,'客户联系人导入成功！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20390,'Customer contacter import successfully!',8) 
GO
