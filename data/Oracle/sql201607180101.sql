delete from HtmlLabelIndex where id=127869 
/
delete from HtmlLabelInfo where indexid=127869 
/
INSERT INTO HtmlLabelIndex values(127869,'�ѷ������õ���') 
/
INSERT INTO HtmlLabelInfo VALUES(127869,'�ѷ������õ���',7) 
/
INSERT INTO HtmlLabelInfo VALUES(127869,'Import costs have occurred',8) 
/
INSERT INTO HtmlLabelInfo VALUES(127869,'�Ѱl���M�Ì���',9) 
/
Delete from MainMenuInfo where id=10305
/
call MMConfig_U_ByInfoInsert (165,6)
/
call MMInfo_Insert (10305,127869,'�ѷ������õ���','/fna/batch/OccurredExpenseBatch.jsp','mainFrame',165,3,6,0,'',0,'',0,'','',0,'','',6)
/