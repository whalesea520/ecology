delete from SystemRightDetail where rightid =1770
/
delete from SystemRightsLanguage where id =1770
/
delete from SystemRights where id =1770
/
insert into SystemRights (id,rightdesc,righttype) values (1770,'资产自定义流程配置','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,8,'Capital Customized Workflow Settings','Capital Customized Workflow Settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,7,'资产自定义流程配置','资产自定义流程配置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1770,9,'資產自定義流程','資產自定義流程') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (41770,'资产自定义流程配置权限','Cpt:CusWfConfig',1770) 
/