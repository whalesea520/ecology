delete from HtmlLabelIndex where id=128309 
GO
delete from HtmlLabelInfo where indexid=128309 
GO
INSERT INTO HtmlLabelIndex values(128309,'操作者重复审批跳过') 
GO
INSERT INTO HtmlLabelInfo VALUES(128309,'操作者重复审批跳过',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128309,'Skip for examination and approval of the operator to repeat',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128309,'操作者重复审批跳过',9) 
GO