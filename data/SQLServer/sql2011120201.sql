delete from HtmlLabelIndex where id=27471 
GO
delete from HtmlLabelInfo where indexid=27471 
GO
INSERT INTO HtmlLabelIndex values(27471,'列3显示名') 
GO
INSERT INTO HtmlLabelInfo VALUES(27471,'列3显示名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27471,'column 3',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27471,'列3顯示名',9) 
GO

delete from HtmlLabelIndex where id=27472 
GO
delete from HtmlLabelInfo where indexid=27472 
GO
INSERT INTO HtmlLabelIndex values(27472,'“列1显示名”、“列2显示名”和“列3显示名”指定无条件查询的第二列、第三列和第四列对应的字段说明') 
GO
INSERT INTO HtmlLabelInfo VALUES(27472,'“列1显示名”、“列2显示名”和“列3显示名”指定无条件查询的第二列、第三列和第四列对应的字段说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27472,'"Column 1 shows the name" and "Column 2 shows the name " and "Column 3 shows the name" designated unconditional query in the second column and third column shows and fourth column shows the corresponding field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27472,'“列1顯示名”、“列2顯示名”和“列3顯示名”指定無條件查詢的第二列、第三列和第四列對應的字段說明',9) 
GO

delete from HtmlLabelIndex where id=27473 
GO
delete from HtmlLabelInfo where indexid=27473 
GO
INSERT INTO HtmlLabelIndex values(27473,'自定义浏览页面只能显示一个查询条件和三列内容，即所有查询不能超过四个字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(27473,'自定义浏览页面只能显示一个查询条件和三列内容，即所有查询不能超过四个字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27473,'Can not exceed four fields',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27473,'自定義浏覽頁面隻能顯示一個查詢條件和三列内容，即所有查詢不能超過四個字段',9) 
GO
