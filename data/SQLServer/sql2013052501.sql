delete from HtmlLabelIndex where id=26315 
GO
delete from HtmlLabelInfo where indexid=26315 
GO
INSERT INTO HtmlLabelIndex values(26315,'必须大于') 
GO
INSERT INTO HtmlLabelInfo VALUES(26315,'必须大于',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(26315,'must be greater than',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(26315,'必須大于',9) 
GO
