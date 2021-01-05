delete from HtmlLabelIndex where id=21999 
GO
delete from HtmlLabelInfo where indexid=21999 
GO
INSERT INTO HtmlLabelIndex values(21999,'此名称已经存在，请换用别的名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(21999,'此名称已经存在，请换用别的名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21999,'This name already exists, please use the other name for',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21999,'此名稱已經存在，請換用別的名稱',9) 
GO