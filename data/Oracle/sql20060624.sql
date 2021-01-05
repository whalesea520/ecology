INSERT INTO HtmlLabelIndex values(19334,'公文表单') 
/
INSERT INTO HtmlLabelIndex values(19335,'维护正文') 
/
INSERT INTO HtmlLabelInfo VALUES(19334,'公文表单',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19334,'Document Form',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19335,'维护正文',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19335,'Edit Document',8) 
/

CREATE TABLE workflow_docshow (
	flowId integer NULL ,
	selectItemId integer NULL ,
	secCategoryID  varchar2(500) NULL,
	modulId integer NULL ,
    fieldId integer NULL
)
/

CREATE TABLE workflow_createdoc (
	id integer  NOT NULL ,
	workflowId integer NULL ,
	status char(1) NULL ,
	flowCodeField integer NULL ,
	flowDocField integer NULL ,
	flowDocCatField integer NULL ,
    defaultView  varchar2(500) NULL
)
/
create sequence workflow_createdoc_Id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_createdoc_Trigger
before insert on workflow_createdoc
for each row
begin
select workflow_createdoc_Id.nextval into :new.id from dual;
end;
/




INSERT INTO HtmlLabelIndex values(19331,'流程创建文档') 
/
INSERT INTO HtmlLabelInfo VALUES(19331,'流程创建文档',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19331,'Create Document through WorkFlow',8) 
/

INSERT INTO HtmlLabelIndex values(19332,'高级设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19332,'高级设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19332,'Advanced Config',8) 
/

INSERT INTO HtmlLabelIndex values(19337,'文档基本属性') 
/
INSERT INTO HtmlLabelInfo VALUES(19337,'文档基本属性',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19337,'Document Basic Attribute',8) 
/

INSERT INTO HtmlLabelIndex values(19338,'流程编码字段') 
/
INSERT INTO HtmlLabelInfo VALUES(19338,'流程编码字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19338,'Work Flow Coding Field',8) 
/

INSERT INTO HtmlLabelIndex values(19339,'创建文档字段') 
/
INSERT INTO HtmlLabelInfo VALUES(19339,'创建文档字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19339,'Create Document Field',8) 
/

INSERT INTO HtmlLabelIndex values(19340,'默认显示属性') 
/
INSERT INTO HtmlLabelInfo VALUES(19340,'默认显示属性',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19340,'Default Display Attribute',8) 
/

INSERT INTO HtmlLabelIndex values(19341,'选择显示属性') 
/
INSERT INTO HtmlLabelInfo VALUES(19341,'选择显示属性',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19341,'Choose Display Attribute',8) 
/

INSERT INTO HtmlLabelIndex values(19342,'详细设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19342,'详细设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19342,'Particular Config',8) 
/

INSERT INTO HtmlLabelIndex values(19360,'关联目录') 
/
INSERT INTO HtmlLabelInfo VALUES(19360,'关联目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19360,'Associate Calatog',8) 
/

INSERT INTO HtmlLabelIndex values(19367,'创建文档属性') 
/
INSERT INTO HtmlLabelInfo VALUES(19367,'创建文档属性',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19367,'Create Document Attribute',8) 
/

INSERT INTO HtmlLabelIndex values(19368,'文档存在目录') 
/
INSERT INTO HtmlLabelInfo VALUES(19368,'文档存在目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19368,'Document Catalog',8) 
/

INSERT INTO HtmlLabelIndex values(19369,'文档显示模版') 
/
INSERT INTO HtmlLabelInfo VALUES(19369,'文档显示模版',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19369,'Document Display Template',8) 
/

INSERT INTO HtmlLabelIndex values(19370,'文档数据设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19370,'文档数据设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19370,'Document Parameter Config',8) 
/

INSERT INTO HtmlLabelIndex values(19371,'显示模版标签') 
/
INSERT INTO HtmlLabelInfo VALUES(19371,'显示模版标签',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19371,'Display Template Label',8) 
/

INSERT INTO HtmlLabelIndex values(19372,'流程字段') 
/
INSERT INTO HtmlLabelInfo VALUES(19372,'流程字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19372,'Work Flow Field',8) 
/

INSERT INTO HtmlLabelIndex values(19373,'目录未选定') 
/
INSERT INTO HtmlLabelInfo VALUES(19373,'目录未选定',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19373,'No Choosing Folder',8) 
/
