create table fnaInitDataTb(
  typeName varchar2(200), 
  result1 char(1) 
)
/

update FnaBudgetfeeType set isEditFeeType = 0
/

update FnaBudgetfeeType set isEditFeeType = 1 where feelevel = 3
/


create table FnabudgetfeetypeCGE(
  mainSubjectId integer not null, 
  subjectId integer not null 
)
/

ALTER TABLE FnabudgetfeetypeCGE ADD constraints pk_FnaBftCGE primary key(mainSubjectId, subjectId)
/

ALTER TABLE FnaBudgetfeeType ADD groupCtrlGuid CHAR(32)
/
ALTER TABLE FnaBudgetfeeType ADD groupCtrlId integer 
/

ALTER TABLE FnaBudgetfeeType ADD isEditFeeTypeGuid CHAR(32)
/
ALTER TABLE FnaBudgetfeeType ADD isEditFeeTypeId integer 
/

CREATE OR REPLACE FUNCTION fnaChkSubjectAffi(pSupSubjectId IN INTEGER, pSubjectId IN INTEGER)
    RETURN INTEGER
    IS
    pCnt INTEGER;
BEGIN

    select count(*) into pCnt
    from FnaBudgetfeeType a
    where a.id = pSubjectId
    start with a.id = pSupSubjectId
    connect by prior a.id = a.supsubject;

    RETURN (pCnt);
END;
/

CREATE OR REPLACE FUNCTION fnaGetGroupCtrlKmId(pSubjectId IN INTEGER)
    RETURN INTEGER
    IS
    pGroupCtrlId INTEGER;
BEGIN

    select id into pGroupCtrlId 
    from FnaBudgetfeeType a
    where a.groupctrl = 1 
    start with a.id = pSubjectId 
    connect by prior a.supsubject = a.id;

    RETURN (pGroupCtrlId);
END;
/

CREATE OR REPLACE FUNCTION verifySameGroupCtrlSubjectId(pSubjectId IN INTEGER, pSqlSubjectId IN INTEGER)
    RETURN VARCHAR2
    IS
    pGcSubject1 INTEGER;
    pGcSubject2 INTEGER;
    pRetInt INTEGER;
BEGIN
    if (pSubjectId = pSqlSubjectId) then
	pRetInt := 1;
    else
	select a.groupCtrlId into pGcSubject1 from FnaBudgetfeeType a where a.id = pSubjectId;
	select a.groupCtrlId into pGcSubject2 from FnaBudgetfeeType a where a.id = pSqlSubjectId;
    
	if (pGcSubject1 = pGcSubject2) then
	    pRetInt := 1;
	else
	    pRetInt := 0;
	end if;
    end if;

    RETURN (pRetInt);
END;
/