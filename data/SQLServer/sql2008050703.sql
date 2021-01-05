CREATE TABLE Workflow_BarCodeSet(
	id int identity (1, 1) NOT NULL ,
	workflowId int NULL ,
	isUse char(1) NULL ,
	measureUnit char(1) NULL ,
	printRatio int NULL ,
	minWidth int NULL ,
	maxWidth int NULL ,
	minHeight int NULL ,
	maxHeight int NULL ,
	bestWidth int NULL ,
	bestHeight int NULL 
)
GO

CREATE TABLE Workflow_BarCodeSetDetail(
	id int identity (1, 1) NOT NULL ,
	barCodeSetId int NULL ,
	dataElementId int NULL ,
	fieldId int NULL 
)
GO