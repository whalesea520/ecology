delete from HtmlLabelIndex where id=22177 
GO
delete from HtmlLabelInfo where indexid=22177 
GO
INSERT INTO HtmlLabelIndex values(22177,'日程结束') 
GO
INSERT INTO HtmlLabelInfo VALUES(22177,'日程结束',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22177,'finish workplan',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22177,'',9) 
GO

delete from HtmlLabelIndex where id=22185 
GO
delete from HtmlLabelInfo where indexid=22185 
GO
INSERT INTO HtmlLabelIndex values(22185,'签字意见是否必填') 
GO
INSERT INTO HtmlLabelInfo VALUES(22185,'签字意见是否必填',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22185,'Sign must been input or not',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22185,'簽字意見是否必填',9) 
GO
