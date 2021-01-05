Delete from LeftMenuInfo where id=540
/
call LMConfig_U_ByInfoInsert (1,0,9)
/
call LMInfo_Insert (540,30905,NULL,NULL,1,0,9,9)
/
Delete from LeftMenuInfo where id=543
/
call LMConfig_U_ByInfoInsert (2,540,0)
/
call LMInfo_Insert (543,30905,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/cpcompanyinfo/CompanyInfoSurvey.jsp',2,540,0,9) 
/
Delete from LeftMenuInfo where id=544
/
call LMConfig_U_ByInfoInsert (2,540,1)
/
call LMInfo_Insert (544,30906,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/companygroup/CompnayGroup.jsp',2,540,1,9) 
/
Delete from MainMenuInfo where id=1255
/
call MMConfig_U_ByInfoInsert (0,1)
/
call MMInfo_Insert (1255,30905,'证照管理','','mainFrame',0,0,30,0,'',0,'',0,'','',0,'','',9)
/
Delete from MainMenuInfo where id=1257
/
call MMConfig_U_ByInfoInsert (1255,1)
/
call MMInfo_Insert (1257,31406,'后台维护','/cpcompanyinfo/SetCompany.jsp','mainFrame',1255,1,1,0,'',0,'',0,'','',0,'','',9)
/