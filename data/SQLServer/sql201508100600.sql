delete from SystemRightDetail where rightid =1889
GO
delete from SystemRightsLanguage where id =1889
GO
delete from SystemRights where id =1889
GO
insert into SystemRights (id,rightdesc,righttype) values (1889,'归档集成','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,9,'歸檔集成','歸檔集成') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,7,'归档集成','归档集成') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1889,8,'exp','exp') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43118,'归档集成设置','exp:expsetting',1889) 
GO
delete from SystemLogItem where itemid ='158'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('158','83253','归档流程注册','')
GO
delete from SystemLogItem where itemid ='159'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('159','83256','归档FTP列表','')
GO
delete from SystemLogItem where itemid ='160'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('160','83257','归档本地列表','')
GO
delete from SystemLogItem where itemid ='161'
GO
insert into SystemLogItem(itemid,lableid,itemdesc,typeid) values('161','83259','归档数据库列表','')
GO