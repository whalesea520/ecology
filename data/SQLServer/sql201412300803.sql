ALTER TABLE FnaSystemSet add cancelFnaEditCheck INT
GO

update FnaSystemSet set cancelFnaEditCheck = 0 
GO