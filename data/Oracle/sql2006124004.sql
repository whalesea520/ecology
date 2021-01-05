ALTER TABLE WorkPlan ADD remindType char(1)
/
ALTER TABLE WorkPlan ADD remindTimesBeforeStart integer
/
ALTER TABLE WorkPlan ADD remindTimesBeforeEnd integer
/
ALTER TABLE WorkPlan ADD remindBeforeStart char(1)
/
ALTER TABLE WorkPlan ADD remindBeforeEnd char(1)
/
ALTER TABLE WorkPlan ADD remindDateBeforeStart char(10)
/
ALTER TABLE WorkPlan ADD remindTimeBeforeStart char(8)
/
ALTER TABLE WorkPlan ADD remindDateBeforeEnd char(10)
/
ALTER TABLE WorkPlan ADD remindTimeBeforeEnd char(8)
/
ALTER TABLE WorkPlan ADD hrmPerformanceCheckDetailID integer
/
DROP INDEX WorkPlan_type_n
/

ALTER TABLE WorkPlan ADD type_temp integer
/
update	WorkPlan set type_temp=type_n
/
ALTER TABLE WorkPlan drop column   type_n
/
ALTER TABLE WorkPlan ADD type_n integer
/
update	WorkPlan set type_n=type_temp
/
ALTER TABLE WorkPlan drop column   type_temp
/
CREATE INDEX WorkPlan_type_n ON WorkPlan
(
	type_n ASC
)
/
