Delete from LeftMenuInfo where id=392
/
call LMConfig_U_ByInfoInsert (1,0,6)
/
call LMInfo_Insert (392,26759,'/images_face/ecologyFace_2/LeftMenuIcon/myblog.gif',NULL,1,0,6,9)   
/

Delete from LeftMenuInfo where id=393
/
call LMConfig_U_ByInfoInsert (2,392,0)
/
call LMInfo_Insert (393,27128,'/images_face/ecologyFace_2/LeftMenuIcon/blog_homepage.gif','/blog/blogView.jsp',2,392,0,9) 
/

Delete from MainMenuInfo where id=1048
/
call MMConfig_U_ByInfoInsert (1047,1)
/
call MMInfo_Insert (1048,26760,'Œ¢≤©ª˘±æ…Ë÷√','/blog/BlogbaseSetting.jsp','',1047,2,1,0,'',0,'',0,'','',0,'','',9)
/
