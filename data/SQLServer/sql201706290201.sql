delete from HtmlLabelIndex where id=131015 
GO
delete from HtmlLabelInfo where indexid=131015 
GO
INSERT INTO HtmlLabelIndex values(131015,'参数可设置如下内容，格式为：select 最终字段 from tablename where 条件字段={?currentvalue}，{?currentvalue}表示当前值') 
GO
INSERT INTO HtmlLabelInfo VALUES(131015,'参数可设置如下内容，格式为：select 最终字段 from tablename where 条件字段={?currentvalue}，{?currentvalue}表示当前值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131015,'The parameters can be set as follows: The format is selected from tablename where the condition field = { Currentvalue} Currentvalue} represents the current value',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131015,'參數可設置如下內容，格式為：select 最終字段 from tablename where 條件字段={?currentvalue}，{?currentvalue}表示當前值',9) 
GO
