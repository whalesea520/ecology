delete from SystemRights where id =1505
/
delete from SystemRightDetail where rightid =1505
/
delete from SystemRightsLanguage where id =1505
/
insert into SystemRights (id,rightdesc,righttype) values (1505,'��Ч���˻�������','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1505,8,'GP Base Setting','GP Base Setting') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1505,7,'��Ч���˻�������','��Ч���˻�������') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1505,9,'��Ч���˻��A�O��','��Ч���˻��A�O��') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42750,'��Ч���˻�������','GP_BaseSettingMaint',1505) 
/