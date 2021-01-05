CREATE TABLE workflow_monitor_bound(
    monitorhrmid              int,
    workflowid           int,
    operatordate         char(10),
    operatortime         char(8)
)
GO

EXECUTE MMConfig_U_ByInfoInsert 4,9
GO
EXECUTE MMInfo_Insert 421,17989,'º‡øÿ…Ë÷√','/system/systemmonitor/workflow/systemMonitorStatic.jsp','mainFrame',4,1,9,0,'',0,'',0,'','',0,'','',3
GO

INSERT INTO HtmlLabelIndex values(17989,'º‡øÿ…Ë÷√') 
GO
INSERT INTO HtmlLabelInfo VALUES(17989,'º‡øÿ…Ë÷√',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17989,'monitor setting',8) 
GO