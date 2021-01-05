delete from HtmlLabelIndex where id=21558 
/
delete from HtmlLabelInfo where indexid=21558 
/
INSERT INTO HtmlLabelIndex values(21558,'执行力平台') 
/
INSERT INTO HtmlLabelInfo VALUES(21558,'执行力平台',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21558,'Execution Platform',8) 
/

Delete from LeftMenuInfo where id=643
/
call LMConfig_U_ByInfoInsert (1,0,9)
/
call LMInfo_Insert (643,21558,NULL,NULL,1,0,9,9)
/

Delete from LeftMenuInfo where id=644
/
call LMConfig_U_ByInfoInsert (2,643,0)
/
call LMInfo_Insert (644,21558,'','/workrelate/Index.jsp',2,643,0,9) 
/

