alter table Workflow_ReportDspField add fieldidbak int
/

 Create OR REPLACE PROCEDURE Workflow_RepDspFld_Insert_New 
 (reportid_1    int, 
 dsporder_3  varchar2, 
 isstat_4    char, 
 dborder_5     char, 
 dbordertype_6     char, 
 compositororder_7  int, 
 fieldidbak_8 int,
 flag  out int , 
 msg   out varchar2   ,
 thecursor IN OUT cursor_define.weavercursor )  AS
BEGIN
 INSERT INTO Workflow_ReportDspField ( reportid, dsporder, isstat, dborder,dbordertype,compositororder,fieldidbak) 
  VALUES ( reportid_1, dsporder_3, isstat_4, dborder_5, dbordertype_6,compositororder_7, fieldidbak_8); 
end;
/