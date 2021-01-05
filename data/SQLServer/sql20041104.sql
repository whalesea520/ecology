
CREATE TABLE workflow_formprop (
	formid int NOT NULL ,
	objid int NULL ,
	objtype int NULL ,
	fieldid int NULL ,
	isdetail int NULL ,
	ptx int NULL ,
	pty int NULL ,
	width int NULL ,
	height int NULL ,
	defvalue varchar (255)  NULL ,
	attribute1 varchar (255)  NULL ,
	attribute2 varchar (255)  NULL ,
) 
GO


INSERT INTO HtmlLabelIndex values(17555,'表单设计方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(17555,'表单设计方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17555,'Form Design Way',8) 
GO
INSERT INTO HtmlLabelIndex values(17556,'文本型表单设计器') 
GO
INSERT INTO HtmlLabelIndex values(17557,'图形化表单设计器') 
GO
INSERT INTO HtmlLabelInfo VALUES(17556,'文本型表单设计器',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17556,'Text Way',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17557,'图形化表单设计器',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17557,'Draw Way',8) 
GO
INSERT INTO HtmlLabelIndex values(17558,'表单设计器使用提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17558,'注意：使用图形化表单设计器进行表单设计后，将不能再使用文本型表单设计器对表单进行编辑！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17558,'Notice: You can''t use Text Way to design after Draw Way!',8) 
GO

