CREATE TABLE Workflow_TriDiffWfDiffField ( 
    id int identity (1, 1) NOT NULL ,
    mainWorkflowId int NULL,
    triggerNodeId int NULL,
    triggerTime char(1) NULL,
    fieldId int NULL
)  
GO




CREATE TABLE Workflow_TriDiffWfSubWf ( 
    id int identity (1, 1) NOT NULL ,
    triDiffWfDiffFieldId int NULL,
    subWorkflowId int NULL,
    subwfCreatorType char(1) NULL,
    subwfCreatorFieldId int NULL,
    isRead int NULL
)  
GO



CREATE TABLE Workflow_TriDiffWfSubWfField ( 
    id int identity (1, 1) NOT NULL ,
    triDiffWfSubWfId int NULL,
    subWorkflowFieldId int NULL,
    mainWorkflowFieldId int NULL,
    isDetail int NULL
)  
GO



ALTER TABLE Workflow_base ADD  isTriDiffWorkflow char(1) null
GO

ALTER TABLE Workflow_TriDiffWfSubWf ADD  fieldValue int null
GO

ALTER TABLE Workflow_TriDiffWfSubWfField ADD  isCreateDocAgain char(1) null
GO

ALTER TABLE Workflow_TriDiffWfSubWfField ADD  ifSplitField char(1) null
GO
