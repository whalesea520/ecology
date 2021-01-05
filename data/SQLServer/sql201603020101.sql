delete from HtmlLabelIndex where id=126720 
GO
delete from HtmlLabelInfo where indexid=126720 
GO
INSERT INTO HtmlLabelIndex values(126720,'值为“用DNS服务器上面的域名”。例：如远程登录windows服务器输入的帐号为abc\Administrator 则应配置：abc;或者域用户登录域时ou=op,dc=abc,dc=com,则应配置：abc') 
GO
INSERT INTO HtmlLabelInfo VALUES(126720,'值为“用DNS服务器上面的域名”。例：如远程登录windows服务器输入的帐号为abc\Administrator 则应配置：abc;或者域用户登录域时ou=op,dc=abc,dc=com,则应配置：abc',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126720,'The value of &quot;DNS server domain name&quot;. Example: if the windows remote login server input should account for the abc\Administrator configuration: abc; user login or domain domain ou=op, dc=abc, dc=com, should be configured: abc',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126720,'值爲“用DNS服務器上面的域名”。例：如遠程登錄windows服務器輸入的帳号爲abc\Administrator 則應配置：abc;或者域用戶登錄域時ou=op,dc=abc,dc=com,則應配置：abc',9) 
GO
