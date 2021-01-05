INSERT INTO HtmlLabelIndex values(18987,'被包含于') 
GO
INSERT INTO HtmlLabelIndex values(18988,'不被包含于') 
GO
INSERT INTO HtmlLabelInfo VALUES(18987,'被包含于',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18987,'in',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18988,'不被包含于',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18988,'not in',8) 
GO

INSERT INTO HtmlLabelIndex values(17892,'批次') 
GO
INSERT INTO HtmlLabelInfo VALUES(17892,'批次',7) 
GO
INSERT INTO HtmlLabelIndex values(19008,'不在') 
GO
INSERT INTO HtmlLabelIndex values(19009,'里') 
GO
INSERT INTO HtmlLabelInfo VALUES(19008,'不在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19008,'not in',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19009,'里',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19009,'',8) 
GO
INSERT INTO HtmlLabelIndex values(18805,'在') 
GO
INSERT INTO HtmlLabelInfo VALUES(18805,'在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18805,'in',8) 
GO

INSERT INTO HtmlLabelIndex values(19012,'在同一批次里取得操作者的时候，可以根据设置的条件选择具体操作者，设置条件的依据为表单中的所有字段和一些初始信息(创建人,创建人经理,创建人本部门,创建人本分部)。') 
GO
INSERT INTO HtmlLabelInfo VALUES(19012,'在同一批次里取得操作者的时候，可以根据设置的条件选择具体操作者，设置条件的依据为表单中的所有字段和一些初始信息(创建人,创建人经理,创建人本部门,创建人本分部)。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19012,'Obtains operator''s time in the identical raid, may act according to the condition choice concrete operator which establishes, the establishment condition basis for form in all fields and some initial information (the founder,Founder manager,Founder this',8) 
GO

INSERT INTO HtmlLabelIndex values(19013,'批次是流程中选择操作者的执行顺序，按批次从小到大选择同一批次的操作者，上一批次如果没有符合条件操作者则继续搜索下一批次的操作者，如果上一批次有符合条件操作者，则不再搜索下一批次。') 
GO
INSERT INTO HtmlLabelInfo VALUES(19013,'批次是流程中选择操作者的执行顺序，按批次从小到大选择同一批次的操作者，上一批次如果没有符合条件操作者则继续搜索下一批次的操作者，如果上一批次有符合条件操作者，则不再搜索下一批次。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19013,'The raid is in the flow chooses the operator to carry out the order, chooses the identical raid of operator from infancy to maturity according to the raid, on a raid if has not conformed to the condition operator then continues the search next raid of ope',8) 
GO


INSERT INTO HtmlLabelIndex values(19011,'创建和归档节点不需要设置批次和条件。') 
GO
INSERT INTO HtmlLabelInfo VALUES(19011,'创建和归档节点不需要设置批次和条件。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19011,'the node of create or process is not set conditions and order。',8) 
GO
alter table workflow_groupdetail add 
conditions varchar(1000),
conditioncn varchar(1000),
orders varchar(5)
Go

update  workflow_groupdetail set orders='0'
Go

alter  PROCEDURE workflow_groupdetail_Insert 
(@groupid_1 	int, 
@type_2 	int, 
@objid_3 	int, 
@level_4 	int, 
@level2_5 	int,
@conditions varchar(1000),
@conditioncn varchar(1000),
@orders varchar(5), 
@flag integer output , 
@msg varchar(80) output ) 
AS 
INSERT INTO workflow_groupdetail ( groupid, type, objid, level_n, level2_n,conditions,conditioncn,orders)  VALUES ( @groupid_1, @type_2, @objid_3, @level_4, @level2_5,@conditions,@conditioncn,@orders) 
set @flag = 0 set @msg = 'ok' 
go

