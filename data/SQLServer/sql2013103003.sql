DELETE FROM hpFieldElement WHERE elementid = 16 AND fieldColumn = 'sendfrom'
GO
DECLARE  @num INT ;
SELECT @num = (SELECT max(id) FROM hpFieldElement)+1
INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,fieldwidth,valuecolumn,ordernum)
VALUES (@num,16,2034,'sendfrom',0,120,'id',3)
GO
UPDATE hpFieldElement SET ordernum = 4 WHERE id = 37
GO