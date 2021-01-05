delete from SystemRightDetail where rightid =1929
/
delete from SystemRightsLanguage where id =1929
/
delete from SystemRights where id =1929
/
insert into SystemRights (id,rightdesc,righttype) values (1929,'云桥微信权限','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,7,'微信群发消息权限','微信群发消息权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,9,'微信群發消息權限','微信群發消息權限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1929,8,'WX_SENDALL_RIGHT','WX_SENDALL_RIGHT') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43150,'微信群发消息权限','WX_SENDALL_RIGHT',1929) 
/
