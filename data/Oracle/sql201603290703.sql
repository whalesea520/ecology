create table Social_Pc_ClientSettings(
	id int primary key,
	keytitle varchar(100),
	keyvalue varchar(100),
	oaidentity varchar(100),
	modifier int,
	modifydate char(10),
	modifytime char(8),
	fromtype char(1)
)
/
create table Social_Pc_UrlIcons(
  id int primary key,
  labelindexid int,
  labeltemp varchar(100),
  icouri varchar(100),
  hoticouri varchar(100),
  ifshowon char(1),
  showindex int,
  uritype int,
  linkuri varchar(255),
  numberuri varchar(255),
  icotype char(1),
  ifsysico char(1)
)
/
create table SocialPcUserApps (
	id int primary key,
 	icoid int,
 	userid int,
 	showindex int
)
/
create table Social_IMUserRight(
  id int primary key,
  permissionType int,
  contents int,
  seclevel int,
  seclevelMax int DEFAULT ((100)),
  jobtitleid varchar(1000),
  joblevel int DEFAULT ((0)),
  scopeid varchar(100)
)
/

create sequence ClientSettings_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger ClientSettings_trigger 
before insert on Social_Pc_ClientSettings
for each row 
begin 
	select ClientSettings_seq.nextval into:new.id from sys.dual;
end;
/

create sequence UrlIcons_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger UrlIcons_trigger 
before insert on Social_Pc_UrlIcons
for each row 
begin 
	select UrlIcons_seq.nextval into:new.id from sys.dual;
end;
/

create sequence SocialPcUserApps_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger SocialPcUserApps_trigger 
before insert on SocialPcUserApps
for each row 
begin 
	select SocialPcUserApps_seq.nextval into:new.id from sys.dual;
end;
/

create sequence Social_IMUserRight_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/

create or replace trigger Social_IMUserRight_trigger 
before insert on Social_IMUserRight
for each row 
begin 
	select Social_IMUserRight_seq.nextval into:new.id from sys.dual;
end;
/

DELETE FROM Social_Pc_ClientSettings
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitReadstate', '1', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitCustomApps', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('maxGroupMems', '500', '', NULL, NULL, NULL, '1')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitSSO', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitFilesTransfer', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitFolderTransfer', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifSendPicOrScreenShots', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitCheckInOut', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifDisableMenuItem', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitGroupOrg', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitAccountSwitch', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitGroupFileShare', '0', NULL, NULL, NULL, NULL, '0')
/
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitGroupChat', '0', NULL, NULL, NULL, NULL, '0')
/

DELETE FROM Social_Pc_UrlIcons
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (1, 227, '/social/images/pcmodels/htb_myhome_wev8.png', '/social/images/pcmodels/htb_myhome_h_wev8.png', '1', 0, 0, '/wui/main.jsp', '', '0', '1', '主页')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (2, 1207, '/social/images/pcmodels/htb_task_todo_wev8.png', '/social/images/pcmodels/htb_task_todo_h_wev8.png', '1', 1, 0, '/workflow/request/RequestView.jsp', '/social/im/SocialHrmCountData.jsp?navtype=1', '0', '1', '待办事宜')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (3, 16093, '/social/images/pcmodels/htb_worksche_wev8.png', '/social/images/pcmodels/htb_worksche_h_wev8.png', '1', 2, 0, '/workplan/data/WorkPlan.jsp', '', '0', '1', '工作日程')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (4, 26467, '/social/images/pcmodels/htb_weibo_wev8.png', '/social/images/pcmodels/htb_weibo_h_wev8.png', '1', 3, 0, '/blog/blogView.jsp', '/social/im/SocialHrmCountData.jsp?navtype=3', '0', '1', '日志')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (5, 71, '/social/images/pcmodels/htb_edit_mail_wev8.png', '/social/images/pcmodels/htb_edit_mail_h_wev8.png', '1', 4, 0, '/email/new/MailFrame.jsp', '/social/im/SocialHrmCountData.jsp?navtype=4', '0', '1', '邮件')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (6, 16392, '/social/images/pcmodels/ftb_wf_wev8.png', '/social/images/pcmodels/ftb_wf_h_wev8.png', '1', 0, 0, '/workflow/request/RequestType.jsp?needPopupNewPage=true', '', '1', '1', '新建流程')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (7, 15007, '/social/images/pcmodels/ftb_newpj_wev8.png', '/social/images/pcmodels/ftb_newpj_h_wev8.png', '1', 2, 0, '/proj/Templet/ProjTempletSele.jsp', '', '1', '1', '新建项目')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (8, 15006, '/social/images/pcmodels/ftb_crm_wev8.png', '/social/images/pcmodels/ftb_crm_h_wev8.png', '1', 3, 0, '/CRM/data/AddCustomerFrame.jsp', '', '1', '1', '新建客户')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (9, 1986, '/social/images/pcmodels/ftb_acc_wev8.png', '/social/images/pcmodels/ftb_acc_h_wev8.png', '1', 4, 0, '/docs/docs/DocList.jsp?isuserdefault=1', '', '1', '1', '新建文档')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (10, 18034, '/social/images/pcmodels/ftb_cowork_wev8.png', '/social/images/pcmodels/ftb_cowork_h_wev8.png', '1', 5, 0, '/cowork/coworkview.jsp?flag=add', '', '1', '1', '新建协作')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (11, 16444, '/social/images/pcmodels/ftb_sms_wev8.png', '/social/images/pcmodels/ftb_sms_h_wev8.png', '1', 6, 0, '/sms/SmsMessageEdit.jsp', '', '1', '1', '新建短信')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (12, 2029, '/social/images/pcmodels/htb_edit_mail_wev8.png', '/social/images/pcmodels/htb_edit_mail_h_wev8.png', '1', 7, 0, '/email/new/MailInBox.jsp?opNewEmail=1', '', '1', '1', '新建邮件')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (13, 15008, '/social/images/pcmodels/ftb_meeting_wev8.png', '/social/images/pcmodels/ftb_meeting_h_wev8.png', '1', 8, 0, '/meeting/data/NewMeetingTab.jsp', '', '1', '1', '新建会议')
/
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (14, 126970, '/social/images/pcmodels/ftb_microblog_wev8.png', '/social/images/pcmodels/ftb_microblog_h_wev8.png', '1', 1, 0, '/blog/blogView.jsp', '', '1', '1', '新建微博')
/

