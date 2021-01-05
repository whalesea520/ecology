Delete from MainMenuInfo where id=1148
GO
EXECUTE MMConfig_U_ByInfoInsert 1047,3
GO
EXECUTE MMInfo_Insert 1148,28171,'微博模版设置','/blog/BlogTemplateSetting.jsp','',1047,2,3,0,'',0,'',0,'','',0,'','',9
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42554,'微博模版设置','blog:templateSetting',1141) 
GO

Delete from MainMenuInfo where id=1159
GO
EXECUTE MMConfig_U_ByInfoInsert 1047,4
GO
EXECUTE MMInfo_Insert 1159,28205,'微博指定共享','/blog/specified/blogSpecifiedShare.jsp','',1047,2,4,0,'',0,'',0,'','',0,'','',9
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42565,'微博指定共享','blog:specifiedShare',1141) 
GO