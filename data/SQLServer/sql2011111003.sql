ALTER TABLE blog_discuss   ADD comefrom int NULL
GO
UPDATE blog_discuss SET comefrom=0
GO
ALTER TABLE blog_reply   ADD comefrom int NULL
GO
UPDATE blog_reply SET comefrom=0
GO
