delete from SystemRightDetail where rightid = 909
GO
delete from SystemRightsLanguage where id = 909
GO
delete from SystemRights where id = 909
GO

insert into SystemRights (id,rightdesc,righttype) values (909,'代理日志权限','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (909,7,'代理日志权限','代理日志权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (909,8,'right for log of agent','right for log of agent') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (909,9,'代理日誌權限','代理日誌權限') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4435,'代理日志权限','AgentLog:View',909) 
GO
