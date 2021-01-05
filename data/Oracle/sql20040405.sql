CREATE OR REPLACE PROCEDURE workflow_reportdspfield_byrp (id_1     INTEGER, language_2     INTEGER,
flag OUT INTEGER, msg OUT VARCHAR2, thecursor IN OUT cursor_define.weavercursor)

AS
   isbill_c char(1);
   Type isbillRecType IS Record  (isbill char(1));
   isbillRec isbillRecType;
BEGIN


   Select isbill INTO isbill_c FROM workflow_base a, workflow_report b
      WHERE b.id = id_1
      AND a.id = b.reportwfid ;

   isbillRec.isbill:= isbill_c;
   IF isbillRec.isbill='0'
   THEN
      OPEN thecursor FOR SELECT a.id, b.fieldlable, a.dsporder, a.isstat, a.dborder
      FROM workflow_reportdspfield a, workflow_fieldlable b, workflow_report c,
      workflow_base d
      WHERE a.reportid = c.id
      AND a.fieldid = b.fieldid
      AND c.reportwfid = d.id
      AND d.formid = b.formid
      AND c.id = id_1
      AND b.langurageid = language_2
      ORDER BY a.dsporder;
   ELSIF isbillRec.isbill='1' THEN
      OPEN thecursor FOR SELECT a.id, d.labelname, a.dsporder, a.isstat, a.dborder
      FROM workflow_reportdspfield a, workflow_billfield b, workflow_report c,
      htmllabelinfo d
      WHERE a.reportid = c.id
      AND a.fieldid = b.id
      AND c.id = id_1
      AND b.fieldlabel = d.indexid
      AND d.languageid = language_2
      ORDER BY a.dsporder;
   END IF;
END;
/
create or replace trigger DocMouldFile_Trigger
before insert on DocMouldFile
for each row
begin
select DocMouldFile_id.nextval INTO :new.id from dual;
end;
/
