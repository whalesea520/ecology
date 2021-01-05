delete from HtmlLabelIndex where id=130323 
GO
delete from HtmlLabelInfo where indexid=130323 
GO
INSERT INTO HtmlLabelIndex values(130323,'收文(发文)') 
GO
INSERT INTO HtmlLabelInfo VALUES(130323,'收文(发文)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130323,'receive(send)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130323,'收文(發文)',9) 
GO

delete from HtmlLabelIndex where id=130324 
GO
delete from HtmlLabelInfo where indexid=130324 
GO
INSERT INTO HtmlLabelIndex values(130324,'物理名') 
GO
INSERT INTO HtmlLabelInfo VALUES(130324,'物理名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(130324,'filename',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(130324,'物理名',9) 
GO