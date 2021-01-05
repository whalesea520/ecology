alter table Workflow_ReportDspField add tmpcolumn int 
/ 
update Workflow_ReportDspField set tmpcolumn=dsporder 
/ 
alter table Workflow_ReportDspField drop column dsporder 
/ 
alter table Workflow_ReportDspField add dsporder number(10,2) 
/ 
update Workflow_ReportDspField set dsporder=tmpcolumn 
/ 
alter table Workflow_ReportDspField drop column tmpcolumn
/
CREATE OR REPLACE PROCEDURE Workflow_ReportDspField_Insert (reportid_1 	integer, fieldid_2 	integer, dsporder_3 	varchar2, isstat_4 	char, dborder_5     char , dbordertype_6  char, compositororder  integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  
 AS begin INSERT INTO Workflow_ReportDspField ( reportid, fieldid, dsporder, isstat, dborder,dbordertype,compositororder)  VALUES ( reportid_1, fieldid_2, dsporder_3, isstat_4, dborder_5,dbordertype_6, compositororder); end;
/
