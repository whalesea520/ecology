/*
    仅到到文档附件
*/
Alter PROCEDURE DocImageFile_SelectByDocid 
 (
 @docid_1   int, 
 @flag int output, 
 @msg varchar(80) output
 ) 
  AS   
  select d2.* from docdetail d1, DocImageFile d2 
  where  d1.id=d2.docid and d2.docid= @docid_1 and d1.doctype=1 and d2.docfiletype<>'1'
  order by d2.id, versionId desc
GO
