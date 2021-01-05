INSERT INTO HtmlLabelIndex values(18880,'签字意见字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(18880,'签字意见字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18880,'Opinion Field',8) 
GO

INSERT INTO HtmlLabelIndex values(18882,'标签(英文)') 
GO
INSERT INTO HtmlLabelInfo VALUES(18882,'标签(英文)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18882,'Label_EN',8) 
GO
INSERT INTO HtmlLabelIndex values(18881,'标签(中文)') 
GO
INSERT INTO HtmlLabelInfo VALUES(18881,'标签(中文)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18881,'Label_CN',8) 
GO

INSERT INTO HtmlLabelIndex values(18887,'节点表单字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(18887,'节点表单字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18887,'node form field',8) 
GO

INSERT INTO HtmlLabelIndex values(18888,'节点签字意见字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(18888,'节点签字意见字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18888,'Node Opinion Field',8) 
GO


INSERT INTO HtmlLabelIndex values(18895,'签字意见字段名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(18895,'签字意见字段名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18895,'Opinion Field Name',8) 
GO

INSERT INTO HtmlLabelIndex values(18896,'是否可使用') 
GO
INSERT INTO HtmlLabelInfo VALUES(18896,'是否可使用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18896,'isUse',8) 
GO

INSERT INTO HtmlLabelIndex values(18897,'是否赋予查看权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(18897,'是否赋予查看权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18897,'isView',8) 
GO

INSERT INTO HtmlLabelIndex values(18898,'是否赋予编辑权限') 
GO
INSERT INTO HtmlLabelInfo VALUES(18898,'是否赋予编辑权限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18898,'isEdit',8) 
GO

insert into SequenceIndex (indexdesc,currentid) values ('wfopinionfieldid',0)
GO

CREATE TABLE WFOpinionField
(
	id int not null,
	workflowid int not null,
	label_cn varchar(40) null,
	label_en varchar(40) null,
	type_cn int null,
	orderid int null
)
GO

CREATE TABLE WFOpinionNodeField
(
	workflowid int not null,
	nodeid int null,
	isUse int null,
	isMust int null,
	isView int null,
	isEdit int null,
	fieldid int null
)
GO