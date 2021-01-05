UPDATE overworkplan SET workplancolor=0
/
UPDATE WorkPlanType SET workPlanTypeColor=workplanTypeId+1 WHERE workPlanTypeID<=6
/
UPDATE WorkPlanType SET workPlanTypeColor=1 WHERE workPlanTypeID>6
/
