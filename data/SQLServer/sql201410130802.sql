Delete from MainMenuInfo where id=1280
GO
EXECUTE MMConfig_U_ByInfoInsert 624,3
GO
EXECUTE MMInfo_Insert 1280,32461,'素材中心','','mainFrame',624,1,3,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1282
GO
EXECUTE MMConfig_U_ByInfoInsert 624,2
GO
EXECUTE MMInfo_Insert 1282,32458,'客户门户','','mainFrame',624,1,2,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1286
GO
EXECUTE MMConfig_U_ByInfoInsert 1282,2
GO
EXECUTE MMInfo_Insert 1286,32460,'登录后门户','','mainFrame',1282,2,2,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1285
GO
EXECUTE MMConfig_U_ByInfoInsert 1282,1
GO
EXECUTE MMInfo_Insert 1285,32459,'登录前门户','','mainFrame',1282,2,1,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1283
GO
EXECUTE MMConfig_U_ByInfoInsert 808,2
GO
EXECUTE MMInfo_Insert 1283,32460,'登录后门户','','mainFrame',808,2,2,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1287
GO
EXECUTE MMConfig_U_ByInfoInsert 1280,7
GO
EXECUTE MMInfo_Insert 1287,32465,'门户元素库','/page/maint/element/PortalElements.jsp','mainFrame',1280,2,7,0,'',0,'',0,'','',0,'','',9
GO

Delete from MainMenuInfo where id=1292
GO
EXECUTE MMConfig_U_ByInfoInsert 1280,10
GO
EXECUTE MMInfo_Insert 1292,32467,'图片素材库','/page/maint/common/CustomResourceMaint.jsp','mainFrame',1280,2,10,0,'',0,'',0,'','',0,'','',9
GO
