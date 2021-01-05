delete from DocSubscribe where not exists(select 1 from DocDetail where id=DocSubscribe.docid)
/