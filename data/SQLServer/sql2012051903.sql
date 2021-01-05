SELECT distinct * into HtmlLabel_TEMPTABLE from HtmlLabelIndex
DELETE FROM HtmlLabelIndex
Insert into HtmlLabelIndex(id, indexdesc) select id, indexdesc from HtmlLabel_TEMPTABLE
drop table HtmlLabel_TEMPTABLE
GO

SELECT distinct * into HtmlLabel_TEMPTABLE from HtmlLabelInfo
DELETE FROM HtmlLabelInfo
Insert into HtmlLabelInfo(indexid, labelname, languageid) select indexid, labelname, languageid from HtmlLabel_TEMPTABLE
drop table HtmlLabel_TEMPTABLE
GO