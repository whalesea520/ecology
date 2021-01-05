ALTER TABLE OfNoticeRote ADD roomauth CHAR(1);
GO

UPDATE OfNoticeRote SET roomauth=groupauth;
GO