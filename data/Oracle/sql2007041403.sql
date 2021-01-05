 create or replace  PROCEDURE WorkPlan_Update
(
	id_1 integer,
	type_n_1 integer,
	name_1 varchar2,
	resourceid_1 varchar2,
	begindate_1 char,
	begintime_1 char,
	enddate_1 char,
	endtime_1 char,
	description_1 clob,
	requestid_1 varchar2,
	projectid_1 varchar2,
	crmid_1 varchar2,
	docid_1 varchar2,
	meetingid_1 varchar2,
	isremind_1 integer,
	waketime_1 integer,
	taskid_1 varchar2,
	urgentLevel_1 char,
	
	remindType_1 CHAR,
	remindBeforeStart_1 CHAR,
	remindBeforeEnd_1 CHAR,
	remindTimesBeforeStart_1 integer,
	remindTimesBeforeEnd_1 integer,
	remindDateBeforeStart_1 CHAR,
	remindTimeBeforeStart_1 CHAR,
	remindDateBeforeEnd_1 CHAR,
	remindTimeBeforeEnd_1 CHAR,
	
	hrmPerformanceCheckDetailID_1 integer,
	
	flag out integer ,
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
begin

UPDATE WorkPlan 
SET
	type_n = type_n_1,
	name = name_1,
	resourceid = resourceid_1,
	begindate = begindate_1,
	begintime = begintime_1,
	enddate = enddate_1,
	endtime  = endtime_1,
	description = description_1,
	requestid  = requestid_1,
	projectid = projectid_1,
	crmid  = crmid_1,
	docid  = docid_1,
	meetingid = meetingid_1,
	isremind  = isremind_1,
	waketime  = waketime_1,
	taskid = taskid_1,
	urgentLevel = urgentLevel_1,
	
	remindType = remindType_1,
	remindBeforeStart = remindBeforeStart_1,
	remindBeforeEnd = remindBeforeEnd_1,
	remindTimesBeforeStart = remindTimesBeforeStart_1,
	remindTimesBeforeEnd = remindTimesBeforeEnd_1,
	remindDateBeforeStart = remindDateBeforeStart_1,
	remindTimeBeforeStart = remindTimeBeforeStart_1,
	remindDateBeforeEnd = remindDateBeforeEnd_1,
	remindTimeBeforeEnd = remindTimeBeforeEnd_1,
	
	hrmPerformanceCheckDetailID = hrmPerformanceCheckDetailID_1
	
	WHERE id = id_1;
end;
/
