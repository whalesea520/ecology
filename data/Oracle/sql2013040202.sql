Delete from LeftMenuInfo where id=535
/
call LMConfig_U_ByInfoInsert (2,2,25)
/
call LMInfo_Insert (535,30906,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/companygroup/CompnayGroup.jsp',2,2,25,1) 
/
Delete from LeftMenuInfo where id=534
/
call LMConfig_U_ByInfoInsert (2,2,24)
/
call LMInfo_Insert (534,30905,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/cpcompanyinfo/CompanyInfoSurvey.jsp',2,2,24,1) 
/
Delete from MainMenuInfo where id=1242
/
call MMConfig_U_ByInfoInsert (0,11)
/
call MMInfo_Insert  (1242,30905,'÷§’’π‹¿Ì','/cpcompanyinfo/SetCompany.jsp','mainFrame',0,0,11,0,'',0,'',0,'','',0,'','',1)
/