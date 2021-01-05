create or replace procedure MenuConfig_Insert_Cloudstore2
AS
 cnt8 int;
 cnt7 int;

BEGIN
  SELECT count(*) into cnt8 FROM license WHERE cversion like '8%' or  cversion like '9%';
  SELECT count(*) into cnt7 FROM license WHERE cversion like '7%';
  IF cnt8>0 then
    delete from HtmlLabelIndex where id=131878;
	delete from HtmlLabelInfo where indexid=131878;
	INSERT INTO HtmlLabelIndex values(131878,'开发者');
	INSERT INTO HtmlLabelInfo VALUES(131878,'开发者',7);
	INSERT INTO HtmlLabelInfo VALUES(131878,'developer',8);
	INSERT INTO HtmlLabelInfo VALUES(131878,'開發者',9); 
	Delete from MainMenuInfo where id=10752;
	MMConfig_U_ByInfoInsert (10361,6);
	MMInfo_Insert (10752,131878,'开发者','/cloudstore/system/index4ec8.jsp#/dev','mainFrame',10361,2,6,0,'',0,'',0,'','',0,'','',9);

   ELSIF cnt7>0 then
    
    delete from HtmlLabelIndex where id=131878;
	delete from HtmlLabelInfo where indexid=131878;
	INSERT INTO HtmlLabelIndex values(131878,'开发者');
	INSERT INTO HtmlLabelInfo VALUES(131878,'开发者',7);
	INSERT INTO HtmlLabelInfo VALUES(131878,'developer',8);
	INSERT INTO HtmlLabelInfo VALUES(131878,'開發者',9); 
	Delete from MainMenuInfo where id=1498;
	MMConfig_U_ByInfoInsert (1484,6);
	MMInfo_Insert (1498,131878,'开发者','/cloudstore/system/index4ec8.jsp#/dev','mainFrame',1484,1,6,0,'',0,'',0,'','',0,'','',9);
  END IF;
END;
/
call MenuConfig_Insert_Cloudstore2()
/