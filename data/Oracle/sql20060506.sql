INSERT INTO HtmlLabelIndex values(18880,'签字意见字段') 
/
INSERT INTO HtmlLabelInfo VALUES(18880,'签字意见字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18880,'Opinion Field',8) 
/

INSERT INTO HtmlLabelIndex values(18882,'标签(英文)') 
/
INSERT INTO HtmlLabelInfo VALUES(18882,'标签(英文)',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18882,'Label_EN',8) 
/
INSERT INTO HtmlLabelIndex values(18881,'标签(中文)') 
/
INSERT INTO HtmlLabelInfo VALUES(18881,'标签(中文)',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18881,'Label_CN',8) 
/

INSERT INTO HtmlLabelIndex values(18887,'节点表单字段') 
/
INSERT INTO HtmlLabelInfo VALUES(18887,'节点表单字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18887,'node form field',8) 
/

INSERT INTO HtmlLabelIndex values(18888,'节点签字意见字段') 
/
INSERT INTO HtmlLabelInfo VALUES(18888,'节点签字意见字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18888,'Node Opinion Field',8) 
/


INSERT INTO HtmlLabelIndex values(18895,'签字意见字段名称') 
/
INSERT INTO HtmlLabelInfo VALUES(18895,'签字意见字段名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18895,'Opinion Field Name',8) 
/

INSERT INTO HtmlLabelIndex values(18896,'是否可使用') 
/
INSERT INTO HtmlLabelInfo VALUES(18896,'是否可使用',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18896,'isUse',8) 
/

INSERT INTO HtmlLabelIndex values(18897,'是否赋予查看权限') 
/
INSERT INTO HtmlLabelInfo VALUES(18897,'是否赋予查看权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18897,'isView',8) 
/

INSERT INTO HtmlLabelIndex values(18898,'是否赋予编辑权限') 
/
INSERT INTO HtmlLabelInfo VALUES(18898,'是否赋予编辑权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18898,'isEdit',8) 
/

insert into SequenceIndex (indexdesc,currentid) values ('wfopinionfieldid',0)
/

CREATE TABLE WFOpinionField
(
	id integer not null,
	workflowid integer not null,
	label_cn varchar2(40) null,
	label_en varchar2(40) null,
	type_cn integer null,
	orderid integer null
)
/

CREATE TABLE WFOpinionNodeField
(
	workflowid integer not null,
	nodeid integer null,
	isUse integer null,
	isMust integer null,
	isView integer null,
	isEdit integer null,
	fieldid integer null
)
/