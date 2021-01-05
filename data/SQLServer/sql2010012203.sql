create  PROCEDURE Share_forcrm_init
(
    @crmid int )
AS 

declare @managerid int
declare @managerstr varchar(2000)
declare @tempmanagerid int
/*删除原来的的默认共享*/
delete  from CRM_ShareInfo where isdefault='1' and relateditemid=@crmid
/*共享给客户经理*/
select @managerid=manager from CRM_CustomerInfo where id=@crmid
if @managerid is not null
begin 
/*insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,sharelevel,crmid,isdefault,userid) values (@crmid,1,0,2,0,1,@managerid)*/
/*共享给所有上级*/
select @managerstr=managerstr+'-1' from hrmresource where id=@managerid
if @managerstr is not null
begin
declare hrmid_cursor cursor for   

select id from hrmresource where charindex(','+convert(varchar(10),id)+',',','+@managerstr+',')>0  and id!=@managerid
open hrmid_cursor 
fetch next from hrmid_cursor into @tempmanagerid
while @@fetch_status=0 
begin
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,sharelevel,crmid,isdefault,userid) values (@crmid,1,0,3,0,1,@tempmanagerid)
fetch next from hrmid_cursor into @tempmanagerid
end 
close hrmid_cursor
deallocate hrmid_cursor	
end
/*共享给客户管理员角色*/
/*insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) values (@crmid,3,0,2,4,8,0,1)*/

end 
go

declare @crmMax int
declare @i int
declare @pagesize int
declare @pagenum int
declare @crmid int
set @i=1
set @pagesize=500
select  @crmMax=max(id) from crm_customerinfo
set @pagenum=@crmMax/@pagesize
if @pagenum=0  set @pagenum=1 
if(@crmMax>@pagenum*@pagesize) set @pagenum = @pagenum+1

WHILE @i<=@pagenum
begin 
	declare initcrmid_cursor cursor for select id from crm_customerinfo where id>=(@i-1)*@pagesize and id<=@i*@pagesize 
	
        open initcrmid_cursor fetch next from initcrmid_cursor into @crmid
	while @@fetch_status=0 
	begin 
		exec Share_forcrm_init @crmid   	
		fetch next from initcrmid_cursor into @crmid
	end 
	close initcrmid_cursor 
	deallocate initcrmid_cursor 

	set @i=@i+1
end  
go

/*共享给客户经理*/
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,sharelevel,crmid,isdefault,userid) select id,1,0,2,0,1,manager from crm_customerinfo
go
/*共享给客户管理员角色*/
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) select id,3,0,0,4,8,0,1 from crm_customerinfo
go
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) select id,3,0,1,4,8,0,1 from crm_customerinfo
go
insert into CRM_ShareInfo (relateditemid,sharetype,seclevel,rolelevel,sharelevel,roleid,crmid,isdefault) select id,3,0,2,4,8,0,1 from crm_customerinfo
go

alter table CRM_ShareInfo add deptorcomid int
GO
update crm_shareinfo set deptorcomid=(select departmentid from hrmresource where id=(select manager from crm_customerinfo where id=relateditemid))  where   sharetype=3 and rolelevel=0
go
update crm_shareinfo set deptorcomid=(select subcompanyid1 from hrmresource where id=(select manager from crm_customerinfo where id=relateditemid))  where   sharetype=3 and rolelevel=1
go

