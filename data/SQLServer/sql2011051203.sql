ALTER TABLE HrmUserSetting   ADD isCoworkHead int
GO
ALTER TABLE HrmUserSetting   ADD skin varchar(100)
GO
ALTER TABLE HrmUserSetting   ADD cutoverWay varchar(100)
GO
ALTER TABLE HrmUserSetting   ADD TransitionTime varchar(100)
GO
ALTER TABLE HrmUserSetting   ADD transitionWay varchar(100)
GO

update HrmUserSetting set isCoworkHead=1
GO

create proc cowork_sys_update
as
declare @coworkid int
declare @discussid int
declare @floorNum int
declare @isnew varchar(8000)
declare @important varchar(8000)
declare @coworkers varchar(8000)
declare @creater int
declare @principal int
declare @splitChar varchar(1)
declare @userid varchar(10)
set @splitChar=','
declare cursor0 cursor for select id,isnew,userids,coworkers,creater,principal from cowork_items
open cursor0                
fetch next from cursor0  into @coworkid,@isnew,@important,@coworkers,@creater,@principal  
while(@@fetch_status=0)     
begin

  
  while(@isnew<>'' and @isnew is not null)
    begin
      set   @userid=left(@isnew,charindex(',',@isnew,1)-1)
      if(@userid<>'')
        begin
          insert into cowork_read(coworkid,userid) values(@coworkid,@userid)
        end
      set   @isnew=stuff(@isnew,1,charindex(',',@isnew,1),'') 
    end
  

  
  while(@coworkers<>'' and @coworkers is not null)
    begin
      if(len(@coworkers)>4000)
        begin 
          insert into coworkshare(sourceid,type,content,seclevel,sharelevel,srcfrom) values(@coworkid,1,left(@coworkers,charindex(',',@coworkers,3500)),0,1,1)
          set @coworkers=stuff(@coworkers,1,charindex(',',@coworkers,3500)-1,'')
        end
     else
       begin
          insert into coworkshare(sourceid,type,content,seclevel,sharelevel,srcfrom) values(@coworkid,1,@coworkers,0,1,1)
          set @coworkers=''
       end
    end
 
  insert into coworkshare (sourceid,type,content,seclevel,sharelevel,srcfrom) values(@coworkid,1,@creater,0,2,2)
  insert into coworkshare (sourceid,type,content,seclevel,sharelevel,srcfrom) values(@coworkid,1,@principal,0,2,3)
  

  
  while(@important<>'' and @important is not null)
    begin
      set   @userid=left(@important,charindex(',',@important,1)-1)
      if(@userid<>'')
        begin
          insert into cowork_important(coworkid,userid) values(@coworkid,@userid)
        end
      set   @important=stuff(@important,1,charindex(',',@important,1),'') 
    end
 

 
  declare cursor1 cursor for select id from cowork_discuss where coworkid=@coworkid order by createdate asc,createtime asc
  open cursor1
  set @floorNum=1
  fetch next from cursor1  into @discussid
  while(@@fetch_status=0)
  begin 
     update cowork_discuss set  floorNum=@floorNum,replayid=0 where id=@discussid
     set @floorNum=@floorNum+1
     fetch next from cursor1 into @discussid 
  end 
  close cursor1
  deallocate cursor1


  fetch next from cursor0 into @coworkid,@isnew,@important,@coworkers,@creater,@principal 
end
close cursor0        
deallocate cursor0
GO

exec cowork_sys_update
GO