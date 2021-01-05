delete from HtmlLabelIndex where id=21425 
GO
delete from HtmlLabelInfo where indexid=21425 
GO
INSERT INTO HtmlLabelIndex values(21425,'代表流程的主干节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(21425,'代表流程的主干节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21425,'Process on behalf of the trunk node',8) 
GO
delete from HtmlLabelIndex where id=21426 
GO
delete from HtmlLabelInfo where indexid=21426 
GO
INSERT INTO HtmlLabelIndex values(21426,'代表流程从该节点进行分支，一个流程最多只能有一个分叉起始点') 
GO
INSERT INTO HtmlLabelInfo VALUES(21426,'代表流程从该节点进行分支，一个流程最多只能有一个分叉起始点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21426,'Representative flow from the node to branch, a process can only be a starting point of bifurcation',8) 
GO
delete from HtmlLabelIndex where id=21427 
GO
delete from HtmlLabelInfo where indexid=21427 
GO
INSERT INTO HtmlLabelIndex values(21427,'代表分叉起始节点到分支合并节点之间的节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(21427,'代表分叉起始节点到分支合并节点之间的节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21427,'Start on behalf of bifurcation node to node branch of the merger between the nodes',8) 
GO
delete from HtmlLabelIndex where id=21428 
GO
delete from HtmlLabelInfo where indexid=21428 
GO
INSERT INTO HtmlLabelIndex values(21428,'代表按照流程已经通过分支的数量来决定是否可以到达该合并节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(21428,'代表按照流程已经通过分支的数量来决定是否可以到达该合并节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21428,'Processes have been adopted in accordance with the representative of the number of branches to decide whether the merger can be reached nodes',8) 
GO
delete from HtmlLabelIndex where id=21429 
GO
delete from HtmlLabelInfo where indexid=21429 
GO
INSERT INTO HtmlLabelIndex values(21429,'代表按照流程出口设置中设置的必须通过的分支是否都已经通过来决定是否可以到达该合并节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(21429,'代表按照流程出口设置中设置的必须通过的分支是否都已经通过来决定是否可以到达该合并节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21429,'On behalf of exports in accordance with the procedures set up a branch must pass through it have to decide whether the merger can be reached nodes',8) 
GO