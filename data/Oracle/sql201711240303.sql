ALTER TABLE FnaSystemSet add subjectCodeUniqueCtrl2 INTeger
/

update FnaSystemSet set subjectCodeUniqueCtrl2 = 1 
/


drop index IDX_FNABUDGETFEETYPE_9 
/


ALTER TABLE FnaBudgetfeeType modify codeName varchar2(100)
/

update FnaBudgetfeeType set codeName = rtrim(codeName)
/

ALTER TABLE FnaBudgetfeeType add codeName2 varchar2(100)
/