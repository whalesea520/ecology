ALTER TABLE Workflow_ReportDspField ADD dbordertype char(1)
/

ALTER TABLE Workflow_ReportDspField ADD compositororder integer
/

 CREATE OR REPLACE PROCEDURE Workflow_ReportDspField_Insert (reportid_1 	integer, fieldid_2 	integer, dsporder_3 	integer, isstat_4 	char, dborder_5     char , dbordertype_6  char, compositororder  integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  
 AS begin INSERT INTO Workflow_ReportDspField ( reportid, fieldid, dsporder, isstat, dborder,dbordertype,compositororder)  VALUES ( reportid_1, fieldid_2, dsporder_3, isstat_4, dborder_5,dbordertype_6, compositororder); end;
/
