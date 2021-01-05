ALTER TABLE blog_discuss   ADD comefrom integer NULL
/
UPDATE blog_discuss SET comefrom=0
/
ALTER TABLE blog_reply   ADD comefrom integer NULL
/
UPDATE blog_reply SET comefrom=0
/
