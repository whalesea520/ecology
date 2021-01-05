DELETE FROM MainMenuConfig WHERE infoid = 545
/
DELETE FROM MainMenuInfo WHERE id = 545
/
CALL MMConfig_U_ByInfoInsert (2,2)
/
CALL MMInfo_Insert (560,19456,'Ä¿Â¼Ä£°æ','/docs/cate/ry/DocSecCate/ryTmplList.jsp','mainFrame',2,1,2,0,'',0,'',0,'','',0,'','',1)
/
