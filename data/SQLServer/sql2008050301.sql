delete from HtmlLabelIndex where id=21445 
GO
delete from HtmlLabelInfo where indexid=21445 
GO
INSERT INTO HtmlLabelIndex values(21445,'姓名已经存在,是否继续？') 
GO
INSERT INTO HtmlLabelInfo VALUES(21445,'姓名已经存在,是否继续？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21445,'NameAlreadyExists,Continue?',8) 
GO



delete from HtmlLabelIndex where id=21446 
GO
delete from HtmlLabelInfo where indexid=21446 
GO
INSERT INTO HtmlLabelIndex values(21446,'编号和姓名都已经存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(21446,'编号和姓名都已经存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21446,'NumberAndNamesHavebeenthere',8) 
GO


delete from HtmlLabelIndex where id=21447 
GO
delete from HtmlLabelInfo where indexid=21447 
GO
INSERT INTO HtmlLabelIndex values(21447,'编号已经存在') 
GO
INSERT INTO HtmlLabelInfo VALUES(21447,'编号已经存在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21447,'No.AlreadyExists',8) 
GO