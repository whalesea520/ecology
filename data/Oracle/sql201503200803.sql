alter table MailConfigureInfo add isAll int DEFAULT 1 
/

alter table MailConfigureInfo add isEml int DEFAULT 1 
/

alter table MailConfigureInfo add emlpath varchar(50) 
/

alter table MailConfigureInfo add emlPeriod int  DEFAULT 30
/

alter table MailConfigureInfo add clearTime int DEFAULT 1
/

alter table MailConfigureInfo add dimissionEmpTime int  DEFAULT 2
/

alter table MailConfigureInfo add isClear int DEFAULT 0
/
update MailConfigureInfo set clearTime = 5, dimissionEmptime = 5, emlPeriod = 30,  isClear = 0
/

alter table MailSign add signType int  DEFAULT 0
/

CREATE TABLE MailBlacklist(
	 id                   int                  not null,
	 userid               int                  not null,
	 name                 varchar(100)         null,
	 postfix	      varchar(50)          null, 
	 constraint PK_MAIL_MailBlacklist primary key (id)
)
/
create sequence mailblacklist_tb_seq 
increment by 1
start with 1
nomaxvalue
nocycle
/
create or replace trigger mailblacklist_tb_tri	
before insert on MailBlacklist     
for each row                     
begin                            
      select mailblacklist_tb_seq.nextval into :new.id from dual;   
end;
/

CREATE TABLE MailElectronSign(
	 id                   int                  not null,
	 signid               int                  not null,
	 name                 varchar(100)         null,     
	 email		      varchar(50)          null, 			
	 jobtitle	      varchar(50)          null,     
	 location	      varchar(200)         null, 			
   	 telephone	      varchar(20)          null,			
	 fax		      varchar(20)          null,			
	 jobname	      varchar(100)         null,			
	 url		      varchar(50)          null,			
	 mobile        	      varchar(50)          null,			
 	 selected             varchar(50)          null,      
	 qrcodepath           clob   null, 
	 signheadpath           clob   null, 
	 constraint PK_MAIL_MailElectronSign primary key (id)
)
/
create sequence mailelectronsign_tb_seq 
increment by 1
start with 1
nomaxvalue
nocycle
/
create or replace trigger mailelectronsign_tb_tri	
before insert on MailElectronSign     
for each row                     
begin                            
      select mailelectronsign_tb_seq.nextval into :new.id from dual;   
end;
/


alter table MailResource add waitdeal varchar(20) 
/

alter table MailResource add waitdealtime varchar(20) 
/

alter table MailResource add waitdealnote varchar(200) 
/

alter table MailResource add wdremindtime varchar(20) 
/

alter table MailResource add waitdealway varchar(10)
/



CREATE TABLE MailReceiveRemind(
	 id                   int                  not null,
	 name                 varchar(100)         not null,
	 enable               int                  not null,
	 content	      varchar(4000)        not null, 
	 constraint PK_MAIL_MailReceiveRemind primary key (id)
)
/
create sequence mailreceiveremind_tb_seq 
increment by 1
start with 1
nomaxvalue
nocycle
/
create or replace trigger mailreceiveremind_tb_tri	
before insert on MailReceiveRemind     
for each row                     
begin                            
      select mailreceiveremind_tb_seq.nextval into :new.id from dual;   
end;
/


insert into MailReceiveRemind(name, enable, content) values ('短信提醒', 0, '您有新邮件(#[title]-#[sneder])到达，请注意查收！')
/
insert into MailReceiveRemind(name, enable, content) values ('微信提醒', 0, '您有新邮件(#[title]-#[sneder])到达，请注意查收！')
/
insert into MailReceiveRemind(name, enable, content) values ('Mobile提醒', 0, '您有新邮件(#[title]-#[sneder])到达，请注意查收！')
/
insert into MailReceiveRemind(name, enable, content) values ('Message提醒', 0, '您有新邮件(#[title]-#[sneder])到达，请注意查收！')
/

create table MailErrorHint (
   id			     int                   not null,
   errorName                 varchar(500)          null,
   errorHint                 varchar(500)          null,
   solution                  varchar(500)          null,
   keyword                   varchar(500)          null,
   isVariable                int                   null
)
/
create sequence mailerrorhint_tb_seq 
increment by 1
start with 1
nomaxvalue
nocycle
/
create or replace trigger mailerrorhint_tb_tri	
before insert on MailErrorHint     
for each row                     
begin                            
      select mailerrorhint_tb_seq.nextval into :new.id from dual;   
end;
/

insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.AuthenticationFailedException', '用户名或密码错误', '用户名或密码错误，请检查用户名及密码设置', 'Unable to log on', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.AuthenticationFailedException', '连接错误', '请检查邮件设置，邮箱服务器地址以及端口是否正确', 'Check your server settings', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.AuthenticationFailedException', '用户名或密码错误', '用户名或密码错误，请检查用户名及密码设置', 'AuthenticationFailedException', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.MessagingException', '无法连接到邮箱服务器', '无法连接到邮箱服务器，请检查邮箱服务器地址是否正确或OA服务器是否能连接上服务器（如果邮箱服务器是内网搭建请使用IP地址，如果是外网邮箱服务器请检查OA服务器外网是否通畅）', 'java.net.UnknownHostException', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.AuthenticationFailedException', '无法连接到邮箱服务器', '无法连接到邮箱服务器，请检查邮箱服务器地址是否正确或OA服务器是否能连接上服务器（如果邮箱服务器是内网搭建请使用IP地址，如果是外网邮箱服务器请检查OA服务器外网是否通畅！）', 'EOF on socket', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('com.sun.mail.util.MailConnectException', '无法连接到邮箱服务器:{0}，端口不通', '端口连接错误，请检查邮箱服务器地址以及端口是否正确或OA服务器是否能连接上服务器telnet通端口', ' connect to host', 1) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.SendFailedException', '无法连接到邮箱服务器:{0}', '无法连接到邮箱服务器:{0}，请检查邮箱服务器地址是否正确或OA服务器是否能连接上服务器（如果邮箱服务器是内网搭建请使用IP地址，如果是外网邮箱服务器请检查OA服务器外网是否通畅）', 'Could not connect to SMTP host', 1) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.MessagingException', '无法连接到邮箱服务器', '无法连接到邮箱服务器，请检查邮箱服务器地址以及端口', 'Connection refused: connect', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.MessagingException', '连接到邮箱服务器超时', '连接超时，请检查邮箱设置和网络环境（OA服务器上）', 'Connection timed out: connect', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.SendFailedException', '用户{0}地址不存在', '用户{0}地址不存在，请检查', '550 User not found', 1) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.MessagingException', '找不到服务器主机：{0}！', '服务器主机{0}不存在，请检查设置或者网络', 'Unknown SMTP host', 1) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.AuthenticationFailedException', '连接失败，请使用SSL加密协议', '请务必选择SSL加密协议！SMTP协议SSL端口为465， POP协议SSL端口为995， IMAP协议SSL端口为993', '???ssl???', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.SMTPSendFailedException', '对不起，该用户没有开通发送邮件权限', '没有发送权限，请联系邮箱服务器管理员', '550 5.7.1 Client does not have permissions to send as this sender', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.NoSuchProviderException', '缺少文件，请联系管理员', '缺少mail相关jar，或jar冲突，请联系技术人员', 'No provider for stmp', 0) 
/

insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.MessagingException', '无法连接到邮箱服务器:{0}', '无法连接到邮箱服务器:{0}，请检查邮箱服务器地址是否正确或OA服务器是否能连接上服务器（如果邮箱服务器是内网搭建请使用IP地址，如果是外网邮箱服务器请检查OA服务器外网是否通畅）', 'Could not connect to SMTP host', 1) 
/


insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.net.ssl.SSLException', 'SSL连接错误，检查端口设置', 'SSL连接错误，请检查端口设置', 'Unrecognized SSL message', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.net.ssl.SSLException', 'SSL连接错误，检查端口设置', 'SSL连接错误，请检查端口设置', 'SSLException', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('com.sun.mail.smtp.SMTPSendFailedException', '需要勾选发件认证', '服务器拒绝，请勾选发件认证', 'authentication is required', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('javax.mail.MessagingException', '邮箱服务器地址错误', '邮箱服务器地址错误请检查邮箱服务器地址', 'Connect failed', 0) 
/
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) values ('com.sun.mail.smtp.SMTPSendFailedException', '用户名，发件地址无效', '用户名或地址无效, 输入有误，请重新输入', '550 Invalid User', 0) 
/