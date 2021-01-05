
delete from HtmlLabelIndex where id=81501
GO
delete from HtmlLabelIndex where id=81502
GO
delete from HtmlLabelIndex where id=81503
GO
delete from HtmlLabelIndex where id=81504
GO
delete from HtmlLabelIndex where id=81505
GO
delete from HtmlLabelIndex where id=81506
GO

delete from HtmlLabelInfo where indexid=81501
GO
delete from HtmlLabelInfo where indexid=81502
GO
delete from HtmlLabelInfo where indexid=81503
GO
delete from HtmlLabelInfo where indexid=81504
GO
delete from HtmlLabelInfo where indexid=81505
GO
delete from HtmlLabelInfo where indexid=81506
GO

INSERT INTO HtmlLabelIndex values(81501,'本节点部分属性需要先保存流程图才能进行修改')
GO
INSERT INTO HtmlLabelIndex values(81502,'需要先保存流程图才能对新增节点和出口进行详细属性设置')
GO
INSERT INTO HtmlLabelIndex values(81503,'只能有一个创建节点！')
GO
INSERT INTO HtmlLabelIndex values(81504,'节点名称不能相同！')
GO
INSERT INTO HtmlLabelIndex values(81505,'出口名称不能为空')
GO
INSERT INTO HtmlLabelIndex values(81506,'节点名称不能为空')
GO

INSERT INTO HtmlLabelInfo values(81501,'本节点部分属性需要先保存流程图才能进行修改',7)
GO
INSERT INTO HtmlLabelInfo values(81501,'Some attributes of the node could be modified only after the flow chart is saved.',8)
GO
INSERT INTO HtmlLabelInfo values(81501,'本節點部分屬性需要先保存流程圖才能進行修改',9)
GO
INSERT INTO HtmlLabelInfo values(81502,'需要先保存流程图才能对新增节点和出口进行详细属性设置',7)
GO
INSERT INTO HtmlLabelInfo values(81502,'It is needed to?save the?flow chart?before?detailed?property settings for new?nodes and?outlets.',8)
GO
INSERT INTO HtmlLabelInfo values(81502,'需要先保存流程圖才能對新增節點和出口進行詳細屬性設置',9)
GO
INSERT INTO HtmlLabelInfo values(81503,'只能有一个创建节点！',7)
GO
INSERT INTO HtmlLabelInfo values(81503,'There can be only one?node creation!',8)
GO
INSERT INTO HtmlLabelInfo values(81503,'只能有一個創建節點！',9)
GO
INSERT INTO HtmlLabelInfo values(81504,'节点名称不能相同！',7)
GO
INSERT INTO HtmlLabelInfo values(81504,'Node names must not be same!',8)
GO
INSERT INTO HtmlLabelInfo values(81504,'節點名稱不能相同！',9)
GO
INSERT INTO HtmlLabelInfo values(81505,'出口名称不能为空',7)
GO
INSERT INTO HtmlLabelInfo values(81505,'Outlets''?name cannot be empty.',8)
GO
INSERT INTO HtmlLabelInfo values(81505,'出口名稱不能為空',9)
GO
INSERT INTO HtmlLabelInfo values(81506,'节点名称不能为空',7)
GO
INSERT INTO HtmlLabelInfo values(81506,'Node?name cannot be empty',8)
GO
INSERT INTO HtmlLabelInfo values(81506,'節點名稱不能為空',9)
GO


