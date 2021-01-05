alter table modedatainputfield add pagefieldindex integer
GO
alter table modedatainputentry add detailindex varchar(10)
GO
CREATE VIEW tempmodedatainputindexview AS
SELECT b.billid,b.id as fieldid, b.viewtype ,
CASE 
WHEN viewtype=0 THEN '0'
WHEN viewtype=1 AND ISNULL((SELECT TOP 1 d.orderid FROM Workflow_billdetailtable d WHERE b.detailtable=d.tablename),0)=0 THEN 1
ELSE ISNULL((SELECT TOP 1 d.orderid FROM Workflow_billdetailtable d WHERE b.detailtable=d.tablename),0)
END
AS detailindex
FROM workflow_billfield b 
GO

UPDATE  modedatainputentry SET detailindex = ( SELECT  a.detailindex FROM    tempmodedatainputindexview a , modeinfo b   WHERE   b.id = modedatainputentry.modeid  AND b.formid = a.billid  AND SUBSTRING(modedatainputentry.TriggerFieldName,6,LEN(modedatainputentry.TriggerFieldName))=a.fieldid)
GO
UPDATE modedatainputfield SET pagefieldindex=( SELECT  a.detailindex FROM    tempmodedatainputindexview a ,  modeinfo b, modedatainputentry c, modedatainputmain d  WHERE   b.id = c.modeid  AND d.id = modedatainputfield.DataInputID  and d.entryID = c.id AND b.formid = a.billid AND SUBSTRING(modeDataInputfield.pagefieldname,6,LEN(modeDataInputfield.pagefieldname))=a.fieldid)
GO
drop view tempmodedatainputindexview
GO