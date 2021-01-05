alter table workflow_base add traceFieldId int
GO
alter table workflow_base add traceSaveSecId int
GO
alter table workflow_base add traceCategoryType char(1)
GO
alter table workflow_base add traceCategoryFieldId int
GO

alter table workflow_base add traceDocOwnerType int 
GO
alter table workflow_base add traceDocOwnerFieldId int 
GO
alter table workflow_base add traceDocOwner int 
GO

CREATE TABLE traceprop (
id int NOT NULL IDENTITY(1,1) ,
workflowid int NULL ,
seccategoryid int NULL 
)
GO
ALTER TABLE traceprop ADD PRIMARY KEY ([id])
GO

CREATE TABLE tracepropdetail (
id int NOT NULL IDENTITY(1,1) ,
docpropid int NULL ,
docpropfieldid int NULL ,
workflowfieldid int NULL 
)
GO
ALTER TABLE tracepropdetail ADD PRIMARY KEY ([id])
GO