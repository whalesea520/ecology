alter table Workflow_ReportDspField add fieldidbak int;
GO

 Create PROCEDURE Workflow_RepDspFld_Insert_New 
 (@reportid_1    [int], 
 @dsporder_3  [varchar](20), 
 @isstat_4    [char](1), 
 @dborder_5     char(1) , 
 @dbordertype_6     char(1), 
 @compositororder_7  [int], 
 @fieldidbak_8 [int],
 @flag   [int]   output, 
 @msg    [varchar](80)   output)
  AS INSERT INTO [Workflow_ReportDspField] ( [reportid], [dsporder], [isstat], [dborder],[dbordertype],[compositororder],[fieldidbak]) 
  VALUES ( @reportid_1, @dsporder_3, @isstat_4, @dborder_5, @dbordertype_6,@compositororder_7, @fieldidbak_8)
GO