CREATE TABLE FnaBorrowInfo(
	id integer NOT NULL PRIMARY KEY,
	requestid integer NULL,
	dtlNumber integer NULL,
	dtlId integer NULL,

	borrowDirection integer NULL,
	borrowType integer NULL,

	borrowRequestId integer NULL,
	borrowRequestIdDtlId integer NULL,

	amountBorrow decimal(18, 2),

	createDate char(10),
	createTime char(8), 

	recordType char(50), 

	applicantid integer,
	departmentid integer,
	subcompanyid1 integer
)
/

create sequence seq_FnaBorrowInfo_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

CREATE TABLE FnaBorrowInfoAmountLog(
	id integer NOT NULL PRIMARY KEY,
	requestid integer NULL,
	dtlNumber integer NULL,
	dtlId integer NULL,
	guid1 varchar2(50),

	nodeid integer,
	src varchar2(25),

	borrowDirection integer NULL,
	borrowType integer NULL,

	amountBorrowBefore decimal(18, 2),
	amountBorrowAfter decimal(18, 2),

	createUid integer,
	createDate char(10),
	createTime char(8),
	
	memo1 varchar2(4000), 

	fnaWfType char(50)
)
/

create sequence seq_FnaBorrowInfoAmountLog_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

alter table fnaFeeWfInfoLogic drop COLUMN workflowid
/


alter table fnaFeeWfInfo add fnaWfType char(50)
/

update fnaFeeWfInfo set fnaWfType = 'fnaFeeWf'
/


alter table fnaFeeWfInfoField add dtlNumber integer
/

update fnaFeeWfInfoField set dtlNumber = 1
/


alter table fnaFeeWfInfoLogic add totalAmtVerification integer
/

update fnaFeeWfInfoLogic set totalAmtVerification = 0
/

alter table fnaFeeWfInfo add fnaWfTypeBorrow integer
/
alter table fnaFeeWfInfo add fnaWfTypeColl integer
/
alter table fnaFeeWfInfo add fnaWfTypeReverse integer
/
alter table fnaFeeWfInfo add fnaWfTypeReim integer
/

update fnaFeeWfInfo set fnaWfTypeBorrow = 1, fnaWfTypeColl = 2, fnaWfTypeReverse = 0, fnaWfTypeReim = 0 where fnaWfType = 'borrow'
/

update fnaFeeWfInfo set fnaWfTypeBorrow = 1, fnaWfTypeColl = 0, fnaWfTypeReverse = 2, fnaWfTypeReim = 0 where fnaWfType = 'repayment'
/

update fnaFeeWfInfo set fnaWfTypeBorrow = 0, fnaWfTypeColl = 0, fnaWfTypeReverse = 0, fnaWfTypeReim = 1 where fnaWfType = 'fnaFeeWf'
/
create or replace trigger FnaBorrowInfoAmountLog_trigger 
before insert 
on FnaBorrowInfoAmountLog 
for each row 
begin 
	select seq_FnaBorrowInfoAmountLog_id.nextval into :new.id from dual; 
end;
/

create or replace trigger FnaBorrowInfo_trigger 
before insert 
on FnaBorrowInfo 
for each row 
begin 
	select seq_FnaBorrowInfo_id.nextval into :new.id from dual; 
end;
/

