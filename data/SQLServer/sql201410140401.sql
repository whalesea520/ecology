delete from HtmlLabelIndex where id=33335 
GO
delete from HtmlLabelInfo where indexid=33335 
GO
INSERT INTO HtmlLabelIndex values(33335,'法定假日加班') 
GO
INSERT INTO HtmlLabelInfo VALUES(33335,'法定假日加班',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33335,'StatutoryHolidayOvertime',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33335,'法定假日加班',9) 
GO

delete from HtmlLabelIndex where id=32104 
GO
delete from HtmlLabelInfo where indexid=32104 
GO
INSERT INTO HtmlLabelIndex values(32104,'异常') 
GO
INSERT INTO HtmlLabelInfo VALUES(32104,'异常',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32104,'ExceptionType',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32104,'異常',9) 
GO