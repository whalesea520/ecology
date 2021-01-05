/*
    仅到到文档附件
*/
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
  select d2.* from docdetail d1, DocImageFile d2 
    where  d1.id=d2.docid and d2.docid= docid_1 and d1.doctype=1 and d2.docfiletype<>'1'
  order by d2.id, versionId desc
;
end;
/