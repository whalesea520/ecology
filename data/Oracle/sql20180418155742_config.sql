delete from CustomerKBVersion where name ='KB8100180200' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100180200','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('28','2','1','web.xml','\WEB-INF\web.xml','WebLogic������
�����̨Ӧ������--�Ż�����--�زĿ�--����ģ���
����ڲ�����/�ⲿ����ģ���Ӧ�ģ����أݰ�ť��404������','10011','KB8100180200','0')
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