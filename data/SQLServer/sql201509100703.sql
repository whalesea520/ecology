CREATE TABLE Workflow_DistributionSummary
(
	id              INT IDENTITY NOT NULL,
	mainwfid        INT,
	mainformid		INT,
	mainfieldid		INT,
	mainfieldname		varchar(1000),
	maindetailnum		INT,
	nodeid			INT,
	subwfid			INT,
	subformid		INT,
	subfieldid		INT,
	subfieldname		varchar(1000),
	fieldhtmltype		char(1),
	type			INT,
	subtype			INT,
	iscreatedoc		char(1)
)
go