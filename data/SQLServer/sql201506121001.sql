alter table MODE_CUSTOMBROWSER add isworkflowdata int
GO
delete from HtmlLabelIndex where id=84644 
GO
delete from HtmlLabelInfo where indexid=84644 
GO
INSERT INTO HtmlLabelIndex values(84644,'������������') 
GO
INSERT INTO HtmlLabelInfo VALUES(84644,'������������',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84644,'Contain process data',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84644,'�������̔���',9) 
GO