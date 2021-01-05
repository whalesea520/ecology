insert into expandBaseRightInfo (modeid, expandid, righttype, relatedid, showlevel, modifytime) 
select modeid, id, 5, 0, 10, convert(varchar(10),getdate(),120) from mode_pageexpand where issystemflag='110'
go