create table Social_Pc_ClientSettings(
	id int IDENTITY,
	keytitle varchar(100),
	keyvalue varchar(100),
	oaidentity varchar(100),
	modifier int,
	modifydate char(10),
	modifytime char(8)
)
GO
alter table Social_Pc_ClientSettings add fromtype char(1)
GO
update Social_Pc_ClientSettings set fromtype = '0'
GO
create table Social_Pc_UrlIcons(
  id int IDENTITY,
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
GO
create table SocialPcUserApps (
	id int IDENTITY,
 	icoid int,
 	userid int,
 	showindex int
)
GO
create table Social_IMUserRight(
  id int IDENTITY,
  permissionType int,
  contents int,
  seclevel int,
  seclevelMax int DEFAULT ((100)),
  jobtitleid varchar(1000),
  joblevel int DEFAULT ((0)),
  scopeid varchar(100)
)
GO

DELETE FROM Social_Pc_ClientSettings
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitReadstate', '1', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitCustomApps', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('maxGroupMems', '500', '', NULL, NULL, NULL, '1')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitSSO', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitFilesTransfer', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitFolderTransfer', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifSendPicOrScreenShots', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitCheckInOut', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifDisableMenuItem', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitGroupOrg', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitAccountSwitch', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitGroupFileShare', '0', NULL, NULL, NULL, NULL, '0')
GO
INSERT INTO Social_Pc_ClientSettings (keytitle, keyvalue, oaidentity, modifier, modifydate, modifytime, fromtype) VALUES ('ifForbitGroupChat', '0', NULL, NULL, NULL, NULL, '0')
GO


set identity_insert Social_Pc_UrlIcons ON
GO
DELETE FROM Social_Pc_UrlIcons
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (1, 227, '/social/images/pcmodels/htb_myhome_wev8.png', '/social/images/pcmodels/htb_myhome_h_wev8.png', '1', 0, 0, '/wui/main.jsp', '', '0', '1', '主页')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (2, 1207, '/social/images/pcmodels/htb_task_todo_wev8.png', '/social/images/pcmodels/htb_task_todo_h_wev8.png', '1', 1, 0, '/workflow/request/RequestView.jsp', '/social/im/SocialHrmCountData.jsp?navtype=1', '0', '1', '待办事宜')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (3, 16093, '/social/images/pcmodels/htb_worksche_wev8.png', '/social/images/pcmodels/htb_worksche_h_wev8.png', '1', 2, 0, '/workplan/data/WorkPlan.jsp', '', '0', '1', '工作日程')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (4, 26467, '/social/images/pcmodels/htb_weibo_wev8.png', '/social/images/pcmodels/htb_weibo_h_wev8.png', '1', 3, 0, '/blog/blogView.jsp', '/social/im/SocialHrmCountData.jsp?navtype=3', '0', '1', '日志')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (5, 71, '/social/images/pcmodels/htb_edit_mail_wev8.png', '/social/images/pcmodels/htb_edit_mail_h_wev8.png', '1', 4, 0, '/email/new/MailFrame.jsp', '/social/im/SocialHrmCountData.jsp?navtype=4', '0', '1', '邮件')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (6, 16392, '/social/images/pcmodels/ftb_wf_wev8.png', '/social/images/pcmodels/ftb_wf_h_wev8.png', '1', 0, 0, '/workflow/request/RequestType.jsp?needPopupNewPage=true', '', '1', '1', '新建流程')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (7, 15007, '/social/images/pcmodels/ftb_newpj_wev8.png', '/social/images/pcmodels/ftb_newpj_h_wev8.png', '1', 2, 0, '/proj/Templet/ProjTempletSele.jsp', '', '1', '1', '新建项目')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (8, 15006, '/social/images/pcmodels/ftb_crm_wev8.png', '/social/images/pcmodels/ftb_crm_h_wev8.png', '1', 3, 0, '/CRM/data/AddCustomerFrame.jsp', '', '1', '1', '新建客户')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (9, 1986, '/social/images/pcmodels/ftb_acc_wev8.png', '/social/images/pcmodels/ftb_acc_h_wev8.png', '1', 4, 0, '/docs/docs/DocList.jsp?isuserdefault=1', '', '1', '1', '新建文档')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (10, 18034, '/social/images/pcmodels/ftb_cowork_wev8.png', '/social/images/pcmodels/ftb_cowork_h_wev8.png', '1', 5, 0, '/cowork/coworkview.jsp?flag=add', '', '1', '1', '新建协作')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (11, 16444, '/social/images/pcmodels/ftb_sms_wev8.png', '/social/images/pcmodels/ftb_sms_h_wev8.png', '1', 6, 0, '/sms/SmsMessageEdit.jsp', '', '1', '1', '新建短信')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (12, 2029, '/social/images/pcmodels/htb_edit_mail_wev8.png', '/social/images/pcmodels/htb_edit_mail_h_wev8.png', '1', 7, 0, '/email/new/MailInBox.jsp?opNewEmail=1', '', '1', '1', '新建邮件')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (13, 15008, '/social/images/pcmodels/ftb_meeting_wev8.png', '/social/images/pcmodels/ftb_meeting_h_wev8.png', '1', 8, 0, '/meeting/data/NewMeetingTab.jsp', '', '1', '1', '新建会议')
GO
INSERT INTO Social_Pc_UrlIcons (id, labelindexid, icouri, hoticouri, ifshowon, showindex, uritype, linkuri, numberuri, icotype, ifsysico, labeltemp) VALUES (14, 126970, '/social/images/pcmodels/ftb_microblog_wev8.png', '/social/images/pcmodels/ftb_microblog_h_wev8.png', '1', 1, 0, '/blog/blogView.jsp', '', '1', '1', '新建微博')
GO


