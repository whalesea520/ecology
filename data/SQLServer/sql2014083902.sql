

update MainMenuInfo 
set labelId = 386, 
	menuName = 'Ԥ��' 
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
	defaultLevel = 2,
	linkAddress = '/fna/maintenance/FnaTab.jsp?_fromURL=FnaYearsPeriods' 
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