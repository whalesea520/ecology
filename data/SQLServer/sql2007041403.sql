 alter  PROCEDURE WorkPlan_Update
(
	@id_1 int,
	@type_n_1 int,
	@name_1 varchar(100),
	@resourceid_1 varchar(200),
	@begindate_1 char(10),
	@begintime_1 char(8),
	@enddate_1 char(10),
	@endtime_1 char(8),
	@description_1 text,
	@requestid_1 varchar(500),
	@projectid_1 varchar(500),
	@crmid_1 varchar(500),
	@docid_1 varchar(500),
	@meetingid_1 varchar(100),
	@isremind_1 int,
	@waketime_1 int,
	@taskid_1 varchar(500),
	@urgentLevel_1 char(1),
	
	@remindType_1 CHAR(1),
	@remindBeforeStart_1 CHAR(1),
	@remindBeforeEnd_1 CHAR(1),
	@remindTimesBeforeStart_1 int,
	@remindTimesBeforeEnd_1 int,
	@remindDateBeforeStart_1 CHAR(10),
	@remindTimeBeforeStart_1 CHAR(8),
	@remindDateBeforeEnd_1 CHAR(10),
	@remindTimeBeforeEnd_1 CHAR(8),
	
	@hrmPerformanceCheckDetailID_1 int,
	
	@flag integer output,
	@msg varchar(80) output
) 
AS 
UPDATE WorkPlan 
SET
	type_n = @type_n_1,
	name = @name_1,
	resourceid = @resourceid_1,
	begindate = @begindate_1,
	begintime = @begintime_1,
	enddate = @enddate_1,
	endtime  = @endtime_1,
	description = @description_1,
	requestid  = @requestid_1,
	projectid = @projectid_1,
	crmid  = @crmid_1,
	docid  = @docid_1,
	meetingid = @meetingid_1,
	isremind  = @isremind_1,
	waketime  = @waketime_1,
	taskid = @taskid_1,
	urgentLevel = @urgentLevel_1,
	
	remindType = @remindType_1,
	remindBeforeStart = @remindBeforeStart_1,
	remindBeforeEnd = @remindBeforeEnd_1,
	remindTimesBeforeStart = @remindTimesBeforeStart_1,
	remindTimesBeforeEnd = @remindTimesBeforeEnd_1,
	remindDateBeforeStart = @remindDateBeforeStart_1,
	remindTimeBeforeStart = @remindTimeBeforeStart_1,
	remindDateBeforeEnd = @remindDateBeforeEnd_1,
	remindTimeBeforeEnd = @remindTimeBeforeEnd_1,
	
	hrmPerformanceCheckDetailID = @hrmPerformanceCheckDetailID_1
	
	WHERE id = @id_1
GO
