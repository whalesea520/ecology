CREATE TABLE FnaBorrowInfo(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	requestid int NULL,
	dtlNumber int NULL,
	dtlId int NULL,

	borrowDirection int NULL,
	borrowType int NULL,

	borrowRequestId int NULL,
	borrowRequestIdDtlId int NULL,

	amountBorrow decimal(18, 2),

	createDate char(10),
	createTime char(8), 

	recordType char(50), 

	applicantid int,
	departmentid int,
	subcompanyid1 int
)
GO

CREATE TABLE FnaBorrowInfoAmountLog(
	id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
	requestid int NULL,
	dtlNumber int NULL,
	dtlId int NULL,
	guid1 varchar(50),

	nodeid int,
	src varchar(25),

	borrowDirection int NULL,
	borrowType int NULL, 

	amountBorrowBefore decimal(18, 2),
	amountBorrowAfter decimal(18, 2),

	createUid int,
	createDate char(10),
	createTime char(8),
	
	memo1 varchar(4000), 

	fnaWfType char(50)
)
GO

alter table fnaFeeWfInfoLogic drop COLUMN workflowid
GO


alter table fnaFeeWfInfo add fnaWfType char(50)
GO

update fnaFeeWfInfo set fnaWfType = 'fnaFeeWf'
GO


alter table fnaFeeWfInfoField add dtlNumber int
GO

update fnaFeeWfInfoField set dtlNumber = 1
GO


alter table fnaFeeWfInfoLogic add totalAmtVerification int
GO

update fnaFeeWfInfoLogic set totalAmtVerification = 0
GO

alter table fnaFeeWfInfo add fnaWfTypeBorrow int
GO
alter table fnaFeeWfInfo add fnaWfTypeColl int
GO
alter table fnaFeeWfInfo add fnaWfTypeReverse int
GO
alter table fnaFeeWfInfo add fnaWfTypeReim int
GO

update fnaFeeWfInfo set fnaWfTypeBorrow = 1, fnaWfTypeColl = 2, fnaWfTypeReverse = 0, fnaWfTypeReim = 0 where fnaWfType = 'borrow'
GO

update fnaFeeWfInfo set fnaWfTypeBorrow = 1, fnaWfTypeColl = 0, fnaWfTypeReverse = 2, fnaWfTypeReim = 0 where fnaWfType = 'repayment'
GO

update fnaFeeWfInfo set fnaWfTypeBorrow = 0, fnaWfTypeColl = 0, fnaWfTypeReverse = 0, fnaWfTypeReim = 1 where fnaWfType = 'fnaFeeWf'
GO