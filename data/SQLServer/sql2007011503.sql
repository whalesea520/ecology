CREATE TABLE WorkPlanType
(
   workPlanTypeID         int IDENTITY(0, 1)   PRIMARY KEY NOT NULL,
   workPlanTypeName       varchar(200)         NULL,
   workPlanTypeAttribute  int                  NULL,
   workPlanTypeColor      char(7)              NULL,
   available              char(1)              NULL,
   displayOrder           int                  NULL
)
GO




ALTER TABLE WorkPlanShare
ADD subCompanyID int
GO


CREATE TABLE WorkPlanMonitor
(
	WorkPlanMonitorID int IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	hrmID int NULL,
	workPlanTypeID int NULL,
	operatorDate char(10),
	operatorTime char(8)
)
GO

ALTER TABLE HrmPerformancePlanModul
ADD workPlanTypeID int
GO
ALTER TABLE HrmPerformancePlanModul
ADD remindType char(1)
GO
ALTER TABLE HrmPerformancePlanModul
ADD remindBeforeStart char(1)
GO
ALTER TABLE HrmPerformancePlanModul
ADD remindBeforeEnd char(1)
GO
ALTER TABLE HrmPerformancePlanModul
ADD remindTimesBeforeStart int
GO
ALTER TABLE HrmPerformancePlanModul
ADD remindTimesBeforeEnd int
GO
ALTER TABLE HrmPerformancePlanModul
ADD createType char(1)
GO
ALTER TABLE HrmPerformancePlanModul
ADD workPlanCreateTime char(8)
GO

ALTER TABLE HrmPerformancePlanModul
ADD remindTimeBeforeStart char(8)
GO
ALTER TABLE HrmPerformancePlanModul
ADD AvailableRemindBeginDate char(10)
GO
ALTER TABLE HrmPerformancePlanModul
ADD AvailableRemindEndDate char(10)
GO



ALTER TABLE HrmPerformancePlanModul
ADD persistentType char(1)
GO
ALTER TABLE HrmPerformancePlanModul
ADD persistentTimes varchar(10)
GO
ALTER TABLE HrmPerformancePlanModul
ADD availableBeginDate char(10)
GO
ALTER TABLE HrmPerformancePlanModul
ADD availableEndDate char(10)
GO

 ALTER PROCEDURE WorkPlan_InsertPlus 
(
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
	@createrid_1 int,
	@createrType_1 char(1),
	@createdate_1 char(10),
	@createtime_1 char(8),
	@taskid_1 varchar(500),
	@urgentLevel_1 char(1),
	@status_1 char(1),
	@relatedprj_1	[varchar](500),
	@relatedcus_1	[varchar](500),
	@relatedwf_1	[varchar](500),
	@relateddoc_1	[varchar](500),

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
AS INSERT INTO WorkPlan 
(
	type_n,
	name,
	resourceid,
	begindate,
	begintime,
	enddate,
	endtime,
	description,
	requestid,
	projectid,
	crmid,
	docid,
	meetingid,
	status,
	isremind,
	waketime,
	createrid,
	createdate,
	createtime,
	deleted,
	taskid,
	urgentLevel,
	createrType,
	relatedprj,
	relatedcus,
	relatedwf,
	relateddoc,

	remindType,
	remindBeforeStart,
	remindBeforeEnd,
	remindTimesBeforeStart,
	remindTimesBeforeEnd,
	remindDateBeforeStart,
	remindTimeBeforeStart,
	remindDateBeforeEnd,
	remindTimeBeforeEnd,
	hrmPerformanceCheckDetailID
) 
VALUES 
(
	@type_n_1,
	@name_1,
	@resourceid_1,
	@begindate_1,
	@begintime_1,
	@enddate_1,
	@endtime_1,
	@description_1,
	@requestid_1,
	@projectid_1,
	@crmid_1,
	@docid_1,
	@meetingid_1,
	@status_1,
	@isremind_1,
	@waketime_1,
	@createrid_1,
	@createdate_1,
	@createtime_1,
	'0',
	@taskid_1,
	@urgentLevel_1,
	@createrType_1,
	@relatedprj_1,
	@relatedcus_1,
	@relatedwf_1,
	@relateddoc_1,
	@remindType_1,
	@remindBeforeStart_1,
	@remindBeforeEnd_1,
	@remindTimesBeforeStart_1,
	@remindTimesBeforeEnd_1,
	@remindDateBeforeStart_1,
	@remindTimeBeforeStart_1,
	@remindDateBeforeEnd_1,
	@remindTimeBeforeEnd_1,
	@hrmPerformanceCheckDetailID_1
)
DECLARE @m_id int 
DECLARE @m_deptId int 
DECLARE @m_subcoId int  
SELECT @m_id = MAX(id) FROM WorkPlan SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @createrid_1 
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_id SELECT @m_id AS id

GO

 ALTER  PROCEDURE WorkPlan_Update
(
	@id_1 int,
	@type_n_1 char(1),
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
 
 ALTER PROCEDURE WorkPlanShare_Ins 
(
	@workPlanId_1 int, 
	@shareType_1 char(1), 
	@userId_1 int, 
	@subCompanyID_1 int,
	@deptId_1 int, 
	@roleId_1 int, 
	@forAll_1 char(1), 
	@roleLevel_1 char(1), 
	@securityLevel_1 tinyint, 
	@shareLevel_1 char(1), 
	@flag integer output , 
	@msg varchar(80) output
)
AS
	IF EXISTS 
	(
		SELECT workPlanId FROM WorkPlanShare 
		WHERE workPlanId = @workPlanId_1 AND shareType = @shareType_1 AND userId = @userId_1 
		AND deptId = @deptId_1 AND roleId = @roleId_1 AND forAll = @forAll_1 AND roleLevel = @roleLevel_1 
		AND securityLevel = @securityLevel_1 AND shareLevel = @shareLevel_1 AND subCompanyID = @subCompanyID_1
	)
		BEGIN
			SELECT -1 
			RETURN
		END
	ELSE
		INSERT INTO WorkPlanShare 
		(
			workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel
		) 
		VALUES 
		(
			@workPlanId_1, @shareType_1, @userId_1, @subCompanyID_1, @deptId_1, @roleId_1, @forAll_1, 
			@roleLevel_1, @securityLevel_1, @shareLevel_1
		)
GO
