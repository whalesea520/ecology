CREATE TABLE Workflow_DocProp ( 
    id int identity (1, 1) NOT NULL ,
    workflowId int NULL,
    selectItemId int NULL,
    secCategoryId int NULL
)  
GO



CREATE TABLE Workflow_DocPropDetail ( 
    id int identity (1, 1) NOT NULL ,
    docPropId int NULL,
    docPropFieldId int NULL,
    workflowFieldId int NULL
)  
GO
