ALTER TABLE WorkPlan
ADD remindType char(1)
GO
ALTER TABLE WorkPlan
ADD remindTimesBeforeStart int
GO
ALTER TABLE WorkPlan
ADD remindTimesBeforeEnd int
GO
ALTER TABLE WorkPlan
ADD remindBeforeStart char(1)
GO
ALTER TABLE WorkPlan
ADD remindBeforeEnd char(1)
GO
ALTER TABLE WorkPlan
ADD remindDateBeforeStart char(10)
GO
ALTER TABLE WorkPlan
ADD remindTimeBeforeStart char(8)
GO
ALTER TABLE WorkPlan
ADD remindDateBeforeEnd char(10)
GO
ALTER TABLE WorkPlan
ADD remindTimeBeforeEnd char(8)
GO
ALTER TABLE WorkPlan
ADD hrmPerformanceCheckDetailID int
GO
DROP INDEX WorkPlan.WorkPlan_type_n

ALTER TABLE WorkPlan
ALTER COLUMN type_n int
GO

CREATE INDEX WorkPlan_type_n ON WorkPlan
(
	type_n ASC
)
