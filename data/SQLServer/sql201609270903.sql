CREATE TABLE workflow_nodelinkOTField(
    id int identity (1, 1) NOT NULL ,
    overTimeId int NULL,
    toFieldId int NULL,
    toFieldName varchar(4000) NULL,
    toFieldGroupId int NULL,
    fromFieldId int NULL
)
GO