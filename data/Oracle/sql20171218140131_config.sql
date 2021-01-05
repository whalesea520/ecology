delete from CustomerKBVersion where name ='8.100.0531' 
/
insert into CustomerKBVersion(name,sysversion) values ('8.100.0531','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('1','2','1','action.xml','\WEB-INF\service\action.xml','��汾������E8���׼action.xml����','20000','8.100.0531','0')
/
call updateXmlFile('1','1','<service-point id="WorkflowFnaInWorkflowNew" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.interfaces.workflow.action.WorkflowFnaInWorkflowNew"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''WorkflowFnaInWorkflowNew'']','','1','0')
/
call updateXmlFile('2','1','<service-point id="WorkflowFnaEffectNew" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.interfaces.workflow.action.WorkflowFnaEffectNew"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''WorkflowFnaEffectNew'']','','1','0')
/
call updateXmlFile('3','1','<service-point id="WorkflowFnaRejectNew" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.interfaces.workflow.action.WorkflowFnaRejectNew"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''WorkflowFnaRejectNew'']','','1','0')
/
call updateXmlFile('4','1','<service-point id="PrjGenerateAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.proj.wfactions.PrjGenerateAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''PrjGenerateAction'']','','1','0')
/
call updateXmlFile('5','1','<service-point id="PrjApproveAction" interface="weaver.interfaces.workflow.action.Action">        
<invoke-factory>
<construct class="weaver.proj.wfactions.PrjApproveAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''PrjApproveAction'']','','1','0')
/
call updateXmlFile('6','1','<service-point id="PrjTemplateApproveAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.proj.wfactions.PrjTemplateApproveAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''PrjTemplateApproveAction'']','','1','0')
/
call updateXmlFile('7','1','<service-point id="CptApplyAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptApplyAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptApplyAction'']','','1','0')
/
call updateXmlFile('8','1','<service-point id="CptFetchAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptFetchAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptFetchAction'']','','1','0')
/
call updateXmlFile('9','1','<service-point id="CptMoveAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptMoveAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptMoveAction'']','','1','0')
/
call updateXmlFile('10','1','<service-point id="CptLossAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptLossAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptLossAction'']','','1','0')
/
call updateXmlFile('11','1','<service-point id="CptDiscardAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptDiscardAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptDiscardAction'']','','1','0')
/
call updateXmlFile('12','1','<service-point id="CptLendAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptLendAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptLendAction'']','','1','0')
/
call updateXmlFile('13','1','<service-point id="CptBackAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptBackAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptBackAction'']','','1','0')
/
call updateXmlFile('14','1','<service-point id="CptMendAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptMendAction"></construct>
</invoke-factory>
</service-point>','/module/service-point[@id=''CptMendAction'']','','1','0')
/
delete from CustomerKBVersion where name ='8.100.0531' 
/
insert into CustomerKBVersion(name,sysversion) values ('8.100.0531','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('2','2','1','web.xml','\WEB-INF\web.xml','��汾������E8���׼web.xml����','10000','8.100.0531','0')
/
call updateXmlFile('15','2','<filter>
<filter-name>encodingFilter</filter-name>
<filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
<init-param>
<param-name>encoding</param-name>
<param-value>UTF-8</param-value>
</init-param>
</filter>','/web-app/filter/filter-name[text()=''encodingFilter'']/parent::*','��web.xml����������:encodingFilter','1','0')
/
call updateXmlFile('16','2','<filter>
<filter-name>ECompatibleFilter</filter-name>
<filter-class>weaver.filter.ECompatibleFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>ECompatibleFilter</filter-name>
<url-pattern>*.js</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>ECompatibleFilter</filter-name>
<url-pattern>*.css</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>ECompatibleFilter</filter-name>
<url-pattern>*.gif</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>ECompatibleFilter</filter-name>
<url-pattern>*.jpg</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>ECompatibleFilter</filter-name>
<url-pattern>*.png</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''ECompatibleFilter'']/parent::*','��web.xml����������:ECompatibleFilter','1','0')
/
call updateXmlFile('17','2','<jsp-config>
<taglib>
<taglib-uri>/browserTag</taglib-uri>
<taglib-location>/WEB-INF/tld/browser.tld</taglib-location>
</taglib>
<taglib>
<taglib-uri>/browser</taglib-uri>
<taglib-location>/WEB-INF/tld/browser.tld</taglib-location>
</taglib>
</jsp-config>','/web-app/jsp-config/taglib[taglib-uri[text()=''/browserTag''] and taglib-location[text()=''/WEB-INF/tld/browser.tld'']]/parent::*','��web.xml����������:/browserTag','1','0')
/
call updateXmlFile('22','2','<filter>
<filter-name>AppUseInfo</filter-name>
<filter-class>weaver.filter.AppUseFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>AppUseInfo</filter-name>
<url-pattern>*.jsp</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''AppUseInfo'']/parent::*','','1','0')
/
call updateXmlFile('26','2','<filter>
<filter-name>DialogHandleFilter</filter-name>
<filter-class>weaver.filter.DialogHandleFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>DialogHandleFilter</filter-name>
<url-pattern>*.jsp</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''DialogHandleFilter'']/parent::*','','1','0')
/
call updateXmlFile('21','2','<filter>
<filter-name>IECompatibleFilter</filter-name>
<filter-class>weaver.filter.IECompatibleFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>IECompatibleFilter</filter-name>
<url-pattern>*.jsp</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>IECompatibleFilter</filter-name>
<url-pattern>*.js</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>IECompatibleFilter</filter-name>
<url-pattern>*.htm</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>IECompatibleFilter</filter-name>
<url-pattern>*.html</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''IECompatibleFilter'']/parent::*','','1','0')
/
call updateXmlFile('23','2','<filter>
<filter-name>ConnFastFilter</filter-name>
<filter-class>weaver.filter.ConnFastFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>ConnFastFilter</filter-name>
<url-pattern>*.jsp</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>ConnFastFilter</filter-name>
<url-pattern>/weaver/weaver.common.util.taglib.SplitPageXmlServlet</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>ConnFastFilter</filter-name>
<url-pattern>/weaver/weaver.common.util.taglib.SplitPageXmlServletNew</url-pattern >
</filter-mapping>','/web-app/filter/filter-name[text()=''ConnFastFilter'']/parent::*','','1','0')
/
call updateXmlFile('24','2','<filter>
<filter-name>Compress</filter-name>
<filter-class>weaver.filter.WGzipFilter</filter-class>
<init-param> 
<param-name>exclude</param-name> 
<param-value>/wui/theme/ecology8/page/login.jsp;/login/login.jsp;/keygenerator/KeyGenerator.jsp;/keygenerator/getNoCheckFiles.jsp;/keygenerator/packNoCheckFiles.jsp;/workflow/request/WorkflowPDFStream.jsp;/mobile/plugin/Download.jsp</param-value>
</init-param> 
</filter>
<filter-mapping>
    <filter-name>Compress</filter-name>
    <url-pattern>*.js</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>Compress</filter-name>
    <url-pattern>*.css</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>Compress</filter-name>
    <url-pattern>*.jsp</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>Compress</filter-name>
    <url-pattern>/weaver/weaver.common.util.taglib.SplitPageXmlServlet</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>Compress</filter-name>
    <url-pattern>/weaver/weaver.common.util.taglib.SplitPageXmlServletNew</url-pattern>
</filter-mapping>
<filter-mapping>
    <filter-name>Compress</filter-name>
    <url-pattern>/Messager/MessagerServlet</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''Compress'']/parent::*','�����Ϊ���׼��һ��,��������������web.xml��ԭ�����ò�һ�£��Ὣweb.xml��ԭ������ɾ������������','1','0')
/
call updateXmlFile('25','2','<filter>
<filter-name>XssFilter</filter-name>
<filter-class>weaver.filter.XssFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>XssFilter</filter-name>
<url-pattern>*.jsp</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>XssFilter</filter-name>
<url-pattern>*.do</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>XssFilter</filter-name>
<url-pattern>/weaver/*</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>XssFilter</filter-name>
<url-pattern>/log/*</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>XssFilter</filter-name>
<url-pattern>/sqllog/*</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>XssFilter</filter-name>
<url-pattern>/admin</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''XssFilter'']/parent::*','','1','0')
/
call updateXmlFile('27','2','<servlet>
<servlet-name>ShowDocsImageServlet</servlet-name>
<servlet-class>weaver.docs.docs.ShowDocsImageServlet</servlet-class>
</servlet>
<servlet-mapping>
<servlet-name>ShowDocsImageServlet</servlet-name>
<url-pattern>/weaver/weaver.docs.docs.ShowDocsImageServlet</url-pattern>
</servlet-mapping>','/web-app/servlet[servlet-name[text()=''ShowDocsImageServlet''] and servlet-class[text()=''weaver.docs.docs.ShowDocsImageServlet'']]','','1','0')
/
call updateXmlFile('28','2','<servlet>
<servlet-name>InterfaceServlet</servlet-name>
<servlet-class>weaver.admincenter.servlet.InterfaceServlet</servlet-class>
</servlet>
<servlet-mapping>
<servlet-name>InterfaceServlet</servlet-name>
<url-pattern>/weaver/weaver.admincenter.servlet.InterfaceServlet</url-pattern>
</servlet-mapping>','/web-app/servlet[servlet-name[text()=''InterfaceServlet''] and servlet-class[text()=''weaver.admincenter.servlet.InterfaceServlet'']]','','1','0')
/
call updateXmlFile('29','2','<servlet>
<servlet-name>ShowColServlet</servlet-name>
<servlet-class>weaver.common.util.taglib.ShowColServlet</servlet-class>
</servlet>
<servlet-mapping>
<servlet-name>ShowColServlet</servlet-name>
<url-pattern>/weaver/weaver.common.util.taglib.ShowColServlet</url-pattern>
</servlet-mapping>','/web-app/servlet[servlet-name[text()=''ShowColServlet''] and servlet-class[text()=''weaver.common.util.taglib.ShowColServlet'']]','','1','0')
/
call updateXmlFile('30','2','<servlet>
<servlet-name>VerifyLoginServlet</servlet-name>
<servlet-class>weaver.login.VerifyLoginServlet</servlet-class>
</servlet>
<servlet-mapping>
<servlet-name>VerifyLoginServlet</servlet-name>
<url-pattern>/weaver/weaver.login.VerifyLoginServlet</url-pattern>
</servlet-mapping>','/web-app/servlet[servlet-name[text()=''VerifyLoginServlet''] and servlet-class[text()=''weaver.login.VerifyLoginServlet'']]','','1','0')
/
delete from CustomerKBVersion where name ='KB81001507' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001507','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('3','2','1','action.xml','\WEB-INF\service\action.xml','E8--KB81001507������ action.xml����','20001','KB81001507','0')
/
call updateXmlFile('18','3','<service-point id="deduction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.attendance.action.HrmDeductionVacationAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''deduction'']','','1','0')
/
call updateXmlFile('19','3','<service-point id="freeze" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.attendance.action.HrmFreezeVacationAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''freeze'']','','1','0')
/
call updateXmlFile('20','3','<service-point id="release" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.attendance.action.HrmReleaseVacationAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''release'']','','1','0')
/
delete from CustomerKBVersion where name ='KB81001509' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001509','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('4','2','1','web.xml','\WEB-INF\web.xml','E8: �����汾--KB81001509������web.xml����','10001','KB81001509','0')
/
call updateXmlFile('31','4','<servlet>
<servlet-name>dwr-invoker</servlet-name>
<servlet-class>uk.ltd.getahead.dwr.DWRServlet</servlet-class>
<init-param>
<param-name>crossDomainSessionSecurity</param-name>
<param-value>false</param-value>
</init-param>
<init-param>
<param-name>allowScriptTagRemoting</param-name >
<param-value>true </param-value>
</init-param>
<load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
<servlet-name>dwr-invoker</servlet-name>
<url-pattern>/dwr/*</url-pattern>
</servlet-mapping>','/web-app/servlet[servlet-name[text()=''dwr-invoker''] and servlet-class[text()=''uk.ltd.getahead.dwr.DWRServlet'']]','��ecology\WEB-INF\web.xml���������´��룺 
uk.ltd.getahead.dwr.DWRServlet
�����д������һ�������������ã�
<init-param>
<param-name>crossDomainSessionSecurity</param-name>
<param-value>false</param-value>
</init-param>
<init-param>
<param-name>allowScriptTagRemoting</param-name >
<param-value>true </param-value>
</init-param>','1','0')
/
delete from CustomerKBVersion where name ='KB81001510' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001510','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('5','2','1','web.xml','\WEB-INF\web.xml','E8: KB81001509--KB81001510������web.xml����','10002','KB81001510','0')
/
call updateXmlFile('32','5','<servlet>   
<servlet-name>CreateQRCodeServlet</servlet-name>   
<servlet-class>weaver.workflow.exceldesign.CreateQRCodeServlet</servlet-class>   
</servlet>   
<servlet-mapping>   
<servlet-name>CreateQRCodeServlet</servlet-name>   
<url-pattern>/createQRCode</url-pattern>   
</servlet-mapping>','/web-app/servlet/servlet-name[text()=''CreateQRCodeServlet'']/parent::*','','1','0')
/
call updateXmlFile('33','5','<servlet>   
<servlet-name>CreateBarCodeServlet</servlet-name>   
<servlet-class>weaver.workflow.exceldesign.CreateBarCodeServlet</servlet-class>   
</servlet>   
<servlet-mapping>   
<servlet-name>CreateBarCodeServlet</servlet-name>   
<url-pattern>/createBarCode</url-pattern>   
</servlet-mapping>','/web-app/servlet/servlet-name[text()=''CreateBarCodeServlet'']/parent::*','','1','0')
/
delete from CustomerKBVersion where name ='KB81001511' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001511','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('6','2','1','web.xml','\WEB-INF\web.xml','E8: 	KB81001510--KB81001511������web.xml����','10003','KB81001511','0')
/
call updateXmlFile('34','6','<filter>
<filter-name>CloudOaFilter</filter-name>
<filter-class>weaver.filter.CloudOaFilter</filter-class>
<init-param>    
<param-name>excludedPages</param-name>    
<param-value>/login/login.jsp</param-value>    
</init-param> 
</filter>
<filter-mapping>
<filter-name>CloudOaFilter</filter-name>
<url-pattern>/login/*</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>CloudOaFilter</filter-name>
<url-pattern>/rdeploy/*</url-pattern>
</filter-mapping>','/web-app/filter[filter-name[text()=''CloudOaFilter''] and filter-class[text()=''weaver.filter.CloudOaFilter'']]','','1','0')
/
delete from CustomerKBVersion where name ='KB81001508' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001508','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('8','2','1','action.xml','\WEB-INF\service\action.xml','E8: KB81001507-KB81001508��׼action.xml����','20003','KB81001508','0')
/
call updateXmlFile('36','8','<service-point id="HrmResourceEntrant" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceEntrantAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceEntrant'']','','1','0')
/
call updateXmlFile('37','8','<service-point id="HrmResourceTry" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceTryAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceTry'']','','1','0')
/
call updateXmlFile('38','8','<service-point id="HrmResourceHire" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceHireAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceHire'']','','1','0')
/
call updateXmlFile('39','8','<service-point id="HrmResourceExtend" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceExtendAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceExtend'']','','1','0')
/
call updateXmlFile('40','8','<service-point id="HrmResourceRedeploy" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceRedeployAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceRedeploy'']','','1','0')
/
call updateXmlFile('41','8','<service-point id="HrmResourceDismiss" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceDismissAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceDismiss'']','','1','0')
/
call updateXmlFile('42','8','<service-point id="HrmResourceRetire" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceRetireAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceRetire'']','','1','0')
/
call updateXmlFile('43','8','<service-point id="HrmResourceFire" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceFireAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceFire'']','','1','0')
/
call updateXmlFile('44','8','<service-point id="HrmResourceReHire" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.pm.action.HrmResourceReHireAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmResourceReHire'']','','1','0')
/
delete from CustomerKBVersion where name ='KB81001603' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001603','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('9','2','1','web.xml','\WEB-INF\web.xml','E8: KB81001512--KB81001603������web.xml����','10005','KB81001603','0')
/
call updateXmlFile('45','9','<servlet>   
<servlet-name>CreateWfBarCodeServlet</servlet-name>   
<servlet-class>weaver.workflow.exceldesign.CreateBarCodeServlet</servlet-class>   
</servlet>   
<servlet-mapping>   
<servlet-name>CreateWfBarCodeServlet</servlet-name>   
<url-pattern>/createWfBarCode</url-pattern>   
</servlet-mapping>','/web-app/servlet/servlet-name[text()=''CreateWfBarCodeServlet'']/parent::*','','1','0')
/
call updateXmlFile('46','9','<filter>
<filter-name>SecurityFilter</filter-name>
<filter-class>weaver.filter.SecurityFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>SecurityFilter</filter-name>
<url-pattern>/*</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''SecurityFilter'']/parent::*','����ͻ������˵����¼(CAS)��¼,��ô��Ѹ�filter�ŵ�CAS��ص�filter֮��,����ϵͳ�޷�����','1','0')
/
delete from CustomerKBVersion where name ='KB81001606' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001606','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('10','2','1','web.xml','\WEB-INF\web.xml','E8: KB81001603--KB81001606������web.xml����','10006','KB81001606','0')
/
call updateXmlFile('47','10','<servlet>
<servlet-name>action</servlet-name>
<servlet-class>org.apache.struts.action.ActionServlet</servlet-class>
<init-param>
<param-name>config</param-name>
<param-value>/WEB-INF/struts-config.xml</param-value>
</init-param>
<load-on-startup>2</load-on-startup>
</servlet>
<servlet-mapping>
<servlet-name>action</servlet-name>
<url-pattern>*.do</url-pattern>
</servlet-mapping>','/web-app/servlet[servlet-name[text()=''action''] and servlet-class[text()=''org.apache.struts.action.ActionServlet'']]','�Զ�����������','0','0')
/
delete from CustomerKBVersion where name ='KB8100161000' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100161000','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('11','2','1','web.xml','\WEB-INF\web.xml','E8: KB81001606--KB8100161000������web.xml ����','10007','KB8100161000','0')
/
call updateXmlFile('48','11','<filter>
<filter-name>FixIPFilter</filter-name>
<filter-class>weaver.filter.FixIPFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>FixIPFilter</filter-name>
<url-pattern>*.jsp</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''FixIPFilter'']/parent::*','','1','0')
/
delete from CustomerKBVersion where name ='KB8100161100' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100161100','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('12','2','1','web.xml','\WEB-INF\web.xml','E8: KB8100161000--KB8100161100������web.xml����','10008','KB8100161100','0')
/
call updateXmlFile('49','12','<servlet>
<servlet-name>CreateBarCode</servlet-name>
<servlet-class>weaver.cpt.barcode.BarCodeServlet</servlet-class>
</servlet>
<servlet-mapping>
<servlet-name>CreateBarCode</servlet-name>
<url-pattern>/CreateBarCode</url-pattern>
</servlet-mapping>','/web-app/servlet/servlet-name[text()=''CreateBarCode'']/parent::*','','1','0')
/
delete from CustomerKBVersion where name ='KB81001603' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001603','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('13','2','1','action.xml','\WEB-INF\service\action.xml','E8: KB81001508-KB81001603��׼action.xml����','20004','KB81001603','0')
/
call updateXmlFile('50','13','<service-point id="HrmScheduleShift" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.schedule.action.HrmScheduleShiftAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmScheduleShift'']','','1','0')
/
call updateXmlFile('51','13','<service-point id="HrmPaidLeaveAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.hrm.attendance.action.HrmPaidLeaveAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''HrmPaidLeaveAction'']','','1','0')
/
delete from CustomerKBVersion where name ='KB8100170200' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100170200','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('16','2','1','web.xml','\WEB-INF\web.xml','E8: KB8100161100--KB8100170200������web.xml ����','10009','KB8100170200','0')
/
call updateXmlFile('54','16','<filter>
<filter-name>WorkflowPicShowFilter</filter-name>
<filter-class>weaver.filter.WorkflowPicShowFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>WorkflowPicShowFilter</filter-name>
<url-pattern>/workflow/request/WorkflowRequestPictureInner.jsp</url-pattern>
</filter-mapping>
<filter-mapping>
<filter-name>WorkflowPicShowFilter</filter-name>
<url-pattern>/workflow/request/WorkflowDirection.jsp</url-pattern>
</filter-mapping>','/web-app/filter/filter-name[text()=''WorkflowPicShowFilter'']/parent::*','','1','0')
/
delete from CustomerKBVersion where name ='8.100.0531' 
/
insert into CustomerKBVersion(name,sysversion) values ('8.100.0531','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('17','2','1','services.xml','\classbean\META-INF\xfire\services.xml','��汾������E8���׼services.xml����','30001','8.100.0531','0')
/
call updateXmlFile('55','17','<service>
<name>HrmServiceTest</name>
<namespace>webservices.hrmservicetest.weaver.com.cn</namespace>
<serviceClass>weaver.hrm.webservice.HrmServiceTest</serviceClass>
<implementationClass>weaver.hrm.webservice.HrmServiceTest</implementationClass>
</service>','//*[local-name()=''beans'']/*[local-name()=''service'']/*[local-name()=''name'' and text()=''HrmServiceTest'']/parent::*','','1','0')
/
delete from CustomerKBVersion where name ='8.100.0531' 
/
insert into CustomerKBVersion(name,sysversion) values ('8.100.0531','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('19','1','1','page.properties','\WEB-INF\prop\page.properties','','50001','8.100.0531','0')
/
call updatePropertiesFile('2','19','element.customPath','/page/elementCustom/','�Զ���Ԫ�ط���·��','1','0')
/
delete from CustomerKBVersion where name ='KB8100170400' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100170400','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('20','1','1','weaver_initmodule.properties','\WEB-INF\prop\weaver_initmodule.properties','��Ҫ�ֶ��޸����ã���ʼ����cusupdate��ֵ�� 1 ��� 0','259177','KB8100170400','0')
/
call updatePropertiesFile('3','20','cusupdate','1','��ʼ�������Ϊ0','0','0')
/
delete from CustomerKBVersion where name ='KB81001512' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB81001512','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('7','2','1','web.xml','\WEB-INF\web.xml','E8: 	KB81001511--	KB81001512������web.xml����','10004','KB81001512','0')
/
call updateXmlFile('35','7','<servlet>
<servlet-name>ReplyFileDownload</servlet-name>
<servlet-class>weaver.docs.docs.reply.FileDownload</servlet-class>
</servlet>
<servlet-mapping>
<servlet-name>ReplyFileDownload</servlet-name>
<url-pattern>/weaver/weaver.docs.docs.reply.FileDownload</url-pattern>
</servlet-mapping>','/web-app/servlet[servlet-name[text()=''ReplyFileDownload''] and servlet-class[text()=''weaver.docs.docs.reply.FileDownload'']]','','1','0')
/
delete from CustomerKBVersion where name ='KB8100161000' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100161000','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('14','2','1','action.xml','\WEB-INF\service\action.xml','E8: KB81001603-KB8100161000��׼action.xml����','20005','KB8100161000','0')
/
call updateXmlFile('52','14','<service-point  id="CreateTraceDocument" interface="weaver.interfaces.workflow.action.Action">      
<invoke-factory>           
<construct class="weaver.interfaces.workflow.action.CreateTraceDocument"/>         
</invoke-factory>                
</service-point>','/module/service-point[@id=''CreateTraceDocument'']','','1','0')
/
delete from CustomerKBVersion where name ='KB8100170300' 
/
insert into CustomerKBVersion(name,sysversion) values ('KB8100170300','8.100.0531')
/
delete from CustomerSysVersion where name ='8.100.0531' 
/
insert into CustomerSysVersion(name) values ('8.100.0531')
/
call updateconfigFileManager('15','2','1','action.xml','\WEB-INF\service\action.xml','E8: KB8100161000-KB8100170300��׼action.xml����','20006','KB8100170300','0')
/
call updateXmlFile('53','15','<service-point id="CptChangeAction" interface="weaver.interfaces.workflow.action.Action">
<invoke-factory>
<construct class="weaver.cpt.wfactions.CptChangeAction" />
</invoke-factory>
</service-point>','/module/service-point[@id=''CptChangeAction'']','','1','0')
/