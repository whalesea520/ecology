Delete from LeftMenuInfo where id=535
GO
exec LMConfig_U_ByInfoInsert 2,2,25
GO
exec LMInfo_Insert 535,30906,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/companygroup/CompnayGroup.jsp',2,2,25,1
GO
Delete from LeftMenuInfo where id=534
GO
exec LMConfig_U_ByInfoInsert 2,2,24
GO
exec LMInfo_Insert 534,30905,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/cpcompanyinfo/CompanyInfoSurvey.jsp',2,2,24,1
GO
Delete from MainMenuInfo where id=1242
GO
exec MMConfig_U_ByInfoInsert 0,11
GO
exec MMInfo_Insert  1242,30905,'÷§’’π‹¿Ì','/cpcompanyinfo/SetCompany.jsp','mainFrame',0,0,11,0,'',0,'',0,'','',0,'','',1
GO