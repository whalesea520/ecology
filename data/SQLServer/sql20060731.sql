alter table workflow_report add  
formId int null,
isbill char(1) null
go

alter table workflow_report ALTER COLUMN 
reportwfid varchar(200)
go

update workflow_report set formId=(select formid from workflow_base where id=reportwfid),
isbill=(select isbill from workflow_base where id=reportwfid)

go

INSERT INTO HtmlLabelIndex values(19514,'相关表单或单据名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(19514,'相关表单或单据名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19514,'The Relative Name of Form or Bill',8) 
GO

INSERT INTO HtmlLabelIndex values(19532,'表单') 
GO
INSERT INTO HtmlLabelInfo VALUES(19532,'表单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19532,'Form',8) 
GO

INSERT INTO HtmlLabelIndex values(19533,'表单或单据') 
GO
INSERT INTO HtmlLabelInfo VALUES(19533,'表单或单据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19533,'Form or Bill',8) 
GO

INSERT INTO HtmlLabelIndex values(17736,'排序类型') 
GO
INSERT INTO HtmlLabelInfo VALUES(17736,'排序类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17736,'type of compositor',8) 
GO
