delete from SystemRightDetail where rightid =1914
/
delete from SystemRightsLanguage where id =1914
/
delete from SystemRights where id =1914
/
insert into SystemRights (id,rightdesc,righttype) values (1914,'ģ�������Ȩ','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,8,'Module management decentralization','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,9,'ģ�K�����֙�','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1914,7,'ģ�������Ȩ','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43140,'ģ�������Ȩ','HrmModuleManageDetach:Edit',1914) 
/
 
delete from SystemRightDetail where rightid =1913
/
delete from SystemRightsLanguage where id =1913
/
delete from SystemRights where id =1913
/
insert into SystemRights (id,rightdesc,righttype) values (1913,'���ܹ�����Ȩ','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,7,'���ܹ�����Ȩ','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,8,'Functional management empowerment','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1913,9,'���ܹ����x��','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43139,'���ܹ�����Ȩ','HrmEffectManageEmpower:Edit',1913) 
/