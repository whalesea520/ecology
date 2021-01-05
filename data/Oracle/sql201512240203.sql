alter table modedatainputfield add pagefieldindex integer
/
alter table modedatainputentry add detailindex varchar2(10)
/
create view tempmodedatainputindexview 
as
select * from (SELECT b.billid,
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
  FROM workflow_billfield b)
/
 UPDATE  modeDataInputentry
SET     detailindex = ( SELECT  a.detailindex
                        FROM    tempmodedatainputindexview a ,
                                modeinfo b
                        WHERE   b.id = modeDataInputentry.modeid
                                AND b.formid = a.billid
                                AND substr(modeDataInputentry.TriggerFieldName,6,LENGTH(modeDataInputentry.TriggerFieldName))=a.fieldid
                      )
/    
UPDATE modeDataInputfield 
SET pagefieldindex=(
SELECT  a.detailindex
                        FROM    tempmodedatainputindexview a ,
                                modeinfo b,
                                modeDataInputentry c,
                                modeDataInputmain d
                        WHERE   b.id = c.modeid
                                AND d.id = modeDataInputfield.DataInputID
                                and d.entryID = c.id
                                AND b.formid = a.billid
                                AND substr(modeDataInputfield.pagefieldname,6,LENGTH(modeDataInputfield.pagefieldname))=a.fieldid
)
/
drop view tempmodedatainputindexview
/