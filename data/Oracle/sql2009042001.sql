delete from SystemRights where id =840
/
delete from SystemRightsLanguage where id =840
/
delete from SystemRightDetail where id =4355
/

insert into SystemRights (id,rightdesc,righttype) values (840,'会议取消权限','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (840,7,'会议取消权限','会议取消权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (840,9,'會議取消權限','會議取消權限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (840,8,'Canceled permissions','Canceled permissions') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4355,'会议取消权限','Canceledpermissions:Edit',840) 
/