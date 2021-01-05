delete from HtmlLabelIndex where id=127869 
GO
delete from HtmlLabelInfo where indexid=127869 
GO
INSERT INTO HtmlLabelIndex values(127869,'已发生费用导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(127869,'已发生费用导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127869,'Import costs have occurred',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127869,'已發生費用導入',9) 
GO
Delete from MainMenuInfo where id=10305
GO
EXECUTE MMConfig_U_ByInfoInsert 165,6
GO
EXECUTE MMInfo_Insert 10305,127869,'已发生费用导入','/fna/batch/OccurredExpenseBatch.jsp','mainFrame',165,3,6,0,'',0,'',0,'','',0,'','',6
GO