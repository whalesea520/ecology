ALTER TABLE blog_discuss   ADD score int null
GO
UPDATE blog_discuss set score=0
GO
ALTER TABLE blog_sysSetting   ADD isManagerScore int null
GO
UPDATE blog_sysSetting SET isManagerScore=1
GO
UPDATE blog_setting SET isReceive=1
GO