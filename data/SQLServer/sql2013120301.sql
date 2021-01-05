delete from HtmlLabelIndex where id=27922
GO
delete from HtmlLabelInfo where indexid=27922
GO
INSERT INTO HtmlLabelIndex values(27922,'执行WebService接口/自定义接口后获得返回值，直接与设置的返回值做比较。如果相同，则表示执行成功') 
GO
INSERT INTO HtmlLabelInfo VALUES(27922,'执行WebService接口/自定义接口后获得返回值，直接与设置的返回值做比较。如果相同，则表示执行成功',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27922,'Return value from WebService or custom interface is a string.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27922,'執行WebService接口/自定義接口後獲得返回值，直接與設置的返回值做比較。如果相同，則表示執行成功',9) 
GO

delete from HtmlLabelIndex where id=27923 
GO
delete from HtmlLabelInfo where indexid=27923 
GO
INSERT INTO HtmlLabelIndex values(27923,'执行WebService接口/自定义接口后获得返回值，直接替换下方设置的SQL语句中的返回值标签，并执行该SQL') 
GO
INSERT INTO HtmlLabelInfo VALUES(27923,'执行WebService接口/自定义接口后获得返回值，直接替换下方设置的SQL语句中的返回值标签，并执行该SQL',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27923,'Return value from WebService or custom interface will be executed as a sql.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27923,'執行WebService接口/自定義接口後獲得返回值，直接替換下方設置的SQL語句中的返回值标簽，并執行該SQL',9) 
GO