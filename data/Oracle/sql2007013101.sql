

INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder)
VALUES('工作安排', 6, '#FF0000', '1', 0)
/
INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder)
VALUES('会议日程', 6, '#00FF00', '1', 1)
/
INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder)
VALUES('项目日程', 6, '#0000FF', '1', 2)
/
INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder)
VALUES('客户联系', 6, '#FFFF00', '1', 3)
/
INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder)
VALUES('个人便签', 6, '#00FFFF', '1', 4)
/
INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder)
VALUES('目标绩效', 6, '#999999', '1', 5)
/
INSERT INTO WorkPlanType(workPlanTypeName, workPlanTypeAttribute, workPlanTypeColor, available, displayOrder)
VALUES('目标计划', 6, '#FF00FF', '1', 6)
/


DELETE FROM HtmlLabelIndex WHERE id = 20210
/
DELETE FROM HtmlLabelInfo WHERE indexId = 20210
/
INSERT INTO HtmlLabelIndex values(20210,'该日程类型被引用，无法删除！') 
/
INSERT INTO HtmlLabelInfo VALUES(20210,'该日程类型被引用，无法删除！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20210,'The Work Plan Type can not be deleted because it has been refered!',8) 
/