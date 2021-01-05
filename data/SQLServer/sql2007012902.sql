EXECUTE LMConfig_U_ByInfoInsert 3,97,5
GO
EXECUTE LMInfo_Insert 209,18220,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/hrm/performance/targetPlan/PlanModulList.jsp',3,97,5,2
GO

UPDATE LeftMenuInfo SET linkAddress = '/hrm/performance/targetPlan/PlanModulList.jsp?target=workplan' WHERE id = 209
GO
