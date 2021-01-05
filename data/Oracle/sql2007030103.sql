create table AlbumPhotos(
id integer,
parentId integer,
isFolder char(1),
subFolderCount integer,
photoName varchar2(100),
photoSize integer,
photoPath varchar2(200)
)
/

alter table AlbumPhotos add photoDescription varchar2(200)
/
insert into sequenceindex select 'albumphotoid',nvl(min(id),0)-1 from AlbumPhotos
/
alter table AlbumPhotos add thumbnailPath varchar2(200)
/
alter table AlbumPhotos add photoCount integer
/

create table AlbumPhotoReview(
    id integer ,
    photoId integer,
    userId integer,
    postdate varchar2(20),
    content clob
)
/

create sequence  AlbumPhotoReview_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger AlbumPhotoReview_trigger		
	before insert on AlbumPhotoReview
	for each row
	begin
	select AlbumPhotoReview_id.nextval into :new.id from dual;
	end ;
/



alter table AlbumPhotos add userId integer
/
alter table AlbumPhotos add postdate varchar2(20)
/
alter table AlbumPhotos add subcompanyId integer
/



create table AlbumSubcompany(
subcompanyId integer,
albumSize integer,
albumSizeUsed integer
)
/
insert into AlbumSubcompany select id,1000000,0 from HrmSubcompany
/

create or replace procedure AlbumPhotos_U_Size(
subcompanyId_1 integer
)
as
 albumSize_1 integer;
 albumSizeUsed_1 integer;
 begin
select albumSize into albumSize_1  from AlbumSubcompany where subcompanyId=subcompanyId_1;
select SUM(photoSize) into albumSizeUsed_1 from AlbumPhotos where subcompanyId=subcompanyId_1;
if albumSizeUsed_1>albumSize_1 then 
    update AlbumSubcompany set albumSizeUsed=albumSize_1 WHERE subcompanyId=subcompanyId_1;
else 
    update AlbumSubcompany set albumSizeUsed=albumSizeUsed_1 WHERE subcompanyId=subcompanyId_1;
end if;
end;

/


create or replace trigger T_UpdatePhotoCount
after insert  or delete 
on AlbumPhotos 
FOR each row
Declare
 countdelete_1 integer;
 countinsert_1 integer;
 id_1          integer;
 parentId_1    integer;
 subcompanyId_1  integer;
 photoCount_1    integer;
 isFolder_1      char(1);
 photoSize_1     integer;

begin

countdelete_1 := :old.id ;
countinsert_1 := :new.id ; 


if countdelete_1=0 and countinsert_1>0  then 

parentid_1 := :new.parentId ;
isFolder_1 := :new.isFolder ;
photoSize_1 := :new.photoSize ;
subcompanyId_1 := :new.subcompanyId ;
end if;

if isFolder_1<>'1' then
        update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId=parentId_1 and isFolder<>'1') where id=parentId_1;
         AlbumPhotos_U_Size (subcompanyId_1);
    
end if;

if countinsert_1=0  then
	   
     parentid_1 := :old.parentId ;
     isFolder_1 := :old.isFolder ;
     photoSize_1 := :old.photoSize ;
     subcompanyId_1 := :old.subcompanyId ;

end if;


    if isFolder_1<>'1' then
        update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId=parentId_1 and isFolder<>'1') where id=parentId_1;
        delete from AlbumPhotoReview where photoId=id_1;
        AlbumPhotos_U_Size (subcompanyId_1);
    
end if;

end;
/




create or replace PROCEDURE PhotoComments_SelectAll( 
flag out integer , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin
open thecursor for 
SELECT * FROM AlbumPhotoReview ;
end;
/


create or replace PROCEDURE AlbumPhotos_SelectAll( 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin
 open thecursor for 
SELECT * FROM AlbumPhotos ;
end;
/


create or replace procedure PhotoSequence_Get(
indexdesc_1 varchar2,
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
 id_1 integer;
 begin

select currentid into id_1 from SequenceIndex where indexdesc=indexdesc_1;
update SequenceIndex set currentid = id_1-1 where indexdesc=indexdesc_1;
open thecursor for 
select id_1 from dual;
end;
/

CALL LMConfig_U_ByInfoInsert (1,NULL,29)
/
CALL LMInfo_Insert (199,20162,NULL,NULL,1,NULL,29,9)
/

CALL LMConfig_U_ByInfoInsert (2,199,0)
/
CALL LMInfo_Insert (200,20163,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/album/Frame.jsp',2,199,0,9)
/

CALL LMConfig_U_ByInfoInsert (2,199,1)
/
CALL LMInfo_Insert (201,20164,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/album/PhotoSearch.jsp',2,199,1,9) 
/

alter table albumphotos add ordernum integer
/
update albumphotos set ordernum=0
/

CALL LMConfig_U_ByInfoInsert (2,199,2)
/
CALL LMInfo_Insert (208,20207,'/images_face/ecologyFace_2/LeftMenuIcon/level3.gif','/album/AlbumSubcompanyAll.jsp',2,199,2,9) 
/

create or replace trigger T_AlbumSubcompanyIns 
after insert  or delete
on HrmSubcompany
FOR each row
Declare

countdelete_1 integer;
countinsert_1 integer;
id_1 integer;

begin

countdelete_1 := :old.id ;
countinsert_1 := :new.id ; 

if countdelete_1=0 and countinsert_1>0 then 
     id_1 := :new.id ;
	insert into AlbumSubcompany (subcompanyId,albumSize,albumSizeUsed) values (id_1,1000000,0);
end if;

if countinsert_1=0 then
     id_1 := :old.id ;
	delete from AlbumSubcompany where subcompanyId=id_1;
end if;


end;
/


CREATE OR REPLACE PROCEDURE AlbumPhotos_SelectAll( 
flag  out integer, 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)

AS
begin
open thecursor for 
SELECT * FROM AlbumPhotos ORDER BY orderNum DESC ;
end;
/