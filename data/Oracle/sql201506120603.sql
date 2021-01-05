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
	select id into pGcSubject1 from FnaBudgetfeeType
	where groupctrl = 1
	start with id= pSubjectId
	connect by prior supsubject = id ;

	select id into pGcSubject2 from FnaBudgetfeeType
	where groupctrl = 1
	start with id= pSqlSubjectId
	connect by prior supsubject = id ;
    
	if (pGcSubject1 = pGcSubject2) then
	    pRetInt := 1;
	else
	    pRetInt := 0;
	end if;
    end if;

    RETURN (pRetInt);
END;
/