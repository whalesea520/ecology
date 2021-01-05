Delete from MainMenuInfo where id=1148
/
call MMConfig_U_ByInfoInsert(1047,3)
/
call MMInfo_Insert(1148,28171,'微博模版设置','/blog/BlogTemplateSetting.jsp','',1047,2,3,0,'',0,'',0,'','',0,'','',9)
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42554,'微博模版设置','blog:templateSetting',1141) 
/

Delete from MainMenuInfo where id=1159
/
call MMConfig_U_ByInfoInsert (1047,4)
/
call MMInfo_Insert (1159,28205,'微博指定共享','/blog/specified/blogSpecifiedShare.jsp','',1047,2,4,0,'',0,'',0,'','',0,'','',9)
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (42565,'微博指定共享','blog:specifiedShare',1141) 
/