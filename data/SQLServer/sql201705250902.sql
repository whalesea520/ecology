Delete from MainMenuInfo where id=10483
GO
EXECUTE MMConfig_U_ByInfoInsert 1297,4
GO
EXECUTE MMInfo_Insert 10483,130604,'回收站文档管理','/docs/search/DocMain.jsp?urlType=23','',1297,2,4,0,'',0,'',0,'','',0,'','',1
GO	

Delete from LeftMenuInfo where id=710
GO
EXECUTE LMConfig_U_ByInfoInsert 2,2,26
GO
EXECUTE LMInfo_Insert 710,130650,'/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif','/docs/search/DocMain.jsp?urlType=22',2,2,26,1 
GO