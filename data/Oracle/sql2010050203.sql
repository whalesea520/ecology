insert into hpNewsTabInfo (eid,tabid,tabTitle,sqlWhere) select id,1,title,strsqlwhere from hpelement where ebaseid ='1' 
/
alter table extendHpWebCustom add leftmenuid varchar2(200)
/
alter table extendHpWebCustom add leftmenustyleid varchar2(200)
/
