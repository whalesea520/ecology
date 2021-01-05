CREATE VIEW t1 AS
SELECT b.billid,'1' AS isbill,b.id as fieldid, b.viewtype ,
CASE 
WHEN viewtype=0 THEN '0'
WHEN viewtype=1 AND ISNULL((SELECT TOP 1 d.orderid FROM dbo.Workflow_billdetailtable d WHERE b.detailtable=d.tablename),0)=0 THEN 1
ELSE ISNULL((SELECT TOP 1 d.orderid FROM dbo.Workflow_billdetailtable d WHERE b.detailtable=d.tablename),0)
END
AS detailindex
FROM workflow_billfield b 
UNION
SELECT formid,'0' AS isbill ,fieldid,ISNULL(isdetail,1) AS viewtype,
CASE WHEN isdetail=1 THEN groupId+1
ELSE 0
END 
AS detailindex
from dbo.workflow_formfield 
GO

UPDATE  Workflow_DataInput_entry SET detailindex = ( SELECT  a.detailindex      FROM    t1 a , workflow_base b   WHERE   b.id = Workflow_DataInput_entry.workflowid  AND b.formid = a.billid  AND SUBSTRING(Workflow_DataInput_entry.TriggerFieldName,6,LEN(Workflow_DataInput_entry.TriggerFieldName))=a.fieldid  AND b.isbill=a.isbill)
GO
UPDATE Workflow_DataInput_field SET pagefieldindex=( SELECT  a.detailindex FROM    t1 a ,  workflow_base b, Workflow_DataInput_entry c, Workflow_DataInput_main d  WHERE   b.id = c.workflowid  AND d.id = Workflow_DataInput_field.DataInputID  and d.entryID = c.id AND b.formid = a.billid AND SUBSTRING(Workflow_DataInput_field.pagefieldname,6,LEN(Workflow_DataInput_field.pagefieldname))=a.fieldid AND b.isbill=a.isbill)
GO
drop view t1
GO