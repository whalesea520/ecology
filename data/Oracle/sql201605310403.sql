insert into expandBaseRightInfo (modeid, expandid, righttype, relatedid, showlevel, modifytime) 
select modeid, id, 5, 0, 10, to_char(sysdate,'yyyy-mm-dd') from mode_pageexpand where issystemflag='110'
/