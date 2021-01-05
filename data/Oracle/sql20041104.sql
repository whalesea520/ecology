

/* 下面是对应的 oracle 语句 , 请务必在sql 脚本中删除*/

CREATE TABLE workflow_formprop (
	formid integer NOT NULL ,
	objid integer NULL ,
	objtype integer NULL ,
	fieldid integer NULL ,
	isdetail integer NULL ,
	ptx integer NULL ,
	pty integer NULL ,
	width integer NULL ,
	height integer NULL ,
	defvalue varchar2 (255)  NULL ,
	attribute1 varchar2 (255)  NULL ,
	attribute2 varchar2 (255)  NULL 
) 
/


INSERT INTO HtmlLabelIndex values(17555,'表单设计方式') 
/
INSERT INTO HtmlLabelInfo VALUES(17555,'表单设计方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17555,'Form Design Way',8) 
/
INSERT INTO HtmlLabelIndex values(17556,'文本型表单设计器') 
/
INSERT INTO HtmlLabelIndex values(17557,'图形化表单设计器') 
/
INSERT INTO HtmlLabelInfo VALUES(17556,'文本型表单设计器',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17556,'Text Way',8) 
/
INSERT INTO HtmlLabelInfo VALUES(17557,'图形化表单设计器',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17557,'Draw Way',8) 
/
INSERT INTO HtmlLabelIndex values(17558,'表单设计器使用提醒') 
/
INSERT INTO HtmlLabelInfo VALUES(17558,'注意：使用图形化表单设计器进行表单设计后，将不能再使用文本型表单设计器对表单进行编辑！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17558,'Notice: You can''t use Text Way to design after Draw Way!',8) 
/
