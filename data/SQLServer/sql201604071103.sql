ALTER TABLE FnaSystemSet ADD timeModul INT
GO

ALTER TABLE FnaSystemSet ADD dayTime1 INT
GO

ALTER TABLE FnaSystemSet ADD fer INT
GO

ALTER TABLE FnaSystemSet ADD dayTime2 INT
GO

update FnaSystemSet set timeModul = 0, dayTime1 = 1, fer = 1, dayTime2 = 1
GO