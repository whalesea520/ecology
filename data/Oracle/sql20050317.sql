INSERT INTO HtmlLabelIndex values(17616,'附件上传') 
/
INSERT INTO HtmlLabelInfo VALUES(17616,'附件上传',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17616,'accessory upload',8) 
/

/*修改workflow_base表结构，记录附件上传目录id*/
ALTER TABLE workflow_base
ADD docCategory Varchar2(4000) NULL 
/

/*修改workflow_base表结构，记录附件上传目录名称*/
ALTER TABLE workflow_base
ADD docPath varchar2(100) NULL
/

/*查询工作流是否具有"附件上传"字段*/
CREATE OR REPLACE PROCEDURE workflow_field6_SByWfid 
(workflowid_1 	integer,
flag OUT INTEGER, msg OUT VARCHAR2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
OPEN thecursor FOR select c.fieldname
from workflow_base a, workflow_formfield b, workflow_formdict c
where a.formid=b.formid and a.isbill=0
and b.fieldid=c.id and c.fieldhtmltype=6
and a.id=workflowid_1;
end;
/


