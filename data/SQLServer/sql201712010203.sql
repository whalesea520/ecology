ALTER table FnaCostStandard add fielddbtype varchar(200)
GO

CREATE TABLE fnaFeeWfInfoCostStandard(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	workflowid INT,
	enable INT,
	FNAWFTYPE varchar(50),
	OVERSTANDARDTIPS varchar(4000),
	lastModifiedDate CHAR(10)
)
GO

CREATE INDEX [idx_fnaFeeWfInfoCs] ON [fnaFeeWfInfoCostStandard](
	[workflowid] ASC
)
GO

CREATE INDEX [idx_fnaFeeWfInfoCs1] ON [fnaFeeWfInfoCostStandard](
	[FNAWFTYPE] ASC
)
GO

CREATE INDEX [idx_fnaFeeWfInfoCs2] ON [fnaFeeWfInfoCostStandard](
	[ENABLE] ASC
)
GO






CREATE TABLE fnaFeeWfInfoFieldCostStandard(
	id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	mainId INT,
	
	workflowid INT,
	formid INT,
	
	fieldType INT,
	fieldId INT,
	FCSGUID1 char(32),
	TABINDEX INT,
	SHOWALLTYPE INT,
	DTLNUMBER INT,

	FIELDVALUE varchar(4000),
	FIELDVALTYPE INT,
	FIELDVALUEWFSYS INT,
	ISWFFIELDLINKAGE INT,

	isDtl INT
)
GO

CREATE INDEX [idx_fnaFeeWfInfoFieldCs] ON [fnaFeeWfInfoFieldCostStandard](
	[mainId] ASC
)
GO

CREATE INDEX [idx_fnaFeeWfInfoFieldCs2] ON [fnaFeeWfInfoFieldCostStandard](
	[workflowid] ASC
)
GO

CREATE INDEX [idx_fnaFeeWfInfoFieldCs5] ON [fnaFeeWfInfoFieldCostStandard](
	[FCSGUID1] ASC
)
GO