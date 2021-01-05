alter table docimagefile add isextfile char(1) default '1' null
/
update docimagefile set isextfile=1
/
update docimagefile set isextfile=0 where docid in (select id as docid from docdetail where doctype <> 1)
/

create or replace  PROCEDURE DocImageFile_DByDocfileid
	(docid_1 	integer ,
     imagefileid_2 	integer ,
 flag  out integer, 
 msg out varchar2 ,
 thecursor IN OUT cursor_define.weavercursor)
AS
AccessoryCount integer;
begin
delete from DocImageFile where imagefileid=imagefileid_2 and docid=docid_1;
update ImageFile set imagefileused=imagefileused-1 where imagefileid = imagefileid_2;


	Select Count(id)into AccessoryCount From DocImageFile where docid = docid_1 and docfiletype<>'1' and isextfile='1';
	Update Docdetail set accessorycount= AccessoryCount where id = docid_1;

open thecursor for select filerealpath from ImageFile where imagefileid = imagefileid_2 and imagefileused = 0;
delete ImageFile where imagefileid=imagefileid_2 and imagefileused = 0;
end;
/

CREATE OR REPLACE PROCEDURE DocImageFile_DByDocid
	(docid_1 	integer ,
    flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
imagefileid_2 integer;
begin
for imagefileid_cursor in(select imagefileid from DocImageFile where docid=docid_1 and isextfile = '1')
loop
    imagefileid_2 := imagefileid_cursor.imagefileid;
    update ImageFile set imagefileused=imagefileused-1 where imagefileid = imagefileid_2  ;
end loop;

delete from DocImageFile where docid=docid_1;
open thecursor for
select filerealpath from ImageFile where imagefileused = 0 ;
delete ImageFile where imagefileused = 0;
end;
/

CREATE or REPLACE PROCEDURE DocImageFile_Insert
(docid_1 integer,
imagefileid_2 integer,
imagefilename_3 Varchar2,
imagefiledesc_4 Varchar2,
imagefilewidth_5 integer,imagefileheight_6 integer,
imagefielsize_7 integer,docfiletype_8 char,versionId_9 integer,
versionDetail_10 Varchar2,docImageId_11 integer,isextfile_12 varchar2,
flag out integer,msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
INSERT INTO DocImageFile ( docid, imagefileid, imagefilename, 
imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, 
docfiletype,versionId,versionDetail,id, isextfile)  VALUES 
( docid_1, imagefileid_2, imagefilename_3, imagefiledesc_4, 
imagefilewidth_5, imagefileheight_6, imagefielsize_7, 
docfiletype_8,versionId_9,versionDetail_10,docImageId_11, isextfile_12);
end;
/

create or replace PROCEDURE DocImageFile_SelectByDocid 
 (
docid_1   integer, 
 flag out 	integer	, 
 msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
 AS
 begin  
  open thecursor for 
  select d2.* from DocImageFile d2 
    where  d2.docid= docid_1 and d2.docfiletype<>'1' and d2.isextfile = '1'
  order by d2.id, versionId desc
;
end;
/
