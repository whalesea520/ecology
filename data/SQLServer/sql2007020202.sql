delete from SystemRights where id = 706
GO
delete from SystemRightsLanguage where id = 706
GO
delete from SystemRightDetail where id = 4214
GO

insert into SystemRights (id,rightdesc,righttype) values (706,'初始化BBS用户','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (706,8,'init bbs user','init bbs user') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (706,7,'初始化BBS用户','初始化BBS用户') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (706,9,'初始化BBS用户','初始化BBS用户') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4214,'初始化BBS用户','INITBBS',706) 
GO

delete from leftmenuinfo where id=204
GO
delete from leftmenuinfo where id=205
GO

exec LMConfig_U_ByInfoInsert 1,NULL,0
GO
exec LMInfo_Insert 204,20193,NULL,NULL,1,NULL,0,9
GO
update leftmenuinfo set iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/CRM_27.gif'  where id=204
GO

exec LMConfig_U_ByInfoInsert 2,204,0
GO
exec LMInfo_Insert 205,20193,'/images_face/ecologyFace_2/LeftMenuIcon/CRM_27.gif','/bbs/OpenBBS.jsp',2,204,0,9
GO

update leftmenuinfo set baseTarget='_new' where id=205
GO

delete from mainmenuinfo where id=579
GO

exec MMConfig_U_ByInfoInsert 11,1
GO
exec MMInfo_Insert 579,20194,'初始化BBS用户','/bbs/InitBBS.jsp','mainFrame',11,1,1,0,'',0,'',0,'','',0,'','',9
GO
