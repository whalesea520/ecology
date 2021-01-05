delete from HtmlLabelIndex where id=22482 
/
delete from HtmlLabelInfo where indexid=22482 
/
INSERT INTO HtmlLabelIndex values(22482,'手机号码') 
/
INSERT INTO HtmlLabelInfo VALUES(22482,'手机号码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22482,'Mobile',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22482,'手機號碼',9) 
/

delete from HtmlLabelIndex where id=22483 
/
delete from HtmlLabelInfo where indexid=22483 
/
INSERT INTO HtmlLabelIndex values(22483,'人员生日提醒列表') 
/
INSERT INTO HtmlLabelInfo VALUES(22483,'人员生日提醒列表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22483,'Birthday reminder list of staff',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22483,'人員生日提醒列表',9) 
/

delete from HtmlLabelIndex where id=22484 
/
delete from HtmlLabelInfo where indexid=22484 
/
INSERT INTO HtmlLabelIndex values(22484,'客户生日提醒列表') 
/
INSERT INTO HtmlLabelInfo VALUES(22484,'客户生日提醒列表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22484,'Customer birthday reminder list',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22484,'客戶生日提醒列表',9) 
/

delete from HtmlLabelIndex where id=22488 
/
delete from HtmlLabelInfo where indexid=22488 
/
INSERT INTO HtmlLabelIndex values(22488,'明天') 
/
INSERT INTO HtmlLabelInfo VALUES(22488,'明天',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22488,'Tomorrow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22488,'明天',9) 
/

delete from HtmlLabelIndex where id=22492 
/
delete from HtmlLabelInfo where indexid=22492 
/
INSERT INTO HtmlLabelIndex values(22492,'后天') 
/
INSERT INTO HtmlLabelInfo VALUES(22492,'后天',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22492,'The day after tomorrow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22492,'後天',9) 
/


delete from SystemRights where id=821 
/
insert into SystemRights (id,rightdesc,righttype) values (821,'人员生日提醒权限','3') 
/
delete from SystemRightsLanguage where id=821 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (821,8,'Birthday to remind staff competence','Birthday to remind staff competence') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (821,7,'人员生日提醒权限','人员生日提醒权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (821,9,'人員生日提醒權限','人員生日提醒權限') 
/
delete from SystemRightDetail where id=4332 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4332,'人员生日提醒权限','HRM:BirthdayReminder',821) 
/