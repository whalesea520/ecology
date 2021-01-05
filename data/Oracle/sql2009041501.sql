delete from HtmlLabelIndex where id=22814 
/
delete from HtmlLabelInfo where indexid=22814 
/
INSERT INTO HtmlLabelIndex values(22814,'请在左侧选择拥有维护权限的分部！') 
/
INSERT INTO HtmlLabelInfo VALUES(22814,'请在左侧选择拥有维护权限的分部！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22814,'Please choose the subCompany of having maintenance right in the left!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22814,'請在左側選擇擁有維護許可權的分部！',9) 
/

delete from HtmlLabelIndex where id=22815 
/
delete from HtmlLabelInfo where indexid=22815 
/
INSERT INTO HtmlLabelIndex values(22815,'该类型不能针对分部设置，请选择其它类型！') 
/
INSERT INTO HtmlLabelInfo VALUES(22815,'该类型不能针对分部设置，请选择其它类型！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22815,'Because of this type can not be set for the subCompany, please choose other type!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22815,'該類型不能針對分部設置，請選擇其他類型！',9) 
/ 

delete from SystemRightDetail  where rightid in(837,838)
/
delete from SystemRightsLanguage  where id in(837,838)
/
delete from SystemRights  where id in(837,838)
/

insert into SystemRights (id,rightdesc,righttype) values (837,'起始编号维护','5') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (837,7,'起始编号维护','起始编号维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (837,8,'Start Code Maintenance','Start Code Maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (837,9,'起始編號維護','起始編號維護') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4352,'起始编号维护','StartCode:Maintenance',837) 
/


insert into SystemRights (id,rightdesc,righttype) values (838,'预留编号维护','5') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (838,9,'預留編號維護','預留編號維護') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (838,7,'预留编号维护','预留编号维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (838,8,'Reserved Code Maintenance','Reserved Code Maintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4353,'预留编号维护','ReservedCode:Maintenance',838) 
/


