alter table workflow_SubwfSet add triggerType char(1) null
GO
update workflow_SubwfSet set triggerType='1'
GO
alter table workflow_SubwfSet add TriggerOperation char(1) null
GO
update workflow_SubwfSet set TriggerOperation=''
GO

alter table Workflow_TriDiffWfDiffField add triggerType char(1) null
GO
update Workflow_TriDiffWfDiffField set triggerType='1'
GO
alter table Workflow_TriDiffWfDiffField add TriggerOperation char(1) null
GO
update Workflow_TriDiffWfDiffField set TriggerOperation=''
GO

CREATE TABLE Workflow_TriSubwfButtonName ( 
    id int identity (1, 1) NOT NULL ,
    workflowId int NULL,
    nodeId int NULL,
    subwfSetTableName varchar(30) NULL,
    subwfSetId int NULL,
    triSubwfName7 varchar(50) NULL,
    triSubwfName8 varchar(50) NULL
)  
GO
