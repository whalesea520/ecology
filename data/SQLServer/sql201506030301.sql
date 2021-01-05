delete from HtmlLabelIndex where id=84576 
GO
delete from HtmlLabelInfo where indexid=84576 
GO
INSERT INTO HtmlLabelIndex values(84576,'主键字段的值不能包含如下特殊字符：!@$%^&&quot;\?/<>') 
GO
INSERT INTO HtmlLabelInfo VALUES(84576,'主键字段的值不能包含如下特殊字符：!@$%^&&quot;\?/<>',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(84576,'The primary key field value cannot contain special characters as follows: @$%^&! &quot;/<>?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(84576,'主鍵字段的值不能包含如下特殊字符：!@$%^&&quot;\?/<>',9) 
GO