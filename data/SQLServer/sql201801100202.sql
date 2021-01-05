create procedure MenuConfig_Insert_Cloudstore3
AS
BEGIN
		IF EXISTS(SELECT cversion FROM license WHERE cversion like '8%' or cversion like '9%')
			BEGIN
				Delete from MainMenuInfo where id=10847;
				EXECUTE MMConfig_U_ByInfoInsert 10361,10;
				EXECUTE MMInfo_Insert 10847,127305,'导入导出','/cloudstore/system/index4ec8.jsp#/impexp','mainFrame',10361,2,10,0,'',0,'',0,'','',0,'','',9;
			END
		ELSE IF EXISTS(SELECT cversion FROM license WHERE cversion like '7%')
			BEGIN				
				Delete from MainMenuInfo where id=1502;
				EXECUTE MMConfig_U_ByInfoInsert 1484,18;
				EXECUTE MMInfo_Insert 1502,127305,'导入导出','/cloudstore/system/index4ec8.jsp#/impexp','mainFrame',1484,1,18,0,'',0,'',0,'','',0,'','',9;
			END
END
GO
EXEC MenuConfig_Insert_Cloudstore3
GO