delete from HtmlLabelIndex where id=128474 
GO
delete from HtmlLabelInfo where indexid=128474 
GO
INSERT INTO HtmlLabelIndex values(128474,'是否要重新初始化预算科目？重新初始化科目将删除所有现有科目！') 
GO
delete from HtmlLabelIndex where id=128475 
GO
delete from HtmlLabelInfo where indexid=128475 
GO
INSERT INTO HtmlLabelIndex values(128475,'不能初始化科目') 
GO
INSERT INTO HtmlLabelInfo VALUES(128475,'不能初始化科目',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128475,'Failed to initialize the account',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128475,'不能初始化科目',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128474,'是否要重新初始化预算科目？重新初始化科目将删除所有现有科目！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128474,'Do you want to re initialize the budget account? Re initialization of the account will remove all existing accounts!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128474,'是否要重新初始化預算科目？重新初始化科目将删除所有現有科目！',9) 
GO