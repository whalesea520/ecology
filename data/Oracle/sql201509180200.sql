delete from SystemRightDetail where rightid =1907
/
delete from SystemRightsLanguage where id =1907
/
delete from SystemRights where id =1907
/
insert into SystemRights (id,rightdesc,righttype) values (1907,'移动签到情况管理','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,8,'Mobile sign information management','Mobile sign information management') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,7,'移动签到情况管理','移动签到情况管理') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1907,9,'移動簽到情況管理','移動簽到情況管理') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43134,'移动签到情况管理','MobileSignInfo:Manage',1907) 
/