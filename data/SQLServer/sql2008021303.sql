alter table DocSubCategory add suborder float default 0
go
update DocSubCategory set suborder = 0
go
alter table DocSecCategory add secorder float default 0
go
update DocSecCategory set secorder = 0
go
ALTER TABLE DocMainCategory Drop CONSTRAINT DF__DocMainCa__categ__1ED998B2
go
alter table DocMainCategory alter column categoryorder float
go
ALTER TABLE [DocMainCategory] WITH NOCHECK ADD 
	CONSTRAINT [DF__DocMainCa__categ__1ED998B2] DEFAULT (0) FOR [categoryorder]
GO


ALTER PROCEDURE Doc_GetPermittedCategory(@userid_1 int, @usertype_1 int, @seclevel_1 int, @operationcode_1 int, @flag integer output , @msg varchar(80) output) as 

create table #temp(categoryid int, categorytype int, superdirid int, superdirtype int, categoryname varchar(200), orderid int)

declare @secdirid_1 int
declare @secdirname_1 varchar(200)
declare @subdirid_1 int, @subdirid1_1 int, @superdirid_1 int, @superdirtype_1 int, @maindirid_1 int
declare @subdirname_1 varchar(200)
declare @count_1 int
declare @orderid_1 int

if @usertype_1 = 0 begin
    if @operationcode_1 = 0 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdoc>0)
    end
    else if @operationcode_1 = 1 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and createdir>0)
    end
    else if @operationcode_1 = 2 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and movedoc>0)
    end
    else if @operationcode_1 = 3 begin
        declare secdir_cursor cursor for
        select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid from DirAccessPermission where userid=@userid_1 and usertype=@usertype_1 and dirtype=2 and copydoc>0)
    end
end
else begin
    declare secdir_cursor cursor for
    select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=@operationcode_1 and ((permissiontype=3 and seclevel<=@seclevel_1) or (permissiontype=4 and usertype=@usertype_1 and seclevel<=@seclevel_1)))
end

open secdir_cursor
fetch next from secdir_cursor
into @secdirid_1, @secdirname_1, @subdirid_1,@orderid_1

while @@fetch_status = 0 begin
    insert into #temp values(@secdirid_1, 2, @subdirid_1, 1, @secdirname_1, @orderid_1)

    if @subdirid_1 is null set @subdirid_1 = -1
    if @subdirid_1 = 0 set @subdirid_1 = -1
    
    while @subdirid_1 <> -1 begin
        select @subdirid1_1=subcategoryid,@subdirname_1=categoryname,@superdirid_1=subcategoryid,@maindirid_1=maincategoryid,@orderid_1=suborder from DocSubCategory where id = @subdirid_1
        if @superdirid_1 = -1 begin
            set @superdirid_1 = @maindirid_1
            set @superdirtype_1 = 0
        end
        else begin
            set @superdirtype_1 = 1
        end
        set @count_1 = 0
        select @count_1=count(categoryid) from #temp where categoryid = @subdirid_1 and categorytype = 1
        if @count_1 <= 0
            insert into #temp values(@subdirid_1, 1, @superdirid_1, @superdirtype_1, @subdirname_1, @orderid_1)
        set @subdirid_1 = @subdirid1_1
    end
    
    fetch next from secdir_cursor
    into @secdirid_1, @secdirname_1, @subdirid_1, @orderid_1
end
close secdir_cursor
deallocate secdir_cursor

declare maindir_cursor cursor for
select id, categoryname, categoryorder from DocMainCategory where id in (select distinct superdirid from #temp where superdirtype = 0)

open maindir_cursor

fetch next from maindir_cursor
into @subdirid_1, @subdirname_1, @orderid_1

while @@fetch_status = 0 begin
    insert into #temp values(@subdirid_1, 0, -1, -1, @subdirname_1, @orderid_1)
    fetch next from maindir_cursor
    into @subdirid_1, @subdirname_1, @orderid_1
end
close maindir_cursor
deallocate maindir_cursor

select * from #temp order by orderid,categoryid

GO
