Delete from MainMenuInfo where id=10337
/
call MMConfig_U_ByInfoInsert (10193,7)
/
call MMInfo_Insert (10337,128576,'Ô¤¸¶¿îÁ÷³Ì','/fna/budget/wfset/budgetAdvance/FnaAdvanceWfSetEdit.jsp','mainFrame', 10193,3,7,0,'',0,'',0,'','',0,'','',6)
/



CREATE TABLE FnaAdvanceInfo(
	id integer PRIMARY key,
	requestid integer NULL,
	dtlNumber integer NULL,
	dtlId integer NULL,
	AdvanceDirection integer NULL,
	AdvanceType integer NULL,
	AdvanceRequestId integer NULL,
	AdvanceRequestIdDtlId integer NULL,
	amountAdvance decimal(18, 2) NULL,
	createDate char(10) NULL,
	createTime char(8) NULL,
	recordType char(50) NULL 
)
/

create index idx_FnaAdvanceInfo_0 on FnaAdvanceInfo (requestid)
/
create index idx_FnaAdvanceInfo_1 on FnaAdvanceInfo (dtlId)
/
create index idx_FnaAdvanceInfo_2 on FnaAdvanceInfo (AdvanceDirection)
/

create sequence seq_FnaAdvanceInfo_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/



CREATE TABLE FnaAdvanceInfoAmountLog(
	id integer PRIMARY key,
	requestid integer NULL,
	dtlNumber integer NULL,
	dtlId integer NULL,
	guid1 varchar2(50) NULL,
	nodeid integer NULL,
	src varchar2(25) NULL,
	AdvanceDirection integer NULL,
	AdvanceType integer NULL,
	amountAdvanceBefore decimal(18, 2) NULL,
	amountAdvanceAfter decimal(18, 2) NULL,
	createUid integer NULL,
	createDate char(10) NULL,
	createTime char(8) NULL,
	memo1 varchar2(4000) NULL,
	fnaWfType char(50) NULL 
)
/

create index idx_FnaAInfoLog_0 on FnaAdvanceInfoAmountLog (requestid)
/
create index idx_FnaAInfoLog_1 on FnaAdvanceInfoAmountLog (dtlId)
/
create index idx_FnaAInfoLog_2 on FnaAdvanceInfoAmountLog (AdvanceDirection)
/

create sequence seq_FnaAInfoLog_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

ALTER TABLE fnaFeeWfInfo add fnaWfTypeReverseAdvance integer
/

update fnaFeeWfInfo set fnaWfTypeReverseAdvance = 0 
/


CREATE TABLE fnaFeeWfInfoLogicAdvanceR(
	id integer primary key,
	MAINID integer NULL,
	rule1 integer NULL,
	rule1INTENSITY integer NULL,
	rule2 integer NULL,
	rule2INTENSITY integer NULL,
	rule3 integer NULL,
	rule3INTENSITY integer NULL,
	rule4 integer NULL,
	rule4INTENSITY integer NULL,
	rule5 integer NULL,
	rule5INTENSITY integer NULL,
	PROMPTSC varchar2(4000) NULL,
	PROMPTTC varchar2(4000) NULL,
	PROMPTEN varchar2(4000) NULL,
	PROMPTSC2 varchar2(4000) NULL,
	PROMPTTC2 varchar2(4000) NULL,
	PROMPTEN2 varchar2(4000) NULL,
	PROMPTSC3 varchar2(4000) NULL,
	PROMPTTC3 varchar2(4000) NULL,
	PROMPTEN3 varchar2(4000) NULL,
	PROMPTSC4 varchar2(4000) NULL,
	PROMPTTC4 varchar2(4000) NULL,
	PROMPTEN4 varchar2(4000) NULL,
	PROMPTSC5 varchar2(4000) NULL,
	PROMPTTC5 varchar2(4000) NULL,
	PROMPTEN5 varchar2(4000) NULL
)
/

create index idx_fnaWfInfoLAR_0 on fnaFeeWfInfoLogicAdvanceR (MAINID)
/

create sequence seq_fnaWfInfoLAR_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/

create or replace trigger fnaAdvanceInfo_trigger 
before insert 
on FnaAdvanceInfo 
for each row 
begin 
	select seq_FnaAdvanceInfo_id.nextval into :new.id from dual; 
end;
/

create or replace trigger FnaAInfoLog_trigger 
before insert 
on FnaAdvanceInfoAmountLog 
for each row 
begin 
	select seq_FnaAInfoLog_id.nextval into :new.id from dual; 
end;
/

create or replace trigger fnaWfInfoLAR_trigger 
before insert 
on fnaFeeWfInfoLogicAdvanceR 
for each row 
begin 
	select seq_fnaWfInfoLAR_id.nextval into :new.id from dual; 
end;
/