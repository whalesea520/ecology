create procedure MenuConfig_Insert_Cloudstore
AS
BEGIN
		IF EXISTS(SELECT cversion FROM license WHERE cversion like '8%' or cversion like '9%')
			BEGIN
				delete from HtmlLabelIndex where id=33644;
				delete from HtmlLabelInfo where indexid=33644;
				INSERT INTO HtmlLabelIndex values(33644,'云商店') ;
				INSERT INTO HtmlLabelInfo VALUES(33644,'云商店',7);
				INSERT INTO HtmlLabelInfo VALUES(33644,'Online Store',8) ;
				INSERT INTO HtmlLabelInfo VALUES(33644,'雲商店',9) ;
				Delete from MainMenuInfo where id=10361;
				EXECUTE MMConfig_U_ByInfoInsert 0,12;		
				EXECUTE MMInfo_Insert 10361,33644,'云商店','/cloudstore/system/index4ec8.jsp#/newapps','mainFrame',0,1,12,0,'',0,'',0,'','',0,'','',9;

				Delete from MainMenuInfo where id=10367;
				EXECUTE MMConfig_U_ByInfoInsert 10361,1;
				EXECUTE MMInfo_Insert 10367,25432,'应用','/cloudstore/system/index4ec8.jsp#/newapps','mainFrame',10361,2,1,0,'',0,'',0,'','',0,'','',9;
		
				delete from HtmlLabelIndex where id=128769;
				delete from HtmlLabelInfo where indexid=128769;
				INSERT INTO HtmlLabelIndex values(128769,'初始配置');
				INSERT INTO HtmlLabelInfo VALUES(128769,'初始配置',7);
				INSERT INTO HtmlLabelInfo VALUES(128769,'Initial configuration',8);
				INSERT INTO HtmlLabelInfo VALUES(128769,'初始配置',9);
				Delete from MainMenuInfo where id=10368;
				EXECUTE MMConfig_U_ByInfoInsert 10361,2;
				EXECUTE MMInfo_Insert 10368,128769,'初始配置','/cloudstore/system/index4ec8.jsp#/init','mainFrame',10361,2,2,0,'',0,'',0,'','',0,'','',9;
		
				delete from HtmlLabelIndex where id=128770;
				delete from HtmlLabelInfo where indexid=128770;
				INSERT INTO HtmlLabelIndex values(128770,'授权管理');
				INSERT INTO HtmlLabelInfo VALUES(128770,'授权管理',7);
				INSERT INTO HtmlLabelInfo VALUES(128770,'Authorization management',8);
				INSERT INTO HtmlLabelInfo VALUES(128770,'授權管理',9);
				Delete from MainMenuInfo where id=10369;
				EXECUTE MMConfig_U_ByInfoInsert 10361,3;
				EXECUTE MMInfo_Insert 10369,128770,'授权管理','/cloudstore/system/index4ec8.jsp#/auth','mainFrame',10361,2,3,0,'',0,'',0,'','',0,'','',9;
		
				delete from HtmlLabelIndex where id=128771;
				delete from HtmlLabelInfo where indexid=128771;
				INSERT INTO HtmlLabelIndex values(128771,'角色管理');
				INSERT INTO HtmlLabelInfo VALUES(128771,'角色管理',7);
				INSERT INTO HtmlLabelInfo VALUES(128771,'Role management',8);
				INSERT INTO HtmlLabelInfo VALUES(128771,'角色管理',9);
				Delete from MainMenuInfo where id=10370;
				EXECUTE MMConfig_U_ByInfoInsert 10361,4;
				EXECUTE MMInfo_Insert 10370,128771,'角色管理','/cloudstore/system/index4ec8.jsp#/roleList','mainFrame',10361,2,4,0,'',0,'',0,'','',0,'','',9;
		
				delete from HtmlLabelIndex where id=128772;
				delete from HtmlLabelInfo where indexid=128772;
				INSERT INTO HtmlLabelIndex values(128772,'系统管理');
				INSERT INTO HtmlLabelInfo VALUES(128772,'系统管理',7);
				INSERT INTO HtmlLabelInfo VALUES(128772,'System management',8);
				INSERT INTO HtmlLabelInfo VALUES(128772,'系統管理',9);
				Delete from MainMenuInfo where id=10371;
				EXECUTE MMConfig_U_ByInfoInsert 10361,5;
				EXECUTE MMInfo_Insert 10371,128772,'系统管理','/cloudstore/system/index4ec8.jsp#/sys','mainFrame',10361,2,5,0,'',0,'',0,'','',0,'','',9;
			END

			ELSE IF EXISTS(SELECT cversion FROM license WHERE cversion like '7%')
			BEGIN
				delete from HtmlLabelIndex where id=33644;
				delete from HtmlLabelInfo where indexid=33644;
				INSERT INTO HtmlLabelIndex values(33644,'云商店');
				INSERT INTO HtmlLabelInfo VALUES(33644,'云商店',7);
				INSERT INTO HtmlLabelInfo VALUES(33644,'Online Store',8);
				INSERT INTO HtmlLabelInfo VALUES(33644,'雲商店',9);
				Delete from MainMenuInfo where id=1484;
				EXECUTE MMConfig_U_ByInfoInsert 0,107;
				EXECUTE MMInfo_Insert 1484,33644,'','','',0,0,107,0,'',0,'',0,'','',0,'','',9;
 
				Delete from MainMenuInfo where id=1485;
				EXECUTE MMConfig_U_ByInfoInsert 1484,1;
				EXECUTE MMInfo_Insert 1485,25432,'应用','/cloudstore/system/index4ec8.jsp#/newapps','mainFrame',1484,1,1,0,'',0,'',0,'','',0,'','',9;
 
				delete from HtmlLabelIndex where id=128769;
				delete from HtmlLabelInfo where indexid=128769;
				INSERT INTO HtmlLabelIndex values(128769,'初始配置');
				INSERT INTO HtmlLabelInfo VALUES(128769,'初始配置',7);
				INSERT INTO HtmlLabelInfo VALUES(128769,'Initial configuration',8);
				INSERT INTO HtmlLabelInfo VALUES(128769,'初始配置',9); 
				Delete from MainMenuInfo where id=1486;
				EXECUTE MMConfig_U_ByInfoInsert 1484,2;
				EXECUTE MMInfo_Insert 1486,128769,'初始配置','/cloudstore/system/index4ec8.jsp#/init','mainFrame',1484,1,2,0,'',0,'',0,'','',0,'','',9;
 
				delete from HtmlLabelIndex where id=128770;
				delete from HtmlLabelInfo where indexid=128770;
				INSERT INTO HtmlLabelIndex values(128770,'授权管理');
				INSERT INTO HtmlLabelInfo VALUES(128770,'授权管理',7);
				INSERT INTO HtmlLabelInfo VALUES(128770,'Authorization management',8);
				INSERT INTO HtmlLabelInfo VALUES(128770,'授權管理',9); 
				Delete from MainMenuInfo where id=1487;
				EXECUTE MMConfig_U_ByInfoInsert 1484,3;
				EXECUTE MMInfo_Insert 1487,128770,'授权管理','/cloudstore/system/index4ec8.jsp#/auth','mainFrame',1484,1,3,0,'',0,'',0,'','',0,'','',9;


				delete from HtmlLabelIndex where id=128771;
				delete from HtmlLabelInfo where indexid=128771;
				INSERT INTO HtmlLabelIndex values(128771,'角色管理');
				INSERT INTO HtmlLabelInfo VALUES(128771,'角色管理',7);
				INSERT INTO HtmlLabelInfo VALUES(128771,'Role management',8);
				INSERT INTO HtmlLabelInfo VALUES(128771,'角色管理',9); 
				Delete from MainMenuInfo where id=1488;
				EXECUTE MMConfig_U_ByInfoInsert 1484,4;
				EXECUTE MMInfo_Insert 1488,128771,'角色管理','/cloudstore/system/index4ec8.jsp#/roleList','mainFrame',1484,1,4,0,'',0,'',0,'','',0,'','',9;
			 
				delete from HtmlLabelIndex where id=128772;
				delete from HtmlLabelInfo where indexid=128772;
				INSERT INTO HtmlLabelIndex values(128772,'系统管理');
				INSERT INTO HtmlLabelInfo VALUES(128772,'系统管理',7);
				INSERT INTO HtmlLabelInfo VALUES(128772,'System management',8);
				INSERT INTO HtmlLabelInfo VALUES(128772,'系統管理',9); 
				Delete from MainMenuInfo where id=1489;
				EXECUTE MMConfig_U_ByInfoInsert 1484,5;
				EXECUTE MMInfo_Insert 1489,128772,'系统管理','/cloudstore/system/index4ec8.jsp#/sys','mainFrame',1484,1,5,0,'',0,'',0,'','',0,'','',9;

			END
END
GO
EXEC MenuConfig_Insert_Cloudstore
GO