delete from HtmlLabelIndex where id=18360 
GO
delete from HtmlLabelInfo where indexid=18360 
GO
INSERT INTO HtmlLabelIndex values(18360,'强制归档') 
GO
INSERT INTO HtmlLabelInfo VALUES(18360,'强制归档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18360,'Mandatory Archiving',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18360,'強制歸檔',9) 
GO

delete from HtmlLabelIndex where id=18359 
GO
delete from HtmlLabelInfo where indexid=18359 
GO
INSERT INTO HtmlLabelIndex values(18359,'强制收回') 
GO
INSERT INTO HtmlLabelInfo VALUES(18359,'强制收回',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18359,'Mandatory Repossessed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18359,'強制收回',9) 
GO
 
delete from HtmlLabelIndex where id=18976 
GO
delete from HtmlLabelInfo where indexid=18976 
GO
INSERT INTO HtmlLabelIndex values(18976,'此目录下最大只能上传') 
GO
INSERT INTO HtmlLabelInfo VALUES(18976,'此目录下最大只能上传',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18976,'Maximum can only upload',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18976,'此目錄下最大只能上傳',9) 
GO
 
delete from HtmlNoteIndex where id=97 
GO
delete from HtmlNoteInfo where indexid=97 
GO
INSERT INTO HtmlNoteIndex values(97,'（必填）') 
GO
INSERT INTO HtmlNoteInfo VALUES(97,'（必填）',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(97,'(Required)',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(97,'（必填）',9) 
GO