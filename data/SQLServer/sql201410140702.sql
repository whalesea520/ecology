update MainMenuInfo set parentId = -10012,defaultParentId = -10012 where id = 1408
GO
update MainMenuInfo set defaultIndex = 12, labelId = 34238, linkAddress = '/hrm/HrmTab.jsp?_fromURL=HrmRightTransfer' where id = 354
GO
UPDATE mainmenuconfig SET viewIndex = 12  WHERE infoId = 354
GO