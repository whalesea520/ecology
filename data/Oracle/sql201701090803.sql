CREATE OR REPLACE PROCEDURE Prj_WorkType_Insert(fullname_1     Varchar2,
                                                description_2  Varchar2,
                                                worktypecode_3 Varchar2,
                                                dsporder_1     number,
                                                flag           out integer,
                                                msg            out varchar2,
                                                thecursor      IN OUT cursor_define.weavercursor) AS
BEGIN
  INSERT INTO Prj_WorkType
    (fullname, description, worktypecode, dsporder)
  VALUES
    (fullname_1, description_2, worktypecode_3, dsporder_1);
END;
/