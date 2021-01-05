CREATE OR REPLACE PROCEDURE Prj_WorkType_Update(id_1           integer,
                                                fullname_2     Varchar2,
                                                description_3  Varchar2,
                                                worktypecode_4 Varchar2,
                                                dsporder_1     number,
                                                flag           out integer,
                                                msg            out varchar2,
                                                thecursor      IN OUT cursor_define.weavercursor) AS
BEGIN
  UPDATE Prj_WorkType
     SET fullname     = fullname_2,
         description  = description_3,
         worktypecode = worktypecode_4,
         dsporder     = dsporder_1
   WHERE (id = id_1);
END;
/