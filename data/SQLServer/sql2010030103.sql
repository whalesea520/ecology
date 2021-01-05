update docdetail set sumReadCount=sumReadCount-1 from docreadtag where readcount=1 and docreadtag.docid=docdetail.id and docreadtag.userid=docdetail.doccreaterid and docreadtag.usertype=docdetail.usertype
go

update docreadtag set docreadtag.readcount=0 from docdetail where docreadtag.docid=docdetail.id and docreadtag.userid=docdetail.doccreaterid and docreadtag.usertype=docdetail.usertype
go
