ALTER table  workflow_selectitem add cancel varchar2(1) default 0
/

CREATE OR REPLACE PROCEDURE workflow_selectitembyid_new (
   id_1                 VARCHAR2,
   isbill_1             VARCHAR2,
   flag        OUT      INTEGER,
   msg         OUT      VARCHAR2,
   thecursor   IN OUT   cursor_define.weavercursor
)
AS
BEGIN
   OPEN thecursor FOR
      SELECT   *
          FROM workflow_selectitem
         WHERE fieldid = id_1 AND isbill = isbill_1
         AND (cancel!='1' or cancel is null)
      ORDER BY listorder, ID;
END;
/

CREATE OR REPLACE PROCEDURE workflow_selectitem_insert_new (
   fieldid2                INTEGER,
   isbill2                 INTEGER,
   selectvalue2            INTEGER,
   selectname2             VARCHAR2,
   listorder2              NUMERIC,
   isdefault2              CHAR,
   cancel2                 VARCHAR2,
   flag           OUT      INTEGER,
   msg            OUT      VARCHAR2,
   thecursor      IN OUT   cursor_define.weavercursor
)
AS
BEGIN
   INSERT INTO workflow_selectitem
               (fieldid, isbill, selectvalue, selectname, listorder,
                isdefault,cancel
               )
        VALUES (fieldid2, isbill2, selectvalue2, selectname2, listorder2,
                isdefault2,cancel2
               );
END;
/