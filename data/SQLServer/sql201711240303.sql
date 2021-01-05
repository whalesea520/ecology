ALTER TABLE FnaSystemSet add subjectCodeUniqueCtrl2 INT
GO

update FnaSystemSet set subjectCodeUniqueCtrl2 = 1 
GO

drop index IDX_FNABUDGETFEETYPE_9 on FnaBudgetfeeType 
GO

ALTER TABLE FnaBudgetfeeType ALTER COLUMN codeName varchar(100)
GO

update FnaBudgetfeeType set codeName = rtrim(codeName)
GO

ALTER TABLE FnaBudgetfeeType add codeName2 varchar(100)
GO