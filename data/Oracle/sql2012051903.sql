create table HtmlLabel_TEMPTABLE as select distinct * from HtmlLabelIndex
/
DELETE FROM HtmlLabelIndex
/
Insert into HtmlLabelIndex(id, indexdesc) select id, indexdesc from HtmlLabel_TEMPTABLE
/
drop table HtmlLabel_TEMPTABLE
/
create table HtmlLabel_TEMPTABLE as select distinct * from HtmlLabelInfo
/
DELETE FROM HtmlLabelInfo
/
Insert into HtmlLabelInfo(indexid, labelname, languageid) select indexid, labelname, languageid from HtmlLabel_TEMPTABLE
/
drop table HtmlLabel_TEMPTABLE
/