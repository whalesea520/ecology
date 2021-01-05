alter table Workflow_TriDiffWfDiffField add condition varchar2(4000)
/
alter table Workflow_TriDiffWfDiffField add conditioncn clob
/
alter table Workflow_TriDiffWfDiffField add ruleRelationship char(1)
/
alter table Workflow_SubwfSet add condition varchar2(4000)
/
alter table Workflow_SubwfSet add conditioncn clob
/
alter table Workflow_SubwfSet add ruleRelationship char(1)
/
alter table rule_maplist add detailid integer
/