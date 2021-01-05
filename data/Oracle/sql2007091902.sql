delete from SystemRights where id=712
/
delete from SystemRightsLanguage where id=712
/
delete from SystemRightDetail where id=4220
/
insert into SystemRights (id,rightdesc,righttype) values (712,'管理索引权限','1')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,8,'IndexManager','IndexManager')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (712,7,'搜索索引管理','搜索索引管理')
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4220,'索引管理','searchIndex:manager',712)
/

delete from leftmenuinfo where id=217
/
delete from leftmenuconfig where infoid=217
/
call LMConfig_U_ByInfoInsert(2,2,15)
/
call LMInfo_Insert(217,20421,'/images/icon_balancelist.gif','/docs/search/SearchDocuments.jsp',2,2,15,1)
/

delete from mainmenuinfo where id=602
/
delete from mainmenuconfig where infoid=602
/
call MMConfig_U_ByInfoInsert(2,24)
/
call MMInfo_Insert(602,20422,'搜索索引管理','/docs/search/IndexManager.jsp','mainFrame',2,1,22,0,'',0,'',0,'','',0,'','',1)
/

update mainmenuinfo set parentid=635,defaultparentid=635 where id =602
/