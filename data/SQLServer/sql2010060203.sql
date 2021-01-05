CREATE TABLE WorkflowToDocProp ( 
    id int identity NOT NULL ,
    workflowId int NULL,
    secCategoryId int NULL
)  
go

CREATE TABLE WorkflowToDocPropDetail ( 
    id int identity NOT NULL ,
    docPropId int NULL,
    docPropFieldId int NULL,
    workflowFieldId int NULL
)  
go

alter table workflow_base add keepsign int
go
alter table workflow_base add secCategoryId int
go
alter table docdetail add fromworkflow int
go
