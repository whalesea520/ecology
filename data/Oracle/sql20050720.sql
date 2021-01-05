drop index docReadTag_user_in
/

CREATE  INDEX docReadTag_docid_uid_utype ON docReadTag(docid,userid,usertype) 
/