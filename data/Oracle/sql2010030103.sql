update docdetail set sumReadCount=sumReadCount-1 where EXISTS ( select docid from docreadtag where readcount=1 and docreadtag.docid=docdetail.id and docreadtag.userid=docdetail.doccreaterid and docreadtag.usertype=docdetail.usertype)
/

update docreadtag set docreadtag.readcount=0 where exists (select id from docdetail where docreadtag.docid=docdetail.id and docreadtag.userid=docdetail.doccreaterid and docreadtag.usertype=docdetail.usertype)
/
