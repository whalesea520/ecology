Delete from LeftMenuInfo where id=392
GO
EXECUTE LMConfig_U_ByInfoInsert 1,0,6
GO
EXECUTE LMInfo_Insert 392,26467,NULL,NULL,1,0,6,9
GO

Delete from LeftMenuInfo where id=393
GO
EXECUTE LMConfig_U_ByInfoInsert 2,392,0
GO
EXECUTE LMInfo_Insert 393,26468,'/images_face/ecologyFace_2/LeftMenuIcon/myblog.gif','/blog/blogView.jsp',2,392,0,9 
GO


Delete from LeftMenuInfo where id=394
GO
EXECUTE LMConfig_U_ByInfoInsert 2,392,1
GO
EXECUTE LMInfo_Insert 394,26469,'/images_face/ecologyFace_2/LeftMenuIcon/blog_dynamic.gif','/blog/blogView.jsp?item=attention',2,392,1,9 
GO



Delete from LeftMenuInfo where id=395
GO
EXECUTE LMConfig_U_ByInfoInsert 2,392,2
GO
EXECUTE LMInfo_Insert 395,26470,'/images_face/ecologyFace_2/LeftMenuIcon/blog_report.gif','/blog/blogReport.jsp',2,392,2,9 
GO
 
Delete from LeftMenuInfo where id=399
GO
EXECUTE LMConfig_U_ByInfoInsert 2,392,3
GO
EXECUTE LMInfo_Insert 399,26630,'/images_face/ecologyFace_2/LeftMenuIcon/blog_set.gif','/blog/blogSetting.jsp',2,392,3,9 
GO



Delete from MainMenuInfo where id=1047
GO
EXECUTE MMConfig_U_ByInfoInsert 11,52
GO
EXECUTE MMInfo_Insert 1047,26759,'����΢��','','',11,1,52,0,'',0,'',0,'','',0,'','',9
GO


Delete from MainMenuInfo where id=1049
GO
EXECUTE MMConfig_U_ByInfoInsert 1047,2
GO
EXECUTE MMInfo_Insert 1049,26761,'΢��Ӧ������','/blog/BlogAppSetting.jsp','',1047,2,2,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1048
GO
EXECUTE MMConfig_U_ByInfoInsert 1047,1
GO
EXECUTE MMInfo_Insert 1048,26760,'΢����������','/blog/blogBaseSetting.jsp','',1047,2,1,0,'',0,'',0,'','',0,'','',9
GO