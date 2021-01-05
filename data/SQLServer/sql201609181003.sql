Delete from MainMenuInfo where id=10337
GO
EXECUTE MMConfig_U_ByInfoInsert 10193,7
GO
EXECUTE MMInfo_Insert 10337,128576,'Ô¤¸¶¿îÁ÷³Ì','/fna/budget/wfset/budgetAdvance/FnaAdvanceWfSetEdit.jsp','mainFrame', 10193,3,7,0,'',0,'',0,'','',0,'','',6
GO



CREATE TABLE FnaAdvanceInfo(
	id int IDENTITY(1,1) PRIMARY key,
	requestid int NULL,
	dtlNumber int NULL,
	dtlId int NULL,
	AdvanceDirection int NULL,
	AdvanceType int NULL,
	AdvanceRequestId int NULL,
	AdvanceRequestIdDtlId int NULL,
	amountAdvance decimal(18, 2) NULL,
	createDate char(10) NULL,
	createTime char(8) NULL,
	recordType char(50) NULL 
)
GO

create index idx_FnaAdvanceInfo_0 on FnaAdvanceInfo (requestid)
GO
create index idx_FnaAdvanceInfo_1 on FnaAdvanceInfo (dtlId)
GO
create index idx_FnaAdvanceInfo_2 on FnaAdvanceInfo (AdvanceDirection)
GO



CREATE TABLE FnaAdvanceInfoAmountLog(
	id int IDENTITY(1,1) PRIMARY key,
	requestid int NULL,
	dtlNumber int NULL,
	dtlId int NULL,
	guid1 varchar(50) NULL,
	nodeid int NULL,
	src varchar(25) NULL,
	AdvanceDirection int NULL,
	AdvanceType int NULL,
	amountAdvanceBefore decimal(18, 2) NULL,
	amountAdvanceAfter decimal(18, 2) NULL,
	createUid int NULL,
	createDate char(10) NULL,
	createTime char(8) NULL,
	memo1 varchar(4000) NULL,
	fnaWfType char(50) NULL 
)
GO

create index idx_FnaAInfoLog_0 on FnaAdvanceInfoAmountLog (requestid)
GO
create index idx_FnaAInfoLog_1 on FnaAdvanceInfoAmountLog (dtlId)
GO
create index idx_FnaAInfoLog_2 on FnaAdvanceInfoAmountLog (AdvanceDirection)
GO

ALTER TABLE fnaFeeWfInfo add fnaWfTypeReverseAdvance INT
GO

update fnaFeeWfInfo set fnaWfTypeReverseAdvance = 0 
GO


CREATE TABLE fnaFeeWfInfoLogicAdvanceR(
	id int IDENTITY(1,1) primary key,
	MAINID int NULL,
	rule1 int NULL,
	rule1INTENSITY int NULL,
	rule2 int NULL,
	rule2INTENSITY int NULL,
	rule3 int NULL,
	rule3INTENSITY int NULL,
	rule4 int NULL,
	rule4INTENSITY int NULL,
	rule5 int NULL,
	rule5INTENSITY int NULL,
	PROMPTSC varchar(4000) NULL,
	PROMPTTC varchar(4000) NULL,
	PROMPTEN varchar(4000) NULL,
	PROMPTSC2 varchar(4000) NULL,
	PROMPTTC2 varchar(4000) NULL,
	PROMPTEN2 varchar(4000) NULL,
	PROMPTSC3 varchar(4000) NULL,
	PROMPTTC3 varchar(4000) NULL,
	PROMPTEN3 varchar(4000) NULL,
	PROMPTSC4 varchar(4000) NULL,
	PROMPTTC4 varchar(4000) NULL,
	PROMPTEN4 varchar(4000) NULL,
	PROMPTSC5 varchar(4000) NULL,
	PROMPTTC5 varchar(4000) NULL,
	PROMPTEN5 varchar(4000) NULL
)
GO

create index idx_fnaWfInfoLAR_0 on fnaFeeWfInfoLogicAdvanceR (MAINID)
GO