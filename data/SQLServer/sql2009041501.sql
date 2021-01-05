delete from HtmlLabelIndex where id=22814 
GO
delete from HtmlLabelInfo where indexid=22814 
GO
INSERT INTO HtmlLabelIndex values(22814,'请在左侧选择拥有维护权限的分部！') 
GO
INSERT INTO HtmlLabelInfo VALUES(22814,'请在左侧选择拥有维护权限的分部！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22814,'Please choose the subCompany of having maintenance right in the left!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22814,'請在左側選擇擁有維護許可權的分部！',9) 
GO

delete from HtmlLabelIndex where id=22815 
GO
delete from HtmlLabelInfo where indexid=22815 
GO
INSERT INTO HtmlLabelIndex values(22815,'该类型不能针对分部设置，请选择其它类型！') 
GO
INSERT INTO HtmlLabelInfo VALUES(22815,'该类型不能针对分部设置，请选择其它类型！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22815,'Because of this type can not be set for the subCompany, please choose other type!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22815,'該類型不能針對分部設置，請選擇其他類型！',9) 
GO 

delete from SystemRightDetail  where rightid in(837,838)
GO
delete from SystemRightsLanguage  where id in(837,838)
GO
delete from SystemRights  where id in(837,838)
GO

insert into SystemRights (id,rightdesc,righttype) values (837,'起始编号维护','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (837,7,'起始编号维护','起始编号维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (837,8,'Start Code Maintenance','Start Code Maintenance') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (837,9,'起始編號維護','起始編號維護') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4352,'起始编号维护','StartCode:Maintenance',837) 
GO


insert into SystemRights (id,rightdesc,righttype) values (838,'预留编号维护','5') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (838,9,'預留編號維護','預留編號維護') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (838,7,'预留编号维护','预留编号维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (838,8,'Reserved Code Maintenance','Reserved Code Maintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4353,'预留编号维护','ReservedCode:Maintenance',838) 
GO



