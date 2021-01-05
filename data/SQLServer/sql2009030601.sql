delete from HtmlLabelIndex where id=22482 
GO
delete from HtmlLabelInfo where indexid=22482 
GO
INSERT INTO HtmlLabelIndex values(22482,'手机号码') 
GO
INSERT INTO HtmlLabelInfo VALUES(22482,'手机号码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22482,'Mobile',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22482,'手機號碼',9) 
GO

delete from HtmlLabelIndex where id=22483 
GO
delete from HtmlLabelInfo where indexid=22483 
GO
INSERT INTO HtmlLabelIndex values(22483,'人员生日提醒列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(22483,'人员生日提醒列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22483,'Birthday reminder list of staff',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22483,'人員生日提醒列表',9) 
GO

delete from HtmlLabelIndex where id=22484 
GO
delete from HtmlLabelInfo where indexid=22484 
GO
INSERT INTO HtmlLabelIndex values(22484,'客户生日提醒列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(22484,'客户生日提醒列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22484,'Customer birthday reminder list',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22484,'客戶生日提醒列表',9) 
GO

delete from HtmlLabelIndex where id=22488 
GO
delete from HtmlLabelInfo where indexid=22488 
GO
INSERT INTO HtmlLabelIndex values(22488,'明天') 
GO
INSERT INTO HtmlLabelInfo VALUES(22488,'明天',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22488,'Tomorrow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22488,'明天',9) 
GO

delete from HtmlLabelIndex where id=22492 
GO
delete from HtmlLabelInfo where indexid=22492 
GO
INSERT INTO HtmlLabelIndex values(22492,'后天') 
GO
INSERT INTO HtmlLabelInfo VALUES(22492,'后天',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22492,'The day after tomorrow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22492,'後天',9) 
GO



delete from SystemRights where id=821 
GO
insert into SystemRights (id,rightdesc,righttype) values (821,'人员生日提醒权限','3') 
GO
delete from SystemRightsLanguage where id=821 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (821,8,'Birthday to remind staff competence','Birthday to remind staff competence') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (821,7,'人员生日提醒权限','人员生日提醒权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (821,9,'人員生日提醒權限','人員生日提醒權限') 
GO
delete from SystemRightDetail where id=4332 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4332,'人员生日提醒权限','HRM:BirthdayReminder',821) 
GO