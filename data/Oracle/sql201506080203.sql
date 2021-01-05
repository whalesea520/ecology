ALTER TABLE OfNoticeRote ADD roomauth CHAR(1)
/

UPDATE OfNoticeRote SET roomauth=groupauth
/