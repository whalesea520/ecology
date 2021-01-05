declare @subid int
declare @hpid int
declare @eid int
declare @count int
declare @all_cursor cursor

set @subid=1
select top 1 @subid=id   from HrmSubCompany order by  supsubcomid,showorder
update hpinfo set subcompanyid=@subid,creatortype=3,creatorid=@subid where id=1 or id=2
update hplayout set usertype=3,userid=@subid where  hpid in (1,2) and usertype=3 and userid=1
update hpElementSettingDetail set userid=@subid,usertype=3 where userid=1 and hpid in(1,2)


SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
select id,hpid from hpelement where hpid=1 or hpid=2
OPEN @all_cursor 
FETCH NEXT FROM @all_cursor INTO @eid,@hpid
WHILE @@FETCH_STATUS = 0
begin
	select @count=count(*) from hpElementSettingDetail where eid=@eid and hpid=@hpid and userid=@subid and usertype=3
	if @count=0 
		insert into hpElementSettingDetail(userid,usertype,eid,perpage,linkmode,showfield,sharelevel,hpid) values(@subid,3,@eid,5,2,'',2,@hpid)
	
FETCH NEXT FROM @all_cursor INTO @eid,@hpid
end 
CLOSE @all_cursor
DEALLOCATE @all_cursor 

GO