delete from HtmlLabelIndex where id=32663 
GO
delete from HtmlLabelInfo where indexid=32663 
GO
INSERT INTO HtmlLabelIndex values(32663,'批准办结事宜') 
GO
INSERT INTO HtmlLabelInfo VALUES(32663,'批准办结事宜',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32663,'Approved Complete Matters',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32663,'批準辦結事宜',9) 
GO

delete from HtmlLabelIndex where id=32664 
GO
delete from HtmlLabelInfo where indexid=32664 
GO
INSERT INTO HtmlLabelIndex values(32664,'退回办结事宜') 
GO
INSERT INTO HtmlLabelInfo VALUES(32664,'退回办结事宜',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32664,'Rejected Complete Matters',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32664,'退回辦結事宜',9) 
GO

