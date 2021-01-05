delete from SystemRightDetail where rightid =536
/
delete from SystemRightsLanguage where id =536
/
delete from SystemRights where id =536
/
insert into SystemRights (id,rightdesc,righttype) values (536,'产品列表','1') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (536,8,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (536,7,'产品列表','产品列表页面权限') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4036,'产品列表','ProductList:View',536) 
/