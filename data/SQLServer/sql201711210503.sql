ALTER TABLE FnaSystemSet add subjectCodeUniqueCtrl INT
GO

update FnaSystemSet set subjectCodeUniqueCtrl = 0 
GO