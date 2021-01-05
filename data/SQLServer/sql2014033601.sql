delete from HtmlLabelIndex where id=98 
GO
delete from HtmlLabelInfo where indexid=98 
GO
INSERT INTO HtmlLabelIndex values(98,'科目对应期间已经存在变更，不能再进行添加！') 
GO
INSERT INTO HtmlLabelInfo VALUES(98,'科目对应期间已经存在变更，不能再进行添加！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(98,'The period corresponding the subject has been changed and cannot been added!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(98,'科目對應期間已經存在變更，不能再進行添加！',9) 
GO
