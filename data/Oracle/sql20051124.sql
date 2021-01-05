alter table WorkPlan modify(requestid varchar2(500))
/
alter table WorkPlan modify(projectid varchar2(500))
/
alter table WorkPlan modify(crmid varchar2(500))
/
alter table WorkPlan modify(docid varchar2(500))
/
alter table WorkPlan add taskid_1 varchar2(500)
/
update WorkPlan set  taskid_1 = taskid
/
alter table WorkPlan drop column taskid
/
alter table WorkPlan add taskid varchar2(500)
/
update  WorkPlan set  taskid = taskid_1
/
alter table WorkPlan drop column taskid_1
/

Create or replace  Procedure fix_workplan_data
as
	id integer;
	crmid varchar2(500);
	relatedprj varchar2(500);
	relatedcus varchar2(500);
	relatedwf varchar2(500);
	relateddoc varchar2(500);
begin	
	FOR all_cursor in(
	select id,crmid,relatedprj,relatedcus,relatedwf,relateddoc from WorkPlan where (relatedprj is not null or relatedcus is not null or relatedwf is not null or relateddoc is not null) and (relatedprj!='0' and relatedcus!='0' and relatedwf!='0' and relateddoc!='0'))
	loop
		id :=all_cursor.id;
		crmid :=all_cursor.crmid;
		relatedprj :=all_cursor.relatedprj;
		relatedcus :=all_cursor.relatedcus;
		relatedwf :=all_cursor.relatedwf;
		relateddoc :=all_cursor.relateddoc;
		update WorkPlan set taskid=relatedprj,crmid= concat(concat(crmid,','),relatedcus),requestid=relatedwf,docid=relateddoc where id=id;
	end loop;
end;
/
call  fix_workplan_data ()
/

create or replace PROCEDURE WorkPlan_Insert (
	type_n_1  char  ,
	name_1  varchar2   ,
	resourceid_1  varchar2   ,
	begindate_1  char   ,
	begintime_1  char   ,
	enddate_1  char   ,
	endtime_1  char   ,	
	description_1  varchar2    ,
	requestid_1  varchar2   ,
	projectid_1  varchar2   ,
	crmid_1  varchar2   ,
	docid_1  varchar2   ,
	meetingid_1  varchar2   ,	
	status_1  char   ,
	isremind_1 integer  ,
	waketime_1 integer  ,	
	createrid_1 integer   ,
	createdate_1 char   ,
	createtime_1 char ,
	deleted_1 char   ,
	taskid_1 varchar2,
	urgentLevel_1 char,
	agentId_1 integer,
    flag out integer  , 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
 m_id integer;
 m_deptId integer;
 m_subcoId integer;
begin
INSERT INTO WorkPlan (
	type_n ,
	name  ,
	resourceid ,
	begindate ,
	begintime ,
	enddate ,
	endtime  ,
	description ,
	requestid  ,
	projectid ,
	crmid  ,
	docid  ,
	meetingid ,
	status  ,
	isremind  ,
	waketime  ,	
	createrid  ,
	createdate  ,
	createtime ,
	deleted,
	taskid,
	urgentLevel,
	agentId
) VALUES (
	type_n_1 ,
	name_1  ,
	resourceid_1 ,
	begindate_1 ,
	begintime_1 ,
	enddate_1 ,
	endtime_1  ,
	description_1 ,
	requestid_1  ,
	projectid_1 ,
	crmid_1  ,
	docid_1  ,
	meetingid_1 ,
	status_1  ,
	isremind_1  ,
	waketime_1  ,	
	createrid_1  ,
	createdate_1  ,
	createtime_1 ,
	deleted_1,
	taskid_1,
	urgentLevel_1,
	agentId_1
);

SELECT MAX(id) into m_id FROM WorkPlan;
SELECT departmentid, subcompanyid1 INTO m_deptId , m_subcoId  FROM HrmResource WHERE id = 
createrid_1;
UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_id;
open thecursor for 
 select m_id  id  from dual;
end;
/

CREATE or REPLACE PROCEDURE WorkPlan_InsertPlus (
	type_n_1 char,
	name_1 varchar2,
	resourceid_1 varchar2,
	begindate_1 char,
	begintime_1 char,
	enddate_1 char,
	endtime_1 char,
	description_1 varchar2,
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
	flag out integer  , 
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
) 
AS 
 m_id integer;
 m_deptId integer;
 m_subcoId integer;
begin
INSERT INTO WorkPlan (
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
	relateddoc
) VALUES (
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
	relateddoc_1
);
SELECT MAX(id) into m_id  FROM WorkPlan;
SELECT departmentid , subcompanyid1 into m_deptId  , m_subcoId   FROM HrmResource WHERE id = createrid_1;
UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_id;
open thecursor for 
select m_id  id  from dual;
end;
/

create or replace  PROCEDURE WorkPlan_Update (
	id_1 integer,
	type_n_1 char,
	name_1 varchar2,
	resourceid_1 varchar2,
	begindate_1 char,
	begintime_1 char,
	enddate_1 char,
	endtime_1 char,	
	description_1 varchar2,
	requestid_1 varchar2,
	projectid_1 varchar2,
	crmid_1 varchar2,
	docid_1 varchar2,
	meetingid_1 varchar2,	
	isremind_1 integer,
	waketime_1 integer,
	taskid_1 varchar2,
	urgentLevel_1 char,	
	flag out 	integer	, 
    msg out	varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE WorkPlan SET
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
	urgentLevel = urgentLevel_1	
WHERE id = id_1;
end;
/