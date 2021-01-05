alter table WorkPlan alter column requestid varchar(500)
GO
alter table WorkPlan alter column projectid varchar(500)
GO
alter table WorkPlan alter column crmid varchar(500)
GO
alter table WorkPlan alter column docid varchar(500)
GO
alter table WorkPlan alter column taskid varchar(500)
GO

Create Procedure fix_workplan_data
as
	Declare
	@id int,
	@crmid varchar(500),
	@relatedprj varchar(500),
	@relatedcus varchar(500),
	@relatedwf varchar(500),
	@relateddoc varchar(500),
	@all_cursor cursor
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select id,crmid,relatedprj,relatedcus,relatedwf,relateddoc from WorkPlan where (relatedprj!='' or relatedcus!='' or relatedwf!='' or relateddoc!='') and (relatedprj!='0' and relatedcus!='0' and relatedwf!='0' and relateddoc!='0')
	OPEN @all_cursor
	FETCH NEXT FROM @all_cursor INTO @id,@crmid,@relatedprj,@relatedcus,@relatedwf,@relateddoc
	WHILE @@FETCH_STATUS = 0
	begin
		update WorkPlan set taskid=@relatedprj,crmid=@crmid+','+@relatedcus,requestid=@relatedwf,docid=@relateddoc where id=@id
		FETCH NEXT FROM @all_cursor INTO @id,@crmid,@relatedprj,@relatedcus,@relatedwf,@relateddoc
	end
	CLOSE @all_cursor
	DEALLOCATE @all_cursor  
GO

fix_workplan_data

go


alter PROCEDURE WorkPlan_Insert (
	@type_n_1  [char] (1)   ,
	@name_1  [varchar] (100)   ,
	@resourceid_1  [varchar] (200)   ,
	@begindate_1  [char] (10)   ,
	@begintime_1  [char] (8)   ,
	@enddate_1  [char] (10)   ,
	@endtime_1  [char] (8)   ,	
	@description_1  [text]    ,
	@requestid_1  [varchar] (500)   ,
	@projectid_1  [varchar] (500)   ,
	@crmid_1  [varchar] (500)   ,
	@docid_1  [varchar] (500)   ,
	@meetingid_1  [varchar] (100)   ,	
	@status_1  [char] (1)   ,
	@isremind_1 [int]  ,
	@waketime_1 [int]   ,	
	@createrid_1 [int]   ,
	@createdate_1 [char] (10)   ,
	@createtime_1 [char] (8) ,
	@deleted_1 [char] (1)   ,
	@taskid_1 [varchar] (500),
	@urgentLevel_1 [char] (1),
	@agentId_1 [int],
	@flag integer output,
	@msg varchar(80) output)
AS INSERT INTO [WorkPlan] (
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
	@type_n_1 ,
	@name_1  ,
	@resourceid_1 ,
	@begindate_1 ,
	@begintime_1 ,
	@enddate_1 ,
	@endtime_1  ,
	@description_1 ,
	@requestid_1  ,
	@projectid_1 ,
	@crmid_1  ,
	@docid_1  ,
	@meetingid_1 ,
	@status_1  ,
	@isremind_1  ,
	@waketime_1  ,	
	@createrid_1  ,
	@createdate_1  ,
	@createtime_1 ,
	@deleted_1,
	@taskid_1,
	@urgentLevel_1,
	@agentId_1
)

DECLARE @m_id int
DECLARE @m_deptId int
DECLARE @m_subcoId int

SELECT @m_id = MAX(id) FROM WorkPlan
SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @createrid_1
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_id
SELECT @m_id AS id

GO

alter PROCEDURE WorkPlan_InsertPlus (
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
	@flag integer output,
	@msg varchar(80) output)
AS INSERT INTO WorkPlan (
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
	@relateddoc_1
)
DECLARE @m_id int 
DECLARE @m_deptId int 
DECLARE @m_subcoId int  
SELECT @m_id = MAX(id) FROM WorkPlan SELECT @m_deptId = departmentid, @m_subcoId = subcompanyid1 FROM HrmResource WHERE id = @createrid_1 
UPDATE WorkPlan SET deptId = @m_deptId, subcompanyId = @m_subcoId where id = @m_id SELECT @m_id AS id

GO

alter  PROCEDURE WorkPlan_Update(
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
@flag integer output,
@msg varchar(80) output
) AS UPDATE WorkPlan SET
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
urgentLevel = @urgentLevel_1 
WHERE id = @id_1
GO
