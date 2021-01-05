delete from HtmlLabelIndex where id=21558 
GO
delete from HtmlLabelInfo where indexid=21558 
GO
INSERT INTO HtmlLabelIndex values(21558,'执行力平台') 
GO
INSERT INTO HtmlLabelInfo VALUES(21558,'执行力平台',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21558,'Execution Platform',8) 
GO

Delete from LeftMenuInfo where id=643
GO
EXECUTE LMConfig_U_ByInfoInsert 1,0,9
GO
EXECUTE LMInfo_Insert 643,21558,NULL,NULL,1,0,9,9
GO

Delete from LeftMenuInfo where id=644
GO
EXECUTE LMConfig_U_ByInfoInsert 2,643,0
GO
EXECUTE LMInfo_Insert 644,21558,'','/workrelate/Index.jsp',2,643,0,9 
GO

