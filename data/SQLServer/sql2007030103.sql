create table AlbumPhotos(
id int,
parentId int,
isFolder char(1),
subFolderCount int,
photoName varchar(100),
photoSize int,
photoPath varchar(200)
)
go

alter table AlbumPhotos add photoDescription varchar(200)
go
insert into sequenceindex select 'albumphotoid',isnull(min(id),0)-1 from AlbumPhotos
go
alter table AlbumPhotos add thumbnailPath varchar(200)
go
alter table AlbumPhotos add photoCount int
go

create table AlbumPhotoReview(
    id int identity,
    photoId int,
    userId int,
    postdate varchar(20),
    content text
)
go

alter table AlbumPhotos add userId int
go
alter table AlbumPhotos add postdate varchar(20)
go
alter table AlbumPhotos add subcompanyId int
go



create table AlbumSubcompany(
subcompanyId int,
albumSize int,
albumSizeUsed int
)
go
insert into AlbumSubcompany select id,1000000,0 from HrmSubcompany
go

create procedure AlbumPhotos_U_Size(
@subcompanyId int
)
as
declare @albumSize int
declare @albumSizeUsed int
select @albumSize=albumSize from AlbumSubcompany where subcompanyId=@subcompanyId
select @albumSizeUsed=SUM(photoSize) from AlbumPhotos where subcompanyId=@subcompanyId
if @albumSizeUsed>@albumSize begin
    update AlbumSubcompany set albumSizeUsed=@albumSize WHERE subcompanyId=@subcompanyId
end
else begin
    update AlbumSubcompany set albumSizeUsed=@albumSizeUsed WHERE subcompanyId=@subcompanyId
end

go


create trigger T_UpdatePhotoCount on AlbumPhotos for insert,delete
as
declare @countdelete int,@countinsert int,@id int,@parentId int,@subcompanyId int,@photoCount int,@isFolder char(1),@photoSize int

select @countdelete=count(*) from deleted
select @countinsert=count(*) from inserted

if @countdelete=0 and @countinsert>0 begin
    select @parentid=parentId,@isFolder=isFolder,@photoSize=photoSize,@subcompanyId=subcompanyId from inserted
    if @isFolder<>'1' begin
        update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId=@parentId and isFolder<>'1') where id=@parentId
        exec AlbumPhotos_U_Size @subcompanyId
    end
end

if @countinsert=0 begin
    select @parentid=parentId,@isFolder=isFolder,@photoSize=photoSize,@subcompanyId=subcompanyId from deleted
    if @isFolder<>'1' begin
        update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId=@parentId and isFolder<>'1') where id=@parentId
        delete from AlbumPhotoReview where photoId=@id
        exec AlbumPhotos_U_Size @subcompanyId
    end
end
go




create PROCEDURE PhotoComments_SelectAll( 
@flag int output, 
@msg varchar(80) output 
)
AS 
SELECT * FROM AlbumPhotoReview SET @flag = 1 SET @msg = 'OK!'

GO


create PROCEDURE AlbumPhotos_SelectAll( 
@flag int output, 
@msg varchar(80) output 
)
AS 
SELECT * FROM AlbumPhotos SET @flag = 1 SET @msg = 'OK!'
GO


create procedure PhotoSequence_Get(
@indexdesc varchar(40),
@flag int output, 
@msg varchar(60) output)
as 
declare @id_1 integer
select @id_1=currentid from SequenceIndex where indexdesc=@indexdesc
update SequenceIndex set currentid = @id_1-1 where indexdesc=@indexdesc
select @id_1
GO

EXECUTE LMConfig_U_ByInfoInsert 1,NULL,29
GO
EXECUTE LMInfo_Insert 199,20162,NULL,NULL,1,NULL,29,9
GO

EXECUTE LMConfig_U_ByInfoInsert 2,199,0
GO
EXECUTE LMInfo_Insert 200,20163,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/album/Frame.jsp',2,199,0,9 
GO

EXECUTE LMConfig_U_ByInfoInsert 2,199,1
GO
EXECUTE LMInfo_Insert 201,20164,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/album/PhotoSearch.jsp',2,199,1,9 
GO

alter table albumphotos add ordernum int
go
update albumphotos set ordernum=0
go

EXECUTE LMConfig_U_ByInfoInsert 2,199,2
GO
EXECUTE LMInfo_Insert 208,20207,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/album/AlbumSubcompanyAll.jsp',2,199,2,9 
GO

create trigger T_AlbumSubcompanyIns on HrmSubcompany for insert,delete
as
declare @countdelete int,@countinsert int,@id int

select @countdelete=count(*) from deleted
select @countinsert=count(*) from inserted

if @countdelete=0 and @countinsert>0 begin
    select @id=id from inserted
	insert into AlbumSubcompany (subcompanyId,albumSize,albumSizeUsed) values (@id,1000000,0)
end

if @countinsert=0 begin
    select @id=id from deleted
	delete from AlbumSubcompany where subcompanyId=@id
end

go


alter PROCEDURE AlbumPhotos_SelectAll( 
@flag int output, 
@msg varchar(80) output 
)
AS 
SELECT * FROM AlbumPhotos ORDER BY orderNum DESC SET @flag = 1 SET @msg = 'OK!'
GO