alter table workflow_agent add backDate char(10)
GO
alter table workflow_agent add backTime char(8)
GO

create table cotype_sharemanager(
	id int IDENTITY(1,1) primary key CLUSTERED,
	cotypeid int,
	sharetype int,
	sharevalue varchar(4000),
	seclevel int,
	rolelevel int
)
GO
create table cotype_sharemembers(
	id int IDENTITY(1,1) primary key CLUSTERED,
	cotypeid int,
	sharetype int,
	sharevalue varchar(4000),
	seclevel int,
	rolelevel int
)
GO

declare @typeid int
declare @fieldLength int
declare @start int
declare @managerid varchar(4000)
declare @members varchar(4000)

declare initcotypes cursor for select id from cowork_types
open initcotypes 
fetch next from initcotypes into @typeid
while @@fetch_status=0
  begin
  
    select @fieldLength=DATALENGTH(managerid) from cowork_types where  id=@typeid
    set @start=0
	while(@fieldLength>0)
		begin
		  if(@fieldLength>4000)
			begin 
			  select @managerid=SUBSTRING(managerid,@start,charindex(',',managerid,@start+3500)-@start+1) from cowork_types where  id=@typeid
			  insert into cotype_sharemanager(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(@typeid,1,','+@managerid,0,0)
			  set @fieldLength=@fieldLength-len(@managerid)
			  set @start=@start+len(@managerid)
			end
		 else
		   begin
		      select @managerid=SUBSTRING(managerid,@start,@fieldLength+1) from cowork_types where  id=@typeid
			  insert into cotype_sharemanager(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(@typeid,1,','+@managerid,0,0)
			  set @fieldLength=0
		   end
		end
	
    select @fieldLength=DATALENGTH(members) from cowork_types where  id=@typeid
    set @start=0
    while(@fieldLength>0)
		begin
		  if(@fieldLength>4000)
			begin 
			  print @start
			  select @members=SUBSTRING(members,@start,charindex(',',members,@start+3500)-@start+1) from cowork_types where  id=@typeid
			  insert into cotype_sharemembers(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(@typeid,1,','+@members,0,0)
			  set @fieldLength=@fieldLength-len(@members)
			  set @start=@start+len(@members)
			end
		 else
		   begin
		      select @members=SUBSTRING(members,@start,@fieldLength+1) from cowork_types where  id=@typeid
			  insert into cotype_sharemembers(cotypeid,sharetype,sharevalue,seclevel,rolelevel) values(@typeid,1,','+@members,0,0)
			  set @fieldLength=0
		   end
		end
    
    fetch next from initcotypes into @typeid
  end
close initcotypes 
deallocate initcotypes
GO