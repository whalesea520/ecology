ALTER TABLE DocSecCategoryApproveWfDetail ADD
DocSecCategoryTemplateId integer NULL
/

call MMConfig_U_ByInfoInsert (13,5)
/
call MMInfo_Insert (545,19456,'Ä¿Â¼Ä£°æ','/docs/category/DocSecCategoryTmplList.jsp','mainFrame',13,2,5,0,'',0,'',0,'','',0,'','',1)
/