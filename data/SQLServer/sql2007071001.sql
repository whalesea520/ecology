delete from HtmlLabelIndex where id in (20539,20545,20547)
go
delete from HtmlLabelInfo where indexid in (20539,20545,20547)
go
INSERT INTO HtmlLabelIndex values(20539,'项目规模') 
GO
INSERT INTO HtmlLabelInfo VALUES(20539,'项目规模',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20539,'Project Size',8) 
GO
INSERT INTO HtmlLabelIndex values(20545,'部门项目经理工作状况一览表') 
GO
INSERT INTO HtmlLabelInfo VALUES(20545,'部门项目经理工作状况一览表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20545,'The Work Report of Project Manager',8) 
GO
INSERT INTO HtmlLabelIndex values(20547,'项目成本核算表') 
GO
INSERT INTO HtmlLabelInfo VALUES(20547,'项目成本核算表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20547,'Project Cost Calculate',8) 
GO