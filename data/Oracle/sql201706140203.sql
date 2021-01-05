ALTER TABLE DocReceiveUnit ADD showorder_new NUMBER(15,2)
/
UPDATE DocReceiveUnit SET showorder_new=showorder
/
ALTER TABLE DocReceiveUnit DROP COLUMN showorder
/
ALTER TABLE DocReceiveUnit RENAME COLUMN showorder_new TO showorder
/