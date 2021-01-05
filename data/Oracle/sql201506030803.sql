create view tempdatainputindexview 
as
select * from (SELECT b.billid,
       '1' AS isbill,
       b.id as fieldid,
       to_char(b.viewtype),
       CASE
         WHEN viewtype = 0 THEN    '0'
         WHEN viewtype = 1 AND nvl((SELECT max(d.orderid) as orid
                                     FROM Workflow_billdetailtable d
                                    WHERE b.detailtable = d.tablename),
                                   '0') = '0' THEN     '1'
         ELSE
          to_char(nvl((SELECT max(d.orderid) as orid
                        FROM Workflow_billdetailtable d
                       WHERE b.detailtable = d.tablename),         '0'))
       END AS detailindex
  FROM workflow_billfield b
UNION
SELECT formid as billid,
       '0' AS isbill,
       fieldid,
       to_char(nvl(isdetail, 0)) AS viewtype,
       CASE
         WHEN isdetail = 1 THEN
          to_char((groupId + 1))
         ELSE   '0'
       END AS detailindex
  from workflow_formfield)
/
 UPDATE  Workflow_DataInput_entry
SET     detailindex = ( SELECT  a.detailindex
                        FROM    tempdatainputindexview a ,
                                workflow_base b
                        WHERE   b.id = Workflow_DataInput_entry.workflowid
                                AND b.formid = a.billid
                                AND substr(Workflow_DataInput_entry.TriggerFieldName,6,LENGTH(Workflow_DataInput_entry.TriggerFieldName))=a.fieldid
                                AND b.isbill=a.isbill
                      )
/    
UPDATE Workflow_DataInput_field 
SET pagefieldindex=(
SELECT  a.detailindex
                        FROM    tempdatainputindexview a ,
                                workflow_base b,
                                Workflow_DataInput_entry c,
                                Workflow_DataInput_main d
                        WHERE   b.id = c.workflowid
                                AND d.id = Workflow_DataInput_field.DataInputID
                                and d.entryID = c.id
                                AND b.formid = a.billid
                                AND substr(Workflow_DataInput_field.pagefieldname,6,LENGTH(Workflow_DataInput_field.pagefieldname))=a.fieldid
                                AND b.isbill=a.isbill
)
/
drop view tempdatainputindexview
/