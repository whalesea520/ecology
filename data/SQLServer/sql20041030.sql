/* For TD1370 */
ALTER  PROCEDURE WorkPlan_Update (
	@id_1 int,
	@type_n_1 char(1),
	@name_1 varchar(100),
	@resourceid_1 varchar(200),
	@begindate_1 char(10),
	@begintime_1 char(8),
	@enddate_1 char(10),
	@endtime_1 char(8),	
	@description_1 text,
	@requestid_1 varchar(100),
	@projectid_1 varchar(100),
	@crmid_1 varchar(100),
	@docid_1 varchar(100),
	@meetingid_1 varchar(100),	
	@isremind_1 int,
	@waketime_1 int,
	@taskid_1 varchar(100),
	@urgentLevel_1 char(1),	
	@flag integer output,
	@msg varchar(80) output)
AS UPDATE WorkPlan SET
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

/*td:1400 首页性能改进 */
update WorkPlan set createrType = '1' 
go

/*把原来从客户联系表中倒过来的由客户创建的那么客户的id是放在agentId字段现转过来都放在resourceid并把createrType改为2*/
CREATE PROCEDURE WorkPlan_AgentForResource 
AS 
DECLARE @m_id int
DECLARE @m_agentid int
DECLARE @m_creatertype char(1)

DECLARE all_cursor CURSOR FOR
SELECT id, agentId FROM WorkPlan where agentId>0
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_id, @m_agentid
WHILE (@@FETCH_STATUS = 0)
BEGIN 

update WorkPlan set resourceid = @m_agentid , createrType = '2' , agentId = 0 where id = @m_id

FETCH NEXT FROM all_cursor INTO @m_id, @m_agentid
END
CLOSE all_cursor 
DEALLOCATE all_cursor
GO

exec WorkPlan_AgentForResource
go

drop PROCEDURE WorkPlan_AgentForResource
go


/*解决联系提醒速度慢*/
ALTER TABLE CRM_ContacterLog_Remind ADD  lastestContactDate char(10) /*最近的联系时间*/
GO


CREATE PROCEDURE CRM_RemindContactDate
AS 
DECLARE @m_customerids varchar(100)
DECLARE @m_begindate char(10)
DECLARE @m_crmid varchar(100)
DECLARE @m_start int
DECLARE @m_len int

DECLARE all_cursor CURSOR FOR
SELECT crmid FROM WorkPlan where type_n = '3' group by crmid 
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_customerids 
WHILE (@@FETCH_STATUS = 0)

BEGIN 

while (@m_customerids<>'') 
begin
    set @m_len = LEN(@m_customerids)
    set @m_start = CHARINDEX(',' , @m_customerids)
    if(@m_start=0)
    begin
        set @m_crmid = @m_customerids
        set @m_customerids = ''
    end
    else
    begin
        set @m_crmid = SUBSTRING(@m_customerids , 0 , @m_start)
        set @m_start = @m_start + 1
        set @m_customerids = SUBSTRING(@m_customerids , @m_start , @m_len)
    end
    select @m_begindate = max(begindate) from WorkPlan WHERE type_n = '3' and (',' + crmid + ',') LIKE '%,' + @m_crmid + ',%'
    update CRM_ContacterLog_Remind set lastestContactDate = @m_begindate where customerid = @m_crmid
end

FETCH NEXT FROM all_cursor INTO @m_customerids

END

CLOSE all_cursor 
DEALLOCATE all_cursor
GO

exec CRM_RemindContactDate
go

drop PROCEDURE CRM_RemindContactDate
go


create TRIGGER Tri_Update_CRMRemindContactDate ON WorkPlan WITH ENCRYPTION
FOR INSERT, UPDATE, DELETE
AS 
DECLARE @m_customerids varchar(100)
DECLARE @m_oldcustomerids varchar(100)
DECLARE @m_begindate char(10)
DECLARE @m_crmid varchar(100)
DECLARE @m_start int
DECLARE @m_len int


select @m_oldcustomerids = crmid from deleted where type_n = '3'
select @m_customerids = crmid from inserted where type_n = '3'

if (@m_oldcustomerids = null) 
begin
    set @m_oldcustomerids = ''
end
if (@m_customerids = null) 
begin
    set @m_customerids = ''
end

while (@m_oldcustomerids<>'') 
begin
    set @m_len = LEN(@m_oldcustomerids)
    set @m_start = CHARINDEX(',' , @m_oldcustomerids)
    if(@m_start=0)
    begin
        set @m_crmid = @m_oldcustomerids
        set @m_oldcustomerids = ''
    end
    else
    begin
        set @m_crmid = SUBSTRING(@m_oldcustomerids , 0 , @m_start)
        set @m_start = @m_start + 1
        set @m_oldcustomerids = SUBSTRING(@m_oldcustomerids , @m_start , @m_len)
    end
    select @m_begindate = max(begindate) from WorkPlan WHERE type_n = '3' and (',' + crmid + ',') LIKE '%,' + @m_crmid + ',%'
    update CRM_ContacterLog_Remind set lastestContactDate = @m_begindate where customerid = @m_crmid
end

while (@m_customerids<>'') 
begin
    set @m_len = LEN(@m_customerids)
    set @m_start = CHARINDEX(',' , @m_customerids)
    if(@m_start=0)
    begin
        set @m_crmid = @m_customerids
        set @m_customerids = ''
    end
    else
    begin
        set @m_crmid = SUBSTRING(@m_customerids , 0 , @m_start)
        set @m_start = @m_start + 1
        set @m_customerids = SUBSTRING(@m_customerids , @m_start , @m_len)
    end
    select @m_begindate = max(begindate) from WorkPlan WHERE type_n = '3' and (',' + crmid + ',') LIKE '%,' + @m_crmid + ',%'
    update CRM_ContacterLog_Remind set lastestContactDate = @m_begindate where customerid = @m_crmid
end
go

/* For TD1412 */
Update Exchange_Info set createrType =  '1'  where createrType is null
go