UPDATE AppHomepage SET pageattr = '{"isDownRefresh":0,"onloadScript":""}' where pageattr is null
GO
UPDATE AppHomepage SET pageattr = REPLACE(Cast(pageattr as varchar(4000)), '"isDownRefresh":1', '"isDownRefresh":0')
GO