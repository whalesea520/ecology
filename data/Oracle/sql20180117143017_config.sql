delete from CustomerKBVersion where name ='KB8100171100' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100171100','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('27','2','1','web.xml','\WEB-INF\web.xml','E8: Éý¼¶ÖÁKB8100171100²¹¶¡°üweb.xml ÅäÖÃ','10010','KB8100171100','0')
/
call updateXmlFile('59','27','<servlet>
<servlet-name>RsaInfo</servlet-name>
<servlet-class>weaver.rsa.GetRsaInfo</servlet-class>
</servlet>
<servlet-mapping>
<servlet-name>RsaInfo</servlet-name>
<url-pattern>/rsa/weaver.rsa.GetRsaInfo</url-pattern>
</servlet-mapping>','/web-app/servlet/servlet-name[text()=''RsaInfo'']/parent::*','','1','0')
/
