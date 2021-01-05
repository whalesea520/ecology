delete from HtmlLabelIndex where id=24483 
GO
delete from HtmlLabelInfo where indexid=24483 
GO
INSERT INTO HtmlLabelIndex values(24483,'搜索 {key} 获得约 {result} 条结果') 
GO
delete from HtmlLabelIndex where id=24484 
GO
delete from HtmlLabelInfo where indexid=24484 
GO
INSERT INTO HtmlLabelIndex values(24484,'以下是 {start}-{end} 条') 
GO
INSERT INTO HtmlLabelInfo VALUES(24483,'搜索 {key} 获得约 {result} 条结果',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24483,'search {key} and get {result} results',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24483,'搜索 {key} 獲得約 {result} 條結果',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(24484,'以下是 {start}-{end} 条',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(24484,'this is {start}-{end} results',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(24484,'以下是 {start}-{end} 條',9) 
GO
