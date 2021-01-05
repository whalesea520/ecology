delete from albumsubcompany a where rowid>(select min(rowid) from albumsubcompany b where a.subcompanyid=b.subcompanyid ) 
/