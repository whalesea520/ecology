
EXECUTE MMInfo_Insert 598,20413,'个人文档统计','/docs/report/DocRpOrganizationSum.jsp?organizationtype=3','mainFrame',207,2,17,0,'',0,'',0,'','',0,'','',1
GO

EXECUTE MMInfo_Insert 599,20414,'部门文档统计','/docs/report/DocRpOrganizationSum.jsp?organizationtype=2','mainFrame',207,2,18,0,'',0,'',0,'','',0,'','',1
GO

EXECUTE MMInfo_Insert 600,20415,'分部文档统计','/docs/report/DocRpOrganizationSum.jsp?organizationtype=1','mainFrame',207,2,19,0,'',0,'',0,'','',0,'','',1
GO

update MainMenuInfo set defaultIndex = 1 where id = 258
GO
update MainMenuConfig set viewIndex = 1 where infoid = 258
GO
update MainMenuInfo set defaultIndex = 2 where id = 259
GO
update MainMenuConfig set viewIndex = 2 where infoid = 259
GO
update MainMenuInfo set defaultIndex = 3 where id = 260
GO
update MainMenuConfig set viewIndex = 3 where infoid = 260
GO
update MainMenuInfo set defaultIndex = 4 where id = 261
GO
update MainMenuConfig set viewIndex = 4 where infoid = 261
GO
update MainMenuInfo set defaultIndex = 5 where id = 262
GO
update MainMenuConfig set viewIndex = 5 where infoid = 262
GO
update MainMenuInfo set defaultIndex = 6 where id = 263
GO
update MainMenuConfig set viewIndex = 6 where infoid = 263
GO
update MainMenuInfo set defaultIndex = 7 where id = 264
GO
update MainMenuConfig set viewIndex = 7 where infoid = 264
GO
update MainMenuInfo set defaultIndex = 8 where id = 265
GO
update MainMenuConfig set viewIndex = 8 where infoid = 265
GO
update MainMenuInfo set defaultIndex = 9 where id = 266
GO
update MainMenuConfig set viewIndex = 9 where infoid = 266
GO
update MainMenuInfo set defaultIndex = 10 where id = 267
GO
update MainMenuConfig set viewIndex = 10 where infoid = 267
GO
update MainMenuInfo set defaultIndex = 11 where id = 268
GO
update MainMenuConfig set viewIndex = 11 where infoid = 268
GO
update MainMenuInfo set defaultIndex = 12 where id = 269
GO
update MainMenuConfig set viewIndex = 12 where infoid = 269
GO
update MainMenuInfo set defaultIndex = 13 where id = 521
GO
update MainMenuConfig set viewIndex = 13 where infoid = 521
GO
update MainMenuInfo set defaultIndex = 14 where id = 270
GO
update MainMenuConfig set viewIndex = 14 where infoid = 270
GO
update MainMenuInfo set defaultIndex = 15 where id = 522
GO
update MainMenuConfig set viewIndex = 15 where infoid = 522
GO
update MainMenuInfo set defaultIndex = 16 where id = 598
GO
update MainMenuConfig set viewIndex = 16 where infoid = 598
GO
update MainMenuInfo set defaultIndex = 17 where id = 599
GO
update MainMenuConfig set viewIndex = 17 where infoid = 599
GO
update MainMenuInfo set defaultIndex = 18 where id = 600
GO
update MainMenuConfig set viewIndex = 18 where infoid = 600
GO