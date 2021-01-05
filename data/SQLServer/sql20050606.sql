ALTER TABLE Workflow_ReportDspField ADD dbordertype char(1)
GO
ALTER TABLE Workflow_ReportDspField ADD compositororder int
GO

ALTER PROCEDURE Workflow_ReportDspField_Insert (@reportid_1    [int], @fieldid_2   [int], @dsporder_3  [int], @isstat_4    [char](1), @dborder_5     char(1) , @dbordertype_6     char(1), @compositororder  [int], @flag   [int]   output, @msg    [varchar](80)   output)
AS
   INSERT INTO [Workflow_ReportDspField] ( [reportid], [fieldid], [dsporder], [isstat], [dborder],[dbordertype],[compositororder])
   VALUES ( @reportid_1, @fieldid_2, @dsporder_3, @isstat_4, @dborder_5, @dbordertype_6,@compositororder)
   
GO