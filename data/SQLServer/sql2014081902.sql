Delete from MainMenuInfo where id=1342
GO
EXECUTE MMConfig_U_ByInfoInsert 7,17
GO
EXECUTE MMInfo_Insert 1342,33041,'�A���O�Ù���','/fna/budget/FnaLeftRuleSet/ruleSet.jsp','mainFrame',7,1,17,0,'',0,'',0,'','',0,'','',6
GO

Delete from MainMenuInfo where id=1348
GO
EXECUTE MMConfig_U_ByInfoInsert 7,2
GO
EXECUTE MMInfo_Insert 1348,33070,'��������','','',7,1,2,0,'',0,'',0,'','',0,'','',6
GO

Delete from MainMenuInfo where id=1350
GO
EXECUTE MMConfig_U_ByInfoInsert 1348,1
GO
EXECUTE MMInfo_Insert 1350,33074,'ͨ������','/fna/budget/FnaSystemSetEdit.jsp','mainFrame',1348,2,1,0,'',0,'',0,'','',0,'','',6
GO

Delete from MainMenuInfo where id=1352
GO
EXECUTE MMConfig_U_ByInfoInsert 1348,3
GO
EXECUTE MMInfo_Insert 1352,33071,'�ѿط���','/fna/budget/FnaControlSchemeSet.jsp','mainFrame',1348,2,2,0,'',0,'',0,'','',0,'','',6
GO

Delete from MainMenuInfo where id=1351
GO
EXECUTE MMConfig_U_ByInfoInsert 1348,2
GO
EXECUTE MMInfo_Insert 1351,33075,'�ѿ�����','/fna/budget/FnaWfSetEdit.jsp','mainFrame',1348,2,3,0,'',0,'',0,'','',0,'','',6
GO

Delete from MainMenuInfo where id=1364
GO
EXECUTE MMConfig_U_ByInfoInsert 7,-7
GO
EXECUTE MMInfo_Insert 1364,33173,'��������','','',7,1,-7,0,'',0,'',0,'','',0,'','',6
GO

update MainMenuInfo 
set labelId = 15363, 
	menuName = 'Ԥ�����' 
where id = 7
GO


update MainMenuInfo 
set defaultParentId = 1364, 
	parentId = 1364,
	labelId = 33174, 
	menuName = 'ȫ������',
	defaultIndex = 1
where id = 1350 
GO

update mainmenuconfig 
set viewIndex = 1 
where infoId = 1350 
GO



update MainMenuInfo 
set defaultParentId = 1364, 
	parentId = 1364,
	defaultIndex = 2,
	defaultLevel = 2
where id = 164 
GO

update mainmenuconfig 
set viewIndex = 2 
where infoId = 164 
GO



update MainMenuInfo 
set defaultParentId = 1364, 
	parentId = 1364,
	labelId = 33175, 
	menuName = '��Ŀ����',
	defaultIndex = 3
where id = 168 
GO

update mainmenuconfig 
set viewIndex = 3 
where infoId = 168 
GO

update MainMenuInfo 
set defaultParentId = 1364, 
	parentId = 1364,
	defaultIndex = 4,
	defaultLevel = 2
where id = 167 
GO

update mainmenuconfig 
set viewIndex = 4, 
	visible = 0
where infoId = 167 
GO


update MainMenuInfo 
set labelId = 33071, 
	menuName = 'Ԥ�㷽��',
	defaultIndex = 5
where id = 1352 
GO

update mainmenuconfig 
set viewIndex = 5 
where infoId = 1352 
GO


update MainMenuInfo 
set labelId = 33075, 
	menuName = 'Ԥ������',
	defaultIndex = 6
where id = 1351 
GO

update mainmenuconfig 
set viewIndex = 6 
where infoId = 1351 
GO


update MainMenuInfo 
set labelId = 33193, 
	menuName = '����Ȩ������',
	defaultParentId = 165, 
	parentId = 165,
	defaultIndex = 11,
	defaultLevel = 2
where id = 1342 
GO

update mainmenuconfig 
set viewIndex = 11 
where infoId = 1342 
GO


update MainMenuInfo 
set labelId = 16505, 
	menuName = '���ƹ���',
	defaultIndex = 8
where id = 165 
GO

update mainmenuconfig 
set viewIndex = 8 
where infoId = 165 
GO

update MainMenuInfo 
set labelId = 33177, 
	menuName = 'Ԥ�����',
	defaultIndex = 9
where id = 169 
GO

update mainmenuconfig 
set viewIndex = 9 
where infoId = 169 
GO

update MainMenuInfo 
set labelId = 18436, 
	menuName = '������������',
	defaultIndex = 10
where id = 470 
GO

update mainmenuconfig 
set viewIndex = 10 
where infoId = 470 
GO

update MainMenuInfo 
set labelId = 16506, 
	menuName = '��������',
	defaultIndex = 11
where id = 166 
GO

update mainmenuconfig 
set viewIndex = 11 
where infoId = 166 
GO
