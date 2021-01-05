ALTER TABLE blog_discuss   ADD score int null
/
UPDATE blog_discuss set score=0
/
ALTER TABLE blog_sysSetting   ADD isManagerScore int null
/
UPDATE blog_sysSetting SET isManagerScore=1
/
UPDATE blog_setting SET isReceive=1
/