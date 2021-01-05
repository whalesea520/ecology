delete from SystemRightDetail where rightid =2105
GO
delete from SystemRightsLanguage where id =2105
GO
delete from SystemRights where id =2105
GO
insert into SystemRights (id,rightdesc,righttype) values (2105,'集成中心-数据源','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2105,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2105,8,'Integration Center - data source','Integration Center - data source settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2105,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2105,7,'集成中心-数据源','集成中心-数据源设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2105,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2105,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2105,9,'集成中心-數據源','集成中心-數據源設置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43329,'集成中心－数据源设置权限','intergration:datasourcesetting',2105) 
GO
delete from SystemRightDetail where rightid =2106
GO
delete from SystemRightsLanguage where id =2106
GO
delete from SystemRights where id =2106
GO
insert into SystemRights (id,rightdesc,righttype) values (2106,'集成中心-WEBSERVICE注册','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2106,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2106,7,'集成中心-WEBSERVICE注册','集成中心-WEBSERVICE注册设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2106,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2106,9,'集成中心-WEBSERVICE註冊','集成中心-WEBSERVICE註冊設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2106,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2106,8,'Integration Center -WEBSERVICE registration','Integration Center -WEBSERVICE registration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2106,15,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43330,'集成中心-WEBSERVICE注册设置权限','intergration:webserivcesetting',2106) 
GO
delete from SystemRightDetail where rightid =2107
GO
delete from SystemRightsLanguage where id =2107
GO
delete from SystemRights where id =2107
GO
insert into SystemRights (id,rightdesc,righttype) values (2107,'集成中心-集成登录','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2107,9,'集成中心-集成登錄','集成中心-集成登錄設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2107,7,'集成中心-集成登录','集成中心-集成登录设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2107,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2107,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2107,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2107,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2107,8,'Integration Center - Integrated login','Integration Center - Integrated login settings') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43331,'集成中心-集成登录设置权限','intergration:outtersyssetting',2107) 
GO
delete from SystemRightDetail where rightid =2108
GO
delete from SystemRightsLanguage where id =2108
GO
delete from SystemRights where id =2108
GO
insert into SystemRights (id,rightdesc,righttype) values (2108,'集成中心-LDAP集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2108,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2108,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2108,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2108,8,'Integrated center -LDAP integration','Integration Center -LDAP integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2108,9,'集成中心-LDAP集成','集成中心-LDAP集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2108,7,'集成中心-LDAP集成','集成中心-LDAP集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2108,14,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43332,'集成中心-LDAP集成设置权限','intergration:ldapsetting',2108) 
GO
delete from SystemRightDetail where rightid =2109
GO
delete from SystemRightsLanguage where id =2109
GO
delete from SystemRights where id =2109
GO
insert into SystemRights (id,rightdesc,righttype) values (2109,'集成中心-HR同步','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2109,8,'Integrated center -HR synchronization','Integration Center -HR synchronization settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2109,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2109,9,'集成中心-HR同步','集成中心-HR同步設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2109,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2109,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2109,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2109,7,'集成中心-HR同步','集成中心-HR同步设置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43333,'集成中心-HR同步设置权限','intergration:hrsetting',2109) 
GO
delete from SystemRightDetail where rightid =2110
GO
delete from SystemRightsLanguage where id =2110
GO
delete from SystemRights where id =2110
GO
insert into SystemRights (id,rightdesc,righttype) values (2110,'集成中心-计划任务','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2110,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2110,7,'集成中心-计划任务','集成中心-计划任务设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2110,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2110,9,'集成中心-計劃任務','集成中心-計劃任務設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2110,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2110,8,'Integration Center - planning tasks','Integration Center - scheduled task settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2110,15,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43334,'集成中心-计划任务设置权限','intergration:schedulesetting',2110) 
GO
delete from SystemRightDetail where rightid =2111
GO
delete from SystemRightsLanguage where id =2111
GO
delete from SystemRights where id =2111
GO
insert into SystemRights (id,rightdesc,righttype) values (2111,'集成中心-流程触发集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2111,9,'集成中心-流程觸發集成','集成中心-流程觸發集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2111,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2111,7,'集成中心-流程触发集成','集成中心-流程触发集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2111,8,'Integration Center - process triggered integration','Integration Center - process trigger integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2111,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2111,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2111,12,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43335,'集成中心-流程触发集成设置权限','intergration:automaticsetting',2111) 
GO
delete from SystemRightDetail where rightid =2112
GO
delete from SystemRightsLanguage where id =2112
GO
delete from SystemRights where id =2112
GO
insert into SystemRights (id,rightdesc,righttype) values (2112,'集成中心-流程流转集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2112,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2112,9,'集成中心-流程流轉集成','集成中心-流程流轉集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2112,8,'Integration Center - process flow integration','Integration Center - process flow integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2112,7,'集成中心-流程流转集成','集成中心-流程流转集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2112,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2112,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2112,12,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43336,'集成中心-流程流转集成设置权限','intergration:formactionsetting',2112) 
GO
delete from SystemRightDetail where rightid =2113
GO
delete from SystemRightsLanguage where id =2113
GO
delete from SystemRights where id =2113
GO
insert into SystemRights (id,rightdesc,righttype) values (2113,'集成中心-数据展现集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2113,7,'集成中心-数据展现集成','集成中心-数据展现集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2113,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2113,8,'Integration Center - data presentation integration','Integration Center - data display integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2113,9,'集成中心-數據展現集成','集成中心-數據展現集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2113,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2113,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2113,13,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43337,'集成中心-数据展现集成设置权限','intergration:datashowsetting',2113) 
GO
delete from SystemRightDetail where rightid =2114
GO
delete from SystemRightsLanguage where id =2114
GO
delete from SystemRights where id =2114
GO
insert into SystemRights (id,rightdesc,righttype) values (2114,'集成中心-IM集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2114,9,'集成中心-IM集成','集成中心-IM集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2114,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2114,7,'集成中心-IM集成','集成中心-IM集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2114,8,'Integrated center -IM integration','Integration Center -IM integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2114,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2114,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2114,12,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43338,'集成中心-IM集成设置权限','intergration:rtxsetting',2114) 
GO
delete from SystemRightDetail where rightid =2115
GO
delete from SystemRightsLanguage where id =2115
GO
delete from SystemRights where id =2115
GO
insert into SystemRights (id,rightdesc,righttype) values (2115,'集成中心-流程归档集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2115,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2115,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2115,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2115,8,'Integration Center - process archiving integration','Integration Center - process archiving integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2115,9,'集成中心-流程歸檔集成','集成中心-流程歸檔集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2115,7,'集成中心-流程归档集成','集成中心-流程归档集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2115,14,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43339,'集成中心-流程归档集成设置权限','intergration:expsetting',2115) 
GO
delete from SystemRightDetail where rightid =2117
GO
delete from SystemRightsLanguage where id =2117
GO
delete from SystemRights where id =2117
GO
insert into SystemRights (id,rightdesc,righttype) values (2117,'集成中心-财务凭证','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2117,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2117,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2117,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2117,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2117,8,'Integration Center - financial documents','Integration Center - financial document settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2117,7,'集成中心-财务凭证','集成中心-财务凭证设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2117,9,'集成中心-財務憑證','集成中心-財務憑證設置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43341,'集成中心-財務憑證設置权限','intergration:financesetting',2117) 
GO
delete from SystemRightDetail where rightid =1974
GO
delete from SystemRightsLanguage where id =1974
GO
delete from SystemRights where id =1974
GO
insert into SystemRights (id,rightdesc,righttype) values (1974,'集成中心-统一待办中心集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,7,'集成中心-统一待办中心集成','集成中心-统一待办中心集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,8,'集成中心-统一待办中心集成','Integration Center - unified todo center integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,9,'集成中心-統壹待辦中心集成','集成中心-統壹待辦中心集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1974,15,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43192,'集成中心-统一待办中心集成设置权限','ofs:ofssetting',1974) 
GO
delete from SystemRightDetail where rightid =2119
GO
delete from SystemRightsLanguage where id =2119
GO
delete from SystemRights where id =2119
GO
insert into SystemRights (id,rightdesc,righttype) values (2119,'集成中心-SAP集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2119,8,'Integrated center -SAP integration','Integration Center -SAP integration settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2119,7,'集成中心-SAP集成','集成中心-SAP集成设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2119,9,'集成中心-SAP集成','集成中心-SAP集成設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2119,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2119,14,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2119,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2119,12,'','') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43342,'集成中心-SAP集成设置权限','intergration:SAPsetting',2119) 
GO
