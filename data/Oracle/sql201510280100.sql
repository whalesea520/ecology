delete from SystemRightDetail where rightid =1923
/
delete from SystemRightsLanguage where id =1923
/
delete from SystemRights where id =1923
/
insert into SystemRights (id,rightdesc,righttype) values (1923,'资产折旧设置','4') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,7,'资产折旧设置','资产折旧设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,9,'資產折舊設定','資產折舊設定') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1923,8,'Depreciation of assets','Depreciation of assets') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41923,'资产折旧设置','Cpt4Mode:DeprecationSettings',1923) 
/