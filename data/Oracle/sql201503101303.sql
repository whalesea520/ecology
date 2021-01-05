CREATE TABLE TB_NULL(
  id INTeger PRIMARY KEY,
  guid1 VARCHAR2(250)
)
/


CREATE TABLE fnaTmpTbLog(
  id integer PRIMARY KEY NOT NULL,
  rptTypeName VARCHAR2(100),
  guid1 VARCHAR2(250),
	isTemp integer,
	tbName VARCHAR2(500),
	tbDbName VARCHAR2(250),
	description VARCHAR2(4000),
	createDate char(10),
	createTime char(8),
	creater integer,
	qryConds clob 
)
/


create sequence fnaTmpTbLog_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create index idx_fnaTmpTbLog_rptTypeName on fnaTmpTbLog (rptTypeName)
/

create index idx_fnaTmpTbLog_guid1 on fnaTmpTbLog (guid1)
/

create index idx_fnaTmpTbLog_creater on fnaTmpTbLog (creater)
/

create index idx_fnaTmpTbLog_isTemp on fnaTmpTbLog (isTemp)
/

create index idx_fnaTmpTbLog_createDate on fnaTmpTbLog (createDate)
/




CREATE TABLE fnaTmpTbLogShare(
	id integer PRIMARY KEY NOT NULL,
	fnaTmpTbLogId integer,
	groupGuid1 VARCHAR2(250),
	shareType integer,
	shareId integer,
	secLevel1 integer,
	secLevel2 integer,
	shareLevel integer
)
/


create sequence fnaTmpTbLogShare_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create index idx_fnaTmpTbLogShare_fkId on fnaTmpTbLogShare (fnaTmpTbLogId)
/

create index idx_fnaTmpTbLogShare_gg1 on fnaTmpTbLogShare (groupGuid1)
/

create index idx_fnaTmpTbLogShare_type on fnaTmpTbLogShare (shareType)
/

create index idx_fnaTmpTbLogShare_fkId2 on fnaTmpTbLogShare (shareId)
/

create index idx_fnaTmpTbLogShare_sec1 on fnaTmpTbLogShare (secLevel1)
/

create index idx_fnaTmpTbLogShare_sec2 on fnaTmpTbLogShare (secLevel2)
/

create index idx_fnaTmpTbLogShare_sl on fnaTmpTbLogShare (shareLevel)
/

CREATE OR REPLACE FUNCTION getFeeTypeFeeperiod(pId IN INTEGER)
    RETURN VARCHAR2
    IS 
    pCnt INTEGER;
BEGIN
    
		select distinct feeperiod into pCnt from FnaBudgetfeeType
		where supsubject = 0
		start with id=pId
		connect by prior supsubject = id ;
		
    RETURN (pCnt);
END;
/

CREATE OR REPLACE FUNCTION getFeeTypeArchive1(pId IN INTEGER)
    RETURN VARCHAR2
    IS 
    pCnt INTEGER;
BEGIN
    
		select count(*) into pCnt from FnaBudgetfeeType
		where archive = 1 
		start with id=pId
		connect by prior supsubject = id ;
		
    RETURN (pCnt);
END;
/


create or replace trigger fnaTmpTbLogShare_Trigger before insert on fnaTmpTbLogShare for each row 
begin select fnaTmpTbLogShare_ID.nextval INTO :new.id from dual; end;
/

create or replace trigger fnaTmpTbLog_Trigger before insert on fnaTmpTbLog for each row 
begin select fnaTmpTbLog_ID.nextval INTO :new.id from dual; end;
/
