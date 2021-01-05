if object_id('F_split') is not null
drop FUNCTION F_split
go
create FUNCTION F_split(@ids   VARCHAR(2000),@split VARCHAR(2)) 
returns @t_split TABLE(col INT) AS BEGIN WHILE( Charindex(@split, @ids) <> 0 ) 
BEGIN INSERT @t_split (col) VALUES(Substring(@ids, 1, Charindex(@split, @ids) - 1)) 
SET @ids=Stuff(@ids, 1, Charindex(@split, @ids), '') END INSERT @t_split (col) VALUES(@ids) 
RETURN END
go

if object_ID('Tri_Update_bill_HrmTime') is not null
    Drop trigger Tri_Update_bill_HrmTime
Go


CREATE TRIGGER [Tri_Update_bill_HrmTime] ON Prj_TaskProcess 
FOR UPDATE
AS
Declare @prjid int,
 	@taskid int,
 	@subject varchar(80),
 	@version	int,
 	@isactived	int,
 	@begindate	char(10),
 	@enddate	char(10),
 	@resourceid	char(4000),
	@hrmid		char(10) ,
 	@tmpcount	int,
 	@tmpbegindate   char(10),
 	@tmpenddate char(10),
 	@tmpresourceid  int,
	@all_cursor cursor,
	@resourceids cursor,
	@detail_cursor cursor
if update(isactived)
begin
	select distinct @prjid=prjid from deleted 
	delete from bill_hrmtime where requestid=@prjid and basictype=1 and detailtype=1
	select @subject=name from prj_projectinfo where id=@prjid
	
	SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR
	select distinct hrmid from inserted where isactived=2 and (begindate !='x' or enddate !='-') and isdelete<>1
	OPEN @all_cursor 
	FETCH NEXT FROM @all_cursor INTO @resourceid
	WHILE @@FETCH_STATUS = 0
	begin
	set @resourceids =  CURSOR FORWARD_ONLY STATIC FOR
	select col as value from F_split(@resourceid,',')
	open @resourceids
	FETCH NEXT FROM @resourceids INTO @hrmid
	WHILE @@FETCH_STATUS = 0
		begin
	print @hrmid    
	    set @tmpbegindate=''
	    set @tmpenddate=''
		SET @detail_cursor = CURSOR FORWARD_ONLY STATIC FOR
		select prjid,begindate,enddate from inserted 
	    where isactived=2 and (begindate !='x' or enddate !='-') and isdelete<>1 and hrmid = @hrmid
		OPEN @detail_cursor 
	    FETCH NEXT FROM @detail_cursor INTO @prjid,@begindate,@enddate
		WHILE @@FETCH_STATUS = 0
		begin
		    if @begindate='x'   set @begindate=@enddate
		    if @enddate='-'   set @enddate=@begindate
		    if  @tmpbegindate=''    set @tmpbegindate=@begindate
		    else if  @begindate<@tmpbegindate    set @tmpbegindate=@begindate
		    if  @tmpenddate=''  set @tmpenddate=@enddate
		    else if  @enddate>@tmpenddate    set @tmpenddate=@enddate
		    
		    FETCH NEXT FROM @detail_cursor INTO @prjid,@begindate,@enddate
		end
		CLOSE @detail_cursor
	    DEALLOCATE @detail_cursor 
	    insert into bill_hrmtime (resourceid,basictype,detailtype,requestid,name,begindate,enddate,status,accepterid)
		values (@hrmid,1,1,@prjid,@subject,@tmpbegindate,@tmpenddate,'0',convert(varchar(2000),@hrmid))  
		
		FETCH NEXT FROM @resourceids INTO @hrmid
		end
		CLOSE @resourceids
		DEALLOCATE @resourceids 
	FETCH NEXT FROM @all_cursor INTO @resourceid	
	end 
	CLOSE @all_cursor
	DEALLOCATE @all_cursor 
end
go