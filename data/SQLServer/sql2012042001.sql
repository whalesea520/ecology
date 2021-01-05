delete from HtmlLabelIndex where id=28056 
GO
delete from HtmlLabelInfo where indexid=28056 
GO
INSERT INTO HtmlLabelIndex values(28056,'测试流程删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(28056,'测试流程删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28056,'Delete Test-Request',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28056,'測試流程删除',9) 
GO

delete from HtmlLabelIndex where id=28057 
GO
delete from HtmlLabelInfo where indexid=28057 
GO
INSERT INTO HtmlLabelIndex values(28057,'测试流程新建') 
GO
INSERT INTO HtmlLabelInfo VALUES(28057,'测试流程新建',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28057,'Create Test-Request',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28057,'測試流程新建',9) 
GO

delete from HtmlLabelIndex where id=28058 
GO
delete from HtmlLabelInfo where indexid=28058 
GO
INSERT INTO HtmlLabelIndex values(28058,'该流程类型下存在测试流程数据，请先删除测试流程数据！') 
GO
INSERT INTO HtmlLabelInfo VALUES(28058,'该流程类型下存在测试流程数据，请先删除测试流程数据！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28058,'Exists Test-Request on this workflow.Please delete them first.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28058,'該流程類型下存在測試流程數據，請先删除測試流程數據！',9) 
GO
