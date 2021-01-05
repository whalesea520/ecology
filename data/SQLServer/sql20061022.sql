update HtmlLabelIndex set indexDesc='室编件号' where id=19124
GO

update HtmlLabelInfo  set labelName='室编件号' where indexId=19124 and languageId=7
GO

update HtmlLabelInfo  set labelName='Room Code' where indexId=19124 and languageId=8
GO

update HtmlLabelIndex set indexDesc='起止件号' where id=19128
GO

update HtmlLabelInfo  set labelName='起止件号' where indexId=19128 and languageId=7
GO

update HtmlLabelInfo  set labelName='BeginEnd Archival Code' where indexId=19128 and languageId=8
GO

INSERT INTO HtmlLabelIndex values(19933,'借阅日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(19933,'借阅日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19933,'Borrow Date',8) 
GO

INSERT INTO HtmlLabelIndex values(19942,'备考查询') 
GO
INSERT INTO HtmlLabelInfo VALUES(19942,'备考查询',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19942,'For Reference Inquiry',8) 
GO

INSERT INTO HtmlLabelIndex values(19963,'按文档目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(19963,'按文档目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19963,'By Catalog',8) 
GO


delete from HtmlLabelIndex  where id=19689
GO

delete from HtmlLabelInfo   where indexId=19689
GO

INSERT INTO HtmlLabelIndex values(19689,'请先选择操作的记录！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19689,'请先选择操作的记录！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19689,'Please choose the operated record first!',8) 
GO
delete from HtmlLabelIndex where id=18412
GO
delete from HtmlLabelInfo where indexId=18412
GO
INSERT INTO HtmlLabelIndex values(18412,'组合查询') 
GO
INSERT INTO HtmlLabelInfo VALUES(18412,'组合查询',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18412,'Condition Search',8) 
GO