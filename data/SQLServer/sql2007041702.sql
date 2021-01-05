DELETE FROM MainMenuInfo WHERE id = 582 AND labelId = 19042
GO
DELETE FROM MainMenuConfig WHERE infoId = 582
GO

DELETE FROM LeftMenuInfo WHERE id = 150 AND labelId = 19057
GO
DELETE FROM LeftMenuConfig WHERE infoId = 150
GO

DELETE FROM LeftMenuInfo WHERE labelId = 19058
GO
DELETE FROM LeftMenuConfig WHERE infoId = 151
GO