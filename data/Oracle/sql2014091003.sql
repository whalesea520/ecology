delete from mode_batchSet where expandid in(select MAX(id) from mode_pageexpand a where a.issystemflag=104 group by modeid having COUNT(modeid)=2)
/
delete from mode_pageexpand where id in (select MAX(id) from mode_pageexpand a where a.issystemflag=104 group by modeid having COUNT(modeid)=2)
/
delete from mode_pageexpandtemplate where id in(select MAX(id) from mode_pageexpandtemplate group by issystemflag having COUNT(issystemflag)=2)
/