INSERT INTO HtmlLabelIndex values(19334,'公文表单') 
GO
INSERT INTO HtmlLabelIndex values(19335,'维护正文') 
GO
INSERT INTO HtmlLabelInfo VALUES(19334,'公文表单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19334,'Document Form',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19335,'维护正文',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19335,'Edit Document',8) 
GO

CREATE TABLE workflow_docshow(
	flowId int NULL,
	selectItemId int NULL,
	secCategoryID varchar(500),
	modulId int NULL,
	fieldId int NULL
) 

GO

CREATE TABLE workflow_createdoc(
	id int IDENTITY(1,1) NOT NULL,
	workflowId int NULL,
	status char(1)  NULL,
	flowCodeField int NULL,
	flowDocField int NULL,
	flowDocCatField int NULL,
	defaultView varchar(500) NULL
) 

GO

INSERT INTO HtmlLabelIndex values(19331,'流程创建文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(19331,'流程创建文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19331,'Create Document through WorkFlow',8) 
GO

INSERT INTO HtmlLabelIndex values(19332,'高级设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19332,'高级设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19332,'Advanced Config',8) 
GO

INSERT INTO HtmlLabelIndex values(19337,'文档基本属性') 
GO
INSERT INTO HtmlLabelInfo VALUES(19337,'文档基本属性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19337,'Document Basic Attribute',8) 
GO

INSERT INTO HtmlLabelIndex values(19338,'流程编码字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19338,'流程编码字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19338,'Work Flow Coding Field',8) 
GO

INSERT INTO HtmlLabelIndex values(19339,'创建文档字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19339,'创建文档字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19339,'Create Document Field',8) 
GO

INSERT INTO HtmlLabelIndex values(19340,'默认显示属性') 
GO
INSERT INTO HtmlLabelInfo VALUES(19340,'默认显示属性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19340,'Default Display Attribute',8) 
GO

INSERT INTO HtmlLabelIndex values(19341,'选择显示属性') 
GO
INSERT INTO HtmlLabelInfo VALUES(19341,'选择显示属性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19341,'Choose Display Attribute',8) 
GO

INSERT INTO HtmlLabelIndex values(19342,'详细设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19342,'详细设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19342,'Particular Config',8) 
GO

INSERT INTO HtmlLabelIndex values(19360,'关联目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19360,'关联目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19360,'Associate Calatog',8) 
GO

INSERT INTO HtmlLabelIndex values(19367,'创建文档属性') 
GO
INSERT INTO HtmlLabelInfo VALUES(19367,'创建文档属性',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19367,'Create Document Attribute',8) 
GO

INSERT INTO HtmlLabelIndex values(19368,'文档存在目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19368,'文档存在目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19368,'Document Catalog',8) 
GO

INSERT INTO HtmlLabelIndex values(19369,'文档显示模版') 
GO
INSERT INTO HtmlLabelInfo VALUES(19369,'文档显示模版',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19369,'Document Display Template',8) 
GO

INSERT INTO HtmlLabelIndex values(19370,'文档数据设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19370,'文档数据设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19370,'Document Parameter Config',8) 
GO

INSERT INTO HtmlLabelIndex values(19371,'显示模版标签') 
GO
INSERT INTO HtmlLabelInfo VALUES(19371,'显示模版标签',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19371,'Display Template Label',8) 
GO

INSERT INTO HtmlLabelIndex values(19372,'流程字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19372,'流程字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19372,'Work Flow Field',8) 
GO

INSERT INTO HtmlLabelIndex values(19373,'目录未选定') 
GO
INSERT INTO HtmlLabelInfo VALUES(19373,'目录未选定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19373,'No Choosing Folder',8) 
GO
