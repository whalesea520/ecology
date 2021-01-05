alter table Workflow_TriDiffWfDiffField add condition varchar(4000)
GO
alter table Workflow_TriDiffWfDiffField add conditioncn text
GO
alter table Workflow_TriDiffWfDiffField add ruleRelationship char(1)
GO
alter table Workflow_SubwfSet add condition varchar(4000)
GO
alter table Workflow_SubwfSet add conditioncn text
GO
alter table Workflow_SubwfSet add ruleRelationship char(1)
GO
alter table rule_maplist add detailid int
GO