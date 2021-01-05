ALTER TABLE FnaBudgetfeeType ADD allSupSubjectIds varchar2(900)
/

CREATE INDEX idx_fnabudgetfeetype_11 ON FnaBudgetfeeType (isEditFeeType)
/

CREATE INDEX idx_fnabudgetfeetype_12 ON FnaBudgetfeeType (groupCtrlId)
/

CREATE INDEX idx_fnabudgetfeetype_13 ON FnaBudgetfeeType (isEditFeeTypeId)
/

CREATE INDEX idx_fnabudgetfeetype_14 ON FnaBudgetfeeType (allSupSubjectIds)
/