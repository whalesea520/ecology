ALTER table  scratchpad  ADD padcontent_1 varchar2(4000)
/
update  scratchpad set padcontent_1 = padcontent
/
ALTER table  scratchpad  drop column padcontent
/
ALTER TABLE scratchpad RENAME COLUMN padcontent_1 TO padcontent
/