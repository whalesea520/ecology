CREATE TABLE WorkPlanType
(
   workPlanTypeID         integer   PRIMARY KEY NOT NULL,
   workPlanTypeName       varchar2(200)         NULL,
   workPlanTypeAttribute  integer                  NULL,
   workPlanTypeColor      char(7)              NULL,
   available              char(1)              NULL,
   displayOrder           integer                  NULL
)
/

create sequence  WorkPlanType_workPlanTypeID                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger WorkPlanType_trigger		
	before insert on WorkPlanType
	for each row
	begin
	select WorkPlanType_workPlanTypeID.nextval into :new.workPlanTypeID from dual;
	end ;
/





ALTER TABLE WorkPlanShare
ADD subCompanyID integer
/


CREATE TABLE WorkPlanMonitor
(
	WorkPlanMonitorID integer  PRIMARY KEY NOT NULL,
	hrmID integer NULL,
	workPlanTypeID integer NULL,
	operatorDate char(10),
	operatorTime char(8)
)
/

create sequence  WorkPlanMonitor_WorkPlanMID                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger WorkPlanMonitor_trigger		
	before insert on WorkPlanMonitor
	for each row
	begin
	select WorkPlanMonitor_WorkPlanMID.nextval into :new.WorkPlanMonitorID from dual;
	end ;
/


ALTER TABLE HrmPerformancePlanModul
ADD workPlanTypeID integer
/
ALTER TABLE HrmPerformancePlanModul
ADD remindType char(1)
/
ALTER TABLE HrmPerformancePlanModul
ADD remindBeforeStart char(1)
/
ALTER TABLE HrmPerformancePlanModul
ADD remindBeforeEnd char(1)
/
ALTER TABLE HrmPerformancePlanModul
ADD remindTimesBeforeStart integer
/
ALTER TABLE HrmPerformancePlanModul
ADD remindTimesBeforeEnd integer
/
ALTER TABLE HrmPerformancePlanModul
ADD createType char(1)
/
ALTER TABLE HrmPerformancePlanModul
ADD workPlanCreateTime char(8)
/

ALTER TABLE HrmPerformancePlanModul
ADD remindTimeBeforeStart char(8)
/
ALTER TABLE HrmPerformancePlanModul
ADD AvailableRemindBeginDate char(10)
/
ALTER TABLE HrmPerformancePlanModul
ADD AvailableRemindEndDate char(10)
/



ALTER TABLE HrmPerformancePlanModul
ADD persistentType char(1)
/
ALTER TABLE HrmPerformancePlanModul
ADD persistentTimes varchar(10)
/
ALTER TABLE HrmPerformancePlanModul
ADD availableBeginDate char(10)
/
ALTER TABLE HrmPerformancePlanModul
ADD availableEndDate char(10)
/

 CREATE OR REPLACE PROCEDURE WorkPlan_InsertPlus 
(
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
	createrid_1 integer,
	createrType_1 char,
	createdate_1 char,
	createtime_1 char,
	taskid_1 varchar2,
	urgentLevel_1 char,
	status_1 char,
	relatedprj_1	varchar2,
	relatedcus_1	varchar2,
	relatedwf_1	varchar2,
	relateddoc_1	varchar2,

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
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)	
AS

 m_id_1 integer ;
 m_deptId_1 integer ;
 m_subcoId_1 integer  ;

begin
INSERT INTO WorkPlan 
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
	type_n_1,
	name_1,
	resourceid_1,
	begindate_1,
	begintime_1,
	enddate_1,
	endtime_1,
	description_1,
	requestid_1,
	projectid_1,
	crmid_1,
	docid_1,
	meetingid_1,
	status_1,
	isremind_1,
	waketime_1,
	createrid_1,
	createdate_1,
	createtime_1,
	'0',
	taskid_1,
	urgentLevel_1,
	createrType_1,
	relatedprj_1,
	relatedcus_1,
	relatedwf_1,
	relateddoc_1,
	remindType_1,
	remindBeforeStart_1,
	remindBeforeEnd_1,
	remindTimesBeforeStart_1,
	remindTimesBeforeEnd_1,
	remindDateBeforeStart_1,
	remindTimeBeforeStart_1,
	remindDateBeforeEnd_1,
	remindTimeBeforeEnd_1,
	hrmPerformanceCheckDetailID_1
);


SELECT MAX(id) into m_id_1  FROM WorkPlan; 

SELECT departmentid into m_deptId_1  FROM HrmResource WHERE id = createrid_1 ;
SELECT subcompanyid1 into m_subcoId_1  FROM HrmResource WHERE id = createrid_1 ;

UPDATE WorkPlan SET deptId = m_deptId_1, subcompanyId = m_subcoId_1 where id = m_id_1 ;
open thecursor for 
SELECT m_id_1  id from dual;
end;
/



 CREATE OR REPLACE  PROCEDURE WorkPlan_Update
(
	id_1 integer,
	type_n_1 char,
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
	
	flag  out integer,
	msg out varchar2,
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
 
 CREATE OR REPLACE PROCEDURE WorkPlanShare_Ins 
(
	workPlanId_1 integer, 
	shareType_1 char, 
	userId_1 integer, 
	subCompanyID_1 integer,
	deptId_1 integer, 
	roleId_1 integer, 
	forAll_1 char, 
	roleLevel_1 char, 
	securityLevel_1 smallint, 
	shareLevel_1 char, 
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
)
AS

workPlanId_11 integer;

begin


                select count(workPlanId) into workPlanId_11  FROM WorkPlanShare 
		WHERE workPlanId = workPlanId_1 AND shareType = shareType_1 AND userId = userId_1 
		AND deptId = deptId_1 AND roleId = roleId_1 AND forAll = forAll_1 AND roleLevel = roleLevel_1 
		AND securityLevel = securityLevel_1 AND shareLevel = shareLevel_1 AND subCompanyID = subCompanyID_1;
  if workPlanId_11<>0 then

                open thecursor for
		SELECT -1 from dual;
		return;

	ELSE
		INSERT INTO WorkPlanShare 
		(
			workPlanId, shareType, userId, subCompanyID, deptId, roleId, forAll, roleLevel, securityLevel, shareLevel
		) 
		VALUES 
		(
			workPlanId_1, shareType_1, userId_1, subCompanyID_1, deptId_1, roleId_1, forAll_1, 
			roleLevel_1, securityLevel_1, shareLevel_1
		);
   end if;
end;
/
