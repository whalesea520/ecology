create table int_cas_setting
(
  isuse      int not null,
  casserverurl        char(500),
  casserverloginpage        char(500) default '/login',
  casserverlogoutpage        char(500) default '/logout',
  ecologyurl             char(500),
  ecologyloginpage        char(500) default '/login/login.jsp',
  pcauth        int default 1,
  appauth int,
  accounttype int default 1,
  customsql char(2000),
  appauthaddress char(500) default '/v1/tickets'
)
go
insert into int_cas_setting(isuse, casserverurl, casserverloginpage, casserverlogoutpage, ecologyurl, ecologyloginpage, pcauth, appauth, accounttype, customsql,appauthaddress)values(1, 'http://192.168.40.217:8081/cas_sqlserver_md5', '/login', '/logout', 'http://192.168.40.217:88', '/login/login.jsp', 1, 0, 1, null,'/v1/tickets');
go
create table int_cas_exclueurl_sys
(
	id	int	not null,
	excludeurl	char(500)	not null,
	excludedescription	char(500) not null
)
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-1, '/services', 'web service')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-2, '/login/OALogin.jsp', 'oa登录方式')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-3, '/login/VerifyRtxLogin.jsp', 'rtx登录方式')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-4, '/integration/cas/resetCasWebxml.jsp', '清楚web.xml cas配置')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-5, '/workflow/request/ViewRequest.jsp', '流程存为文档1')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-6, '/workflow/request/WorkflowDirection.jsp', '流程存为文档2')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-7, '/workflow/design/workflowPicDisplayInfo.jsp', '流程存为文档3')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-8, '/workflow/design/wfQueryConditions.jsp', '流程存为文档4')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-9, '/js/hrm/getdata.jsp', '流程存为文档5')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-10, '/wui/theme/ecology8/page/getRemindInfo.jsp', '流程存为文档6')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-11, '/workflow/request/ViewRequestIframe.jsp', '流程存为文档7')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-12, '/mobile', '手机端应用')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-13, '/system/InLicense.jsp', 'License授权页面')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-14, '/messager/eim.jsp', 'e-message')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-15, '/social/im', 'e-message-1')
go
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-16, '/system/LicenseOperation.jsp', 'License授权页面')
go
create table int_cas_exclueurl
(
	id int	identity   (1,1)   not   null,
	excludeurl	char(500)	not null,
	excludedescription	char(500) not null
)
go