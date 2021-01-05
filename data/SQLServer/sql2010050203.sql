insert into hpNewsTabInfo (eid,tabid,tabTitle,sqlWhere) select id,1,title,strsqlwhere from hpelement where ebaseid ='1' 
GO
alter table extendHpWebCustom add leftmenuid varchar(200)
GO
alter table extendHpWebCustom add leftmenustyleid varchar(200)
GO
