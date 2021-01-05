alter table imagefiletemppic add docfiletype varchar2(2)
/
update  imagefiletemppic  set docfiletype='1'
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
	Select Count(id)into AccessoryCount From DocImageFile where docid = docid_1 and docfiletype<>'1'  and docfiletype<>'11'  and isextfile='1';
	Update Docdetail set accessorycount= AccessoryCount where id = docid_1;
open thecursor for select filerealpath from ImageFile where imagefileid = imagefileid_2 and imagefileused = 0;
delete ImageFile where imagefileid=imagefileid_2 and imagefileused = 0;
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
    where  d2.docid= docid_1 and d2.docfiletype<>'1'  and d2.docfiletype<>'11' and d2.isextfile = '1'
  order by d2.id, versionId desc;
end;
/