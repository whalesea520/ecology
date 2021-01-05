DELETE FROM MainMenuConfig WHERE infoid = 598
/
DELETE FROM MainMenuInfo WHERE id = 598
/
CALL MMInfo_Insert (598,20413,'个人文档统计','/docs/report/DocRpOrganizationSum.jsp?organizationtype=3','mainFrame',207,2,17,0,'',0,'',0,'','',0,'','',1)
/

DELETE FROM MainMenuConfig WHERE infoid = 599
/
DELETE FROM MainMenuInfo WHERE id = 599
/
CALL MMInfo_Insert (599,20414,'部门文档统计','/docs/report/DocRpOrganizationSum.jsp?organizationtype=2','mainFrame',207,2,18,0,'',0,'',0,'','',0,'','',1)
/

DELETE FROM MainMenuConfig WHERE infoid = 600
/
DELETE FROM MainMenuInfo WHERE id = 600
/
CALL MMInfo_Insert (600,20415,'分部文档统计','/docs/report/DocRpOrganizationSum.jsp?organizationtype=1','mainFrame',207,2,19,0,'',0,'',0,'','',0,'','',1)
/

update MainMenuInfo set defaultIndex = 1 where id = 258
/
update MainMenuConfig set viewIndex = 1 where infoid = 258
/
update MainMenuInfo set defaultIndex = 2 where id = 259
/
update MainMenuConfig set viewIndex = 2 where infoid = 259
/
update MainMenuInfo set defaultIndex = 3 where id = 260
/
update MainMenuConfig set viewIndex = 3 where infoid = 260
/
update MainMenuInfo set defaultIndex = 4 where id = 261
/
update MainMenuConfig set viewIndex = 4 where infoid = 261
/
update MainMenuInfo set defaultIndex = 5 where id = 262
/
update MainMenuConfig set viewIndex = 5 where infoid = 262
/
update MainMenuInfo set defaultIndex = 6 where id = 263
/
update MainMenuConfig set viewIndex = 6 where infoid = 263
/
update MainMenuInfo set defaultIndex = 7 where id = 264
/
update MainMenuConfig set viewIndex = 7 where infoid = 264
/
update MainMenuInfo set defaultIndex = 8 where id = 265
/
update MainMenuConfig set viewIndex = 8 where infoid = 265
/
update MainMenuInfo set defaultIndex = 9 where id = 266
/
update MainMenuConfig set viewIndex = 9 where infoid = 266
/
update MainMenuInfo set defaultIndex = 10 where id = 267
/
update MainMenuConfig set viewIndex = 10 where infoid = 267
/
update MainMenuInfo set defaultIndex = 11 where id = 268
/
update MainMenuConfig set viewIndex = 11 where infoid = 268
/
update MainMenuInfo set defaultIndex = 12 where id = 269
/
update MainMenuConfig set viewIndex = 12 where infoid = 269
/
update MainMenuInfo set defaultIndex = 13 where id = 521
/
update MainMenuConfig set viewIndex = 13 where infoid = 521
/
update MainMenuInfo set defaultIndex = 14 where id = 270
/
update MainMenuConfig set viewIndex = 14 where infoid = 270
/
update MainMenuInfo set defaultIndex = 15 where id = 522
/
update MainMenuConfig set viewIndex = 15 where infoid = 522
/
update MainMenuInfo set defaultIndex = 16 where id = 598
/
update MainMenuConfig set viewIndex = 16 where infoid = 598
/
update MainMenuInfo set defaultIndex = 17 where id = 599
/
update MainMenuConfig set viewIndex = 17 where infoid = 599
/
update MainMenuInfo set defaultIndex = 18 where id = 600
/
update MainMenuConfig set viewIndex = 18 where infoid = 600
/