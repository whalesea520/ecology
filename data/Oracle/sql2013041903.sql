insert into SysPoppupInfo values (15,'/system/sysRemindWfLink.jsp?flag=newEmail','22716','y','22716')
/ 
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('1','126.com','pop.126.com','smtp.126.com','1','110','25','0','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('2','163.com','pop.163.com','smtp.163.com','1','110','25','0','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('3','live.com','pop3.live.com','smtp.live.com','1','995','25','1','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('4','live.cn','pop3.live.com','smtp.live.com','1','995','25','1','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('5','gmail.com','pop.gamil.com','smtp.gmail.com','1','995','465','1','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('6','21cn.com','pop.21cn.com','smtp.21cn.com','1','110','25','0','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('7','qq.com','pop.qq.com','smtp.qq.com','1','110','25','0','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('8','vip.qq.com','pop.qq.com','smtp.qq.com','1','995','465','1','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('9','hotmail.com','pop3.live.com','smtp.live.com','1','995','25','1','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('10','sina.com','pop.sina.com','smtp.sina.com','1','110','25','0','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('11','sohu.com','pop3.sohu.com','smtp.sohu.com','1','110','25','0','1')
/
insert into webmail_domain (DOMAIN_ID, DOMAIN, POP_SERVER, SMTP_SERVER, IS_SMTP_AUTH, POP_PORT, SMTP_PORT, IS_SSL_AUTH,IS_POP) values('12','tom.com','pop.tom.com','smtp.tom.com','1','110','25','0','1')
/



update MailSetting set layout=3
/