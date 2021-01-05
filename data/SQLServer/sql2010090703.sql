create PROCEDURE CRM_ShareByHrm_WorkPlan_new1 (@m_workid int)
AS 
DECLARE  @stype int,@seclevel int ,@userid int ,@department int,@sql varchar(8000),@crmids  varchar(1000),@crmid varchar(10)
set @sql='where  1=2 '

select @crmids=crmid from workplan where type_n='3' and id=@m_workid

if @crmids is not null  
begin
delete from WorkPlanShareDetail where  workid=@m_workid and sharelevel=0 

WHILE (CHARINDEX(',',@crmids) > 0 )
begin

set @crmid=substring(@crmids,1,CHARINDEX(',',@crmids)-1)
set @crmids=substring(@crmids,CHARINDEX(',',@crmids)+1,len(@crmids))
if convert(int,@crmid)>0 
begin

DECLARE all_cursorcrm CURSOR FOR
SELECT sharetype,seclevel,userid,departmentid FROM crm_shareinfo WHERE  relateditemid=convert(int,@crmid)
OPEN all_cursorcrm 
FETCH NEXT FROM all_cursorcrm INTO @stype,@seclevel,@userid,@department

WHILE (@@FETCH_STATUS = 0)
BEGIN 
if @stype=1 set @sql=@sql+' or (id='+convert(varchar,@userid)+')'
if @stype=2  set @sql=@sql+' or (departmentid='+convert(varchar,@department)+' and  seclevel<='+convert(varchar,@seclevel)+')'
if @stype=4 set @sql=@sql+' or (seclevel<='+convert(varchar,@seclevel)+')'
FETCH NEXT FROM all_cursorcrm INTO @stype,@seclevel,@userid,@department
END
CLOSE all_cursorcrm 
DEALLOCATE all_cursorcrm

end
end


if (CHARINDEX(',',@crmids) <= 0 ) 
begin
set @crmid=@crmids

if convert(int,@crmid)>0 
begin
DECLARE all_cursorcrm CURSOR FOR
SELECT sharetype,seclevel,userid,departmentid FROM crm_shareinfo WHERE  relateditemid=convert(int,@crmid)
OPEN all_cursorcrm 
FETCH NEXT FROM all_cursorcrm INTO @stype,@seclevel,@userid,@department

WHILE (@@FETCH_STATUS = 0)
BEGIN 
if @stype=1 set @sql=@sql+' or (id='+convert(varchar,@userid)+')'
if @stype=2  set @sql=@sql+' or (departmentid='+convert(varchar,@department)+' and  seclevel<='+convert(varchar,@seclevel)+')'
if @stype=4 set @sql=@sql+' or (seclevel<='+convert(varchar,@seclevel)+')'
FETCH NEXT FROM all_cursorcrm INTO @stype,@seclevel,@userid,@department
END
CLOSE all_cursorcrm 
DEALLOCATE all_cursorcrm

end
end 

set @sql='insert into workplansharedetail (workid,userid,usertype,sharelevel) select '+convert(varchar,@m_workid)+', id,1,0 from hrmresource  '+@sql+' union select '+convert(varchar,@m_workid)+',resourceid,1,0 from hrmrolemembers where roleid=8 '
execute (@sql)

end


go








declare @docMax int
declare @i int
declare @pagesize int
declare @pagenum int
declare @planid int
set @i=1
set @pagesize=1000
select  @docMax=MAX(id) from WorkPlan 
set @pagenum=@docMax/@pagesize+1
if @pagenum=0  set @pagenum=1 

WHILE @i<=@pagenum
begin 
	declare initplan_cursor cursor for select id from workplan where id>=(@i-1)*@pagesize and id<@i*@pagesize 
	
        open initplan_cursor fetch next from initplan_cursor into @planid
	while @@fetch_status=0 
	begin 
		exec CRM_ShareByHrm_WorkPlan_new1 @planid   	
		fetch next from initplan_cursor into @planid
	end 
	close initplan_cursor 
	deallocate initplan_cursor 

	set @i=@i+1
end  

go

drop PROCEDURE CRM_ShareByHrm_WorkPlan_new1
go