UPDATE MainMenuInfo SET labelId = 82537 WHERE id = 131
GO
UPDATE MainMenuInfo SET labelId = 82577 WHERE id = 150
GO
Delete from MainMenuInfo where id=10169
GO
EXECUTE MMConfig_U_ByInfoInsert 10079,4
GO
EXECUTE MMInfo_Insert 10169,82533,'商机信息字段设置','/base/ffield/ListSellChanceFreeField.jsp','mainFrame',10079,2,4,0,'',0,'',0,'','',0,'','',4
GO
Delete from MainMenuInfo where id=10170
GO
EXECUTE MMConfig_U_ByInfoInsert 131,3
GO
EXECUTE MMInfo_Insert 10170,82538,'商机类型','/CRM/sellchance/ListCRMTypes.jsp','mainFrame',131,3,3,0,'',0,'',0,'','',0,'','',4
GO
 