create procedure MenuConfig_Insert_Cloudstore2
AS
BEGIN
		IF EXISTS(SELECT cversion FROM license WHERE cversion like '8%' or cversion like '9%')
			BEGIN
			delete from HtmlLabelIndex where id=131878;
				delete from HtmlLabelInfo where indexid=131878;
				INSERT INTO HtmlLabelIndex values(131878,'开发者');
				INSERT INTO HtmlLabelInfo VALUES(131878,'开发者',7);
				INSERT INTO HtmlLabelInfo VALUES(131878,'developer',8);
				INSERT INTO HtmlLabelInfo VALUES(131878,'開發者',9); 
				Delete from MainMenuInfo where id=10752;
				EXECUTE MMConfig_U_ByInfoInsert 10361,6;
				EXECUTE MMInfo_Insert 10752,131878,'开发者','/cloudstore/system/index4ec8.jsp#/dev','mainFrame',10361,2,6,0,'',0,'',0,'','',0,'','',9;
			END

		ELSE IF EXISTS(SELECT cversion FROM license WHERE cversion like '7%')
			BEGIN
				delete from HtmlLabelIndex where id=131878;
				delete from HtmlLabelInfo where indexid=131878;
				INSERT INTO HtmlLabelIndex values(131878,'开发者');
				INSERT INTO HtmlLabelInfo VALUES(131878,'开发者',7);
				INSERT INTO HtmlLabelInfo VALUES(131878,'developer',8);
				INSERT INTO HtmlLabelInfo VALUES(131878,'開發者',9); 
				Delete from MainMenuInfo where id=1498;
				EXECUTE MMConfig_U_ByInfoInsert 1484,6;
				EXECUTE MMInfo_Insert 1498,131878,'开发者','/cloudstore/system/index4ec8.jsp#/dev','mainFrame',1484,1,6,0,'',0,'',0,'','',0,'','',9;
			END
END
GO
EXEC MenuConfig_Insert_Cloudstore2
GO