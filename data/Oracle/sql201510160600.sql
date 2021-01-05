delete from SystemRightDetail where rightid =1912
/
delete from SystemRightsLanguage where id =1912
/
delete from SystemRights where id =1912
/
insert into SystemRights (id,rightdesc,righttype) values (1912,'资产预警设置','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,7,'资产预警设置','资产预警设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,9,'資產預警設定','資產預警設定') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,8,'Asset early warning','Asset early warning') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1912,12,'','') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41912,'资产预警设置','Cpt4Mode:AlarmSettings',1912) 
/