delete from CustomerKBVersion where name ='KB8100180200' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100180200','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('28','2','1','web.xml','\WEB-INF\web.xml','WebLogic环境：
解决后台应用中心--门户引擎--素材库--新闻模板库
点击内部新闻/外部新闻模版对应的［下载］按钮报404的问题','10011','KB8100180200','0')
/
call updateXmlFile('60','28','<servlet>
        <servlet-name>NewsTemplateDownloadServlet</servlet-name>
        <servlet-class>weaver.page.maint.template.news.NewsTemplateDownloadServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>NewsTemplateDownloadServlet</servlet-name>
        <url-pattern>/weaver/weaver.page.maint.template.news.NewsTemplateDownloadServlet</url-pattern>
    </servlet-mapping>','/web-app/servlet/servlet-name[text()=''NewsTemplateDownloadServlet'']/parent::*','','1','0')
/
