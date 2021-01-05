delete from HtmlLabelIndex where id=20578 
GO
delete from HtmlLabelInfo where indexid=20578 
GO
INSERT INTO HtmlLabelIndex values(20578,'起始编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(20578,'起始编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20578,'Start Code',8) 
GO
 

delete from HtmlLabelIndex where id=21189 
GO
delete from HtmlLabelInfo where indexid=21189 
GO
INSERT INTO HtmlLabelIndex values(21189,'流程单独流水') 
GO
INSERT INTO HtmlLabelInfo VALUES(21189,'流程单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21189,'Workflow Sequence Alone',8) 
GO


delete from HtmlLabelIndex where id=21190 
GO
delete from HtmlLabelInfo where indexid=21190 
GO
INSERT INTO HtmlLabelIndex values(21190,'开始年份不能大于结束年份！') 
GO
delete from HtmlLabelIndex where id=21191 
GO
delete from HtmlLabelInfo where indexid=21191 
GO
INSERT INTO HtmlLabelIndex values(21191,'开始月份不能大于结束月份！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21190,'开始年份不能大于结束年份！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21190,'BeginYear cann''t be greater than OverYear!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21191,'开始月份不能大于结束月份！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21191,'BeginMonth cann''t be greater than OverMonth!',8) 
GO


