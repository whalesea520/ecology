DELETE FROM hpFieldElement WHERE elementid = 16 AND fieldColumn = 'sendfrom'
/
INSERT INTO hpFieldElement(id,elementid,fieldname,fieldColumn,isDate,fieldwidth,valuecolumn,ordernum)
VALUES ((SELECT max(id) FROM hpFieldElement)+1,16,2034,'sendfrom',0,120,'id',3)
/
UPDATE hpFieldElement SET ordernum = 4 WHERE id = 37
/