delete from HtmlLabelIndex where id=24008 
GO
delete from HtmlLabelInfo where indexid=24008 
GO
INSERT INTO HtmlLabelIndex values(24008,'流程附件是否转为正文附件') 
GO
delete from HtmlLabelIndex where id=24009 
GO
delete from HtmlLabelInfo where indexid=24009 
GO
INSERT INTO HtmlLabelIndex values(24009,'如勾选，则当流程正文状态变为“正常”或“归档”时，将流程附件转为正文附件保存。') 
GO
INSERT INTO HtmlLabelInfo VALUES(24008,'流程附件是否转为正文附件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24008,'Whether the annex to the body attachment process',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24008,'流程附件是否轉為正文附件',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24009,'如勾选，则当流程正文状态变为“正常”或“归档”时，将流程附件转为正文附件保存。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24009,'If checked, then when the body of the state process into a "normal" or "archive", it will flow into the body of the annex to save the attachment.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24009,'如勾選，則當流程正文狀態變為“正常”或“歸檔”時，將流程附件轉為正文附件保存。',9) 
GO
