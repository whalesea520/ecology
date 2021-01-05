delete from hpelementsetting where name='searchid' and eid in (select id from hpElement where ebaseid='FormModeCustomSearch')
go
create procedure hpe_searchid   
as
 begin
    declare hpidCursor cursor    
        for select id from hpElement where ebaseid='FormModeCustomSearch'     
     open hpidCursor; 
    declare @hpid varchar(20); 
       fetch next from hpidCursor into @hpid;
     while @@fetch_status=0    
        begin
		declare @maxid int;
		select @maxid=count(*) from hpElementSetting;
        insert into hpElementSetting(id,eid,name)values(@maxid,@hpid,'searchid');
         fetch next from hpidCursor into @hpid
        end;
     close hpidCursor;    
     deallocate hpidCursor;    
end
go
exec hpe_searchid
go
drop procedure hpe_searchid
go

insert into formmodeelement(eid,searchtitle,disorder,isshowunread) 
	select id,title,0,0 from hpElement where ebaseid='FormModeCustomSearch'
go
update hpelementsetting set value=(select top 1 id from formmodeelement f where hpelementsetting.eid=f.eid ) where name='searchid'
go
update formmodeelement set reportid=(select top 1 value from hpelementsetting where formmodeelement.eid=hpelementsetting.eid and name='reportId' and value is not null )
go
update formmodeelement set fields=(select top 1 value from hpelementsetting where formmodeelement.eid=hpelementsetting.eid and name='fields' and value is not null )
go
update formmodeelement set fieldsWidth=(select top 1 value from hpelementsetting where formmodeelement.eid=hpelementsetting.eid and name='fieldsWidth' and value is not null )
go