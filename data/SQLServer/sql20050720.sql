drop index docReadTag.docReadTag_user_in
GO

 CREATE  INDEX docReadTag_docid_uid_utype ON docReadTag(docid,userid,usertype) 
GO