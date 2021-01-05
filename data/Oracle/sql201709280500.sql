alter table hrmLeaveTypeColor add ispaidleave int
/
alter table HrmPSLPeriod add leavetype int 
/
alter table HrmPSLBatchProcess add leavetype int 
/
alter table hrmpslmanagement add leavetype int 
/

update hrmLeaveTypeColor set ispaidleave=1 where field004=-12
/
update HrmPSLPeriod set leavetype=-12 
/
update HrmPSLBatchProcess set leavetype=-12 
/
update hrmpslmanagement set leavetype=-12 
/
