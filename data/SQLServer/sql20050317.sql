INSERT INTO HtmlLabelIndex values(17616,'附件上传') 
GO
INSERT INTO HtmlLabelInfo VALUES(17616,'附件上传',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17616,'accessory upload',8) 
GO

/*修改workflow_base表结构，记录附件上传目录id*/
ALTER TABLE workflow_base
ADD docCategory text NULL 
GO

/*修改workflow_base表结构，记录附件上传目录名称*/
ALTER TABLE workflow_base
ADD docPath varchar(100) NULL
GO

/*查询工作流是否具有"附件上传"字段*/
CREATE PROCEDURE workflow_field6_SByWfid 
(@workflowid 	int, @flag integer output, @msg varchar(80) output) AS 
select c.fieldname
from workflow_base a, workflow_formfield b, workflow_formdict c
where a.formid=b.formid and a.isbill=0
and b.fieldid=c.id and c.fieldhtmltype=6
and a.id=@workflowid
GO

