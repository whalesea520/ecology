delete from SystemRights where id=800
/
insert into SystemRights (id,rightdesc,righttype) values (800,'文档弹出窗口设置权限','1') 
/
delete from SystemRightsLanguage where id=800
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,7,'文档弹出窗口设置权限','文档弹出窗口设置权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,9,'文档弹出窗口设置权限','文档弹出窗口设置权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (800,8,'Pop-up document setting authority','Pop-up document setting authority') 
/
delete from SystemRightDetail where id=4310
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4310,'文档弹出窗口设置权限','Docs:SetPopUp',800) 
/

