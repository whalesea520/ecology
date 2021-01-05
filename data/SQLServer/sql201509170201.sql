delete from HtmlLabelIndex where id=125539 
GO
delete from HtmlLabelInfo where indexid=125539 
GO
INSERT INTO HtmlLabelIndex values(125539,'如果转换规则为自定义sql，此设置查询的是当前系统，格式为：select 最终字段 from tablename where 条件字段={?currentvalue}，{?currentvalue}为固定格式。') 
GO
INSERT INTO HtmlLabelInfo VALUES(125539,'如果转换规则为自定义sql，此设置查询的是当前系统，格式为：select 最终字段 from tablename where 条件字段={?currentvalue}，{?currentvalue}为固定格式。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125539,'If the conversion rules for the custom SQL, this query is the current system, in the format: select fields from tablename where field={?currentvalue}, {?currentvalue} is a fixed format.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125539,'如果轉換規則爲自定義sql，此設置查詢的是當前系統，格式爲：select 最終字段 from tablename where 條件字段={?currentvalue}，{?currentvalue}爲固定格式。',9) 
GO

delete from HtmlLabelIndex where id=125540 
GO
delete from HtmlLabelInfo where indexid=125540 
GO
INSERT INTO HtmlLabelIndex values(125540,'保存后详细设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(125540,'保存后详细设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125540,'Save after detailed settings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125540,'保存後詳細設置',9) 
GO

delete from HtmlLabelIndex where id=125608 
GO
delete from HtmlLabelInfo where indexid=125608 
GO
INSERT INTO HtmlLabelIndex values(125608,'被引用流程/节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(125608,'被引用流程/节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(125608,'Referenced process/node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(125608,'被引用流程/節點',9) 
GO