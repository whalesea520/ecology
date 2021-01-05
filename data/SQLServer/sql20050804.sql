/*更新中文条件为原有英文条件，防止原有流程的条件显示为空*/
UPDATE workflow_nodelink SET conditioncn=condition
GO
