create or replace procedure MenuConfig_Insert_Cloudstore3
AS
 cnt8 int;
 cnt7 int;

BEGIN
  SELECT count(*) into cnt8 FROM license WHERE cversion like '8%' or  cversion like '9%';
  SELECT count(*) into cnt7 FROM license WHERE cversion like '7%';
  IF cnt8>0 then
    Delete from MainMenuInfo where id=10847;
	MMConfig_U_ByInfoInsert (10361,10);
	MMInfo_Insert (10847,127305,'导入导出','/cloudstore/system/index4ec8.jsp#/impexp','mainFrame',10361,2,10,0,'',0,'',0,'','',0,'','',9);

  ELSIF cnt7>0 then    
    Delete from MainMenuInfo where id=1502;
	MMConfig_U_ByInfoInsert (1484,18);
	MMInfo_Insert(1502,127305,'导入导出','/cloudstore/system/index4ec8.jsp#/impexp','mainFrame',1484,1,18,0,'',0,'',0,'','',0,'','',9);
  END IF;
END;
/
call MenuConfig_Insert_Cloudstore3()
/
