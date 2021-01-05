ALTER TABLE FnaBudgetfeeType ADD allSupSubjectIds varchar(900)
GO

CREATE INDEX idx_fnabudgetfeetype_11 ON FnaBudgetfeeType (isEditFeeType)
GO

CREATE INDEX idx_fnabudgetfeetype_12 ON FnaBudgetfeeType (groupCtrlId)
GO

CREATE INDEX idx_fnabudgetfeetype_13 ON FnaBudgetfeeType (isEditFeeTypeId)
GO

CREATE INDEX idx_fnabudgetfeetype_14 ON FnaBudgetfeeType (allSupSubjectIds)
GO