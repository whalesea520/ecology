alter table MailConfigureInfo add isAll int not null  DEFAULT 1 
GO

alter table MailConfigureInfo add isEml int DEFAULT 1 
GO

alter table MailConfigureInfo add emlpath varchar(50) 
GO

alter table MailConfigureInfo add emlPeriod int  DEFAULT 30
GO

alter table MailConfigureInfo add clearTime int DEFAULT 1
GO

alter table MailConfigureInfo add dimissionEmpTime int  DEFAULT 2
GO

alter table MailConfigureInfo add isClear int DEFAULT 0
GO

update MailConfigureInfo set clearTime = 5, dimissionEmptime = 5, emlPeriod = 30, isClear = 0
GO


alter table MailSign add signType int  DEFAULT 0
GO

CREATE TABLE MailBlacklist(
	 id                   int                  identity,
	 userid               int                  not null,
	 name                 varchar(100)         null,
	 postfix	      varchar(50)          null, 
	 constraint PK_MAIL_MailBlacklist primary key (id)
)
GO


CREATE TABLE MailElectronSign(
	 id                   int                  identity,
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
	 qrcodepath           text   null, 
	 signheadpath           text   null, 
	 constraint PK_MAIL_MailElectronSign primary key (id)
)
GO



alter table MailResource add waitdeal varchar(20) 
GO

alter table MailResource add waitdealtime varchar(20) 
GO

alter table MailResource add waitdealnote varchar(200) 
GO

alter table MailResource add wdremindtime varchar(20) 
GO

alter table MailResource add waitdealway varchar(10)
GO



CREATE TABLE MailReceiveRemind(
	 id                   int                  identity,
	 name                 varchar(100)         not null,
	 enable               int                  not null,
	 content	      varchar(4000)        not null, 
	 constraint PK_MAIL_MailReceiveRemind primary key (id)
)
GO

insert into MailReceiveRemind(name, enable, content) values ('��������', 0, '�������ʼ�(#[title]-#[sneder])�����ע����գ�');
GO
insert into MailReceiveRemind(name, enable, content) values ('΢������', 0, '�������ʼ�(#[title]-#[sneder])�����ע����գ�');
GO
insert into MailReceiveRemind(name, enable, content) values ('Mobile����', 0, '�������ʼ�(#[title]-#[sneder])�����ע����գ�');
GO
insert into MailReceiveRemind(name, enable, content) values ('Message����', 0, '�������ʼ�(#[title]-#[sneder])�����ע����գ�');
GO


create table MailErrorHint (
   id                   int                  identity,
   errorName                 varchar(500)         null,
   errorHint                 varchar(500)          null,
   solution                  varchar(500)          null,
   keyword                   varchar(500)          null,
   isVariable                int                   null,
   constraint PK_MailErrorHint primary key (id)
)
GO

insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.AuthenticationFailedException', '�û������������', '�û�����������������û�������������', 'Unable to log on', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.AuthenticationFailedException', '���Ӵ���', '�����ʼ����ã������������ַ�Լ��˿��Ƿ���ȷ', 'Check your server settings', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.AuthenticationFailedException', '�û������������', '�û�����������������û�������������', 'AuthenticationFailedException', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.MessagingException', '�޷����ӵ����������', '�޷����ӵ���������������������������ַ�Ƿ���ȷ��OA�������Ƿ��������Ϸ����������������������������ʹ��IP��ַ������������������������OA�����������Ƿ�ͨ����', 'java.net.UnknownHostException', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.AuthenticationFailedException', '�޷����ӵ����������', '�޷����ӵ���������������������������ַ�Ƿ���ȷ��OA�������Ƿ��������Ϸ����������������������������ʹ��IP��ַ������������������������OA�����������Ƿ�ͨ������', 'EOF on socket', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable)
	values ('com.sun.mail.util.MailConnectException', '�޷����ӵ����������:{0}���˿ڲ�ͨ', '�˿����Ӵ������������������ַ�Լ��˿��Ƿ���ȷ��OA�������Ƿ��������Ϸ�����telnetͨ�˿�', ' connect to host', 1) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable)
	values ('javax.mail.SendFailedException', '�޷����ӵ����������:{0}', '�޷����ӵ����������:{0}�����������������ַ�Ƿ���ȷ��OA�������Ƿ��������Ϸ����������������������������ʹ��IP��ַ������������������������OA�����������Ƿ�ͨ����', 'Could not connect to SMTP host', 1) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable)
	values ('javax.mail.MessagingException', '�޷����ӵ����������', '�޷����ӵ���������������������������ַ�Լ��˿�', 'Connection refused: connect', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable)
	values ('javax.mail.MessagingException', '���ӵ������������ʱ', '���ӳ�ʱ�������������ú����绷����OA�������ϣ�', 'Connection timed out: connect', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.SendFailedException', '�û�{0}��ַ������', '�û�{0}��ַ�����ڣ�����', '550 User not found', 1) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.MessagingException', '�Ҳ���������������{0}��', '����������{0}�����ڣ��������û�������', 'Unknown SMTP host', 1) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable)
	values ('javax.mail.AuthenticationFailedException', '����ʧ�ܣ���ʹ��SSL����Э��', '�����ѡ��SSL����Э�飡SMTPЭ��SSL�˿�Ϊ465�� POPЭ��SSL�˿�Ϊ995�� IMAPЭ��SSL�˿�Ϊ993', '???ssl???', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.SMTPSendFailedException', '�Բ��𣬸��û�û�п�ͨ�����ʼ�Ȩ��', 'û�з���Ȩ�ޣ�����ϵ�������������Ա', '550 5.7.1 Client does not have permissions to send as this sender', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable)
	values ('javax.mail.NoSuchProviderException', 'ȱ���ļ�������ϵ����Ա', 'ȱ��mail���jar����jar��ͻ������ϵ������Ա', 'No provider for stmp', 0) 
GO

insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable)
	values ('javax.mail.MessagingException', '�޷����ӵ����������:{0}', '�޷����ӵ����������:{0}�����������������ַ�Ƿ���ȷ��OA�������Ƿ��������Ϸ����������������������������ʹ��IP��ַ������������������������OA�����������Ƿ�ͨ����', 'Could not connect to SMTP host', 1) 
GO


insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.net.ssl.SSLException', 'SSL���Ӵ��󣬼��˿�����', 'SSL���Ӵ�������˿�����', 'Unrecognized SSL message', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.net.ssl.SSLException', 'SSL���Ӵ��󣬼��˿�����', 'SSL���Ӵ�������˿�����', 'SSLException', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('com.sun.mail.smtp.SMTPSendFailedException', '��Ҫ��ѡ������֤', '�������ܾ����빴ѡ������֤', 'authentication is required', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.MessagingException', '�����������ַ����', '�����������ַ�������������������ַ', 'Connect failed', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('com.sun.mail.smtp.SMTPSendFailedException', '�û�����������ַ��Ч', '�û������ַ��Ч, ������������������', '550 Invalid User', 0) 
GO

insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.net.ssl.SSLException', 'SSL���Ӵ��󣬼��˿�����', 'SSL���Ӵ�������˿�����', 'Unrecognized SSL message', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.net.ssl.SSLException', 'SSL���Ӵ��󣬼��˿�����', 'SSL���Ӵ�������˿�����', 'SSLException', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('com.sun.mail.smtp.SMTPSendFailedException', '��Ҫ��ѡ������֤', '�������ܾ����빴ѡ������֤', 'authentication is required', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('javax.mail.MessagingException', '�����������ַ����', '�����������ַ�������������������ַ', 'Connect failed', 0) 
GO
insert into MailErrorHint(errorName, errorHint, solution, keyword, isVariable) 
	values ('com.sun.mail.smtp.SMTPSendFailedException', '�û�����������ַ��Ч', '�û������ַ��Ч, ������������������', '550 Invalid User', 0) 
GO