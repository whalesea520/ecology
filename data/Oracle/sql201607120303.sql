CREATE OR REPLACE PROCEDURE Workflow_ReportDspField_INSERT (reportid_1 INTEGER, fieldid_2 INTEGER, dsporder_3 VARCHAR2, isstat_4 CHAR, dborder_5 CHAR, dbordertype_6 CHAR, compositororder INTEGER, flag OUT INTEGER, msg OUT VARCHAR2, thecursor IN OUT cursor_define.weavercursor) AS BEGIN
INSERT INTO Workflow_ReportDspField (reportid, fieldid, dsporder, isstat, dborder, dbordertype, compositororder)
VALUES (reportid_1,
        fieldid_2,
        dsporder_3,
        isstat_4,
        dborder_5,
        dbordertype_6,
        compositororder); END;
/