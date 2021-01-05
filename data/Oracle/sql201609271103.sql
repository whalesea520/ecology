create table int_cas_setting
(
  isuse      NUMBER(10) not null,
  casserverurl        varchar2(500),
  casserverloginpage        varchar2(500) default '/login',
  casserverlogoutpage        varchar2(500) default '/logout',
  ecologyurl             varchar2(500),
  ecologyloginpage        varchar2(500) default '/login/login.jsp',
  pcauth        NUMBER(10) default 1,
  appauth NUMBER(10),
  accounttype NUMBER(10) default 1,
  customsql varchar2(2000),
  appauthaddress varchar2(500) default '/v1/tickets'
)
/
insert into int_cas_setting(isuse, casserverurl, casserverloginpage, casserverlogoutpage, ecologyurl, ecologyloginpage, pcauth, appauth, accounttype, customsql,appauthaddress) VALUES (1, 'http://192.168.40.217:8081/cas_sqlserver_md5', '/login', '/logout', 'http://192.168.40.217:88', '/login/login.jsp', 1, 0, 1, null,'/v1/tickets')
/
create table int_cas_exclueurl_sys
(
	id	NUMBER(10)	not null,
	excludeurl	varchar2(500)	not null,
	excludedescription	varchar2(500) not null
)
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-1, '/services', 'web service')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-2, '/login/OALogin.jsp', 'oa登录方式')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-3, '/login/VerifyRtxLogin.jsp', 'rtx登录方式')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-4, '/integration/cas/resetCasWebxml.jsp', '清楚web.xml cas配置')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-5, '/workflow/request/ViewRequest.jsp', '流程存为文档1')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-6, '/workflow/request/WorkflowDirection.jsp', '流程存为文档2')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-7, '/workflow/design/workflowPicDisplayInfo.jsp', '流程存为文档3')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-8, '/workflow/design/wfQueryConditions.jsp', '流程存为文档4')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-9, '/js/hrm/getdata.jsp', '流程存为文档5')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-10, '/wui/theme/ecology8/page/getRemindInfo.jsp', '流程存为文档6')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-11, '/workflow/request/ViewRequestIframe.jsp', '流程存为文档7')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-12, '/mobile', '手机端应用')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-13, '/system/InLicense.jsp', 'License授权页面')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-14, '/messager/eim.jsp', 'e-message')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-15, '/social/im', 'e-message-1')
/
insert into int_cas_exclueurl_sys (id, excludeurl, excludedescription) values(-16, '/system/LicenseOperation.jsp', 'License授权页面')
/
create table int_cas_exclueurl
(
	id	integer	not null,
	excludeurl	varchar2(500)	not null,
	excludedescription	varchar2(500) not null
)
/
create sequence int_cas_exclueurl_seq minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 50 order
/
create or replace trigger int_cas_exclueurl_tri before insert on int_cas_exclueurl for each row begin select int_cas_exclueurl_seq.nextval into :new.id from dual; end;
/