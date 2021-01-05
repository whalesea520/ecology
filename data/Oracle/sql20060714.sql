INSERT INTO HtmlLabelIndex values(19394,'允许新增明细') 
/
INSERT INTO HtmlLabelIndex values(19395,'允许修改已有明细') 
/
INSERT INTO HtmlLabelIndex values(19396,'允许删除已有明细') 
/
INSERT INTO HtmlLabelInfo VALUES(19394,'允许新增明细',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19394,'can add new row',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19395,'允许修改已有明细',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19395,'can edit old row',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19396,'允许删除已有明细',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19396,'can delete old row',8) 
/


CREATE TABLE workflow_NodeFormGroup (
	nodeid integer NULL ,
	groupid integer NULL ,
	isadd char (1)  NULL ,
	isedit char (1)  NULL ,
	isdelete char (1)  NULL 
) 
/

insert into workflow_NodeFormGroup 
select distinct b.nodeid,c.groupid,1,1,1
from workflow_base a,workflow_flownode b,workflow_formfield c 
where a.id=b.workflowid and a.formid= c.formid and a.isbill=0 and c.groupid is not null
/


