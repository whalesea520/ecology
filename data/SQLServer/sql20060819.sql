alter table HrmSalaryChange add oldvalue decimal(15,2)
GO
alter table HrmSalaryChange add newvalue decimal(15,2)
GO
EXECUTE MMConfig_U_ByInfoInsert 50,8
GO
EXECUTE MMInfo_Insert 526,19599,'','/hrm/finance/salary/HrmSalaryChange.jsp','mainFrame',50,2,8,0,'',0,'Compensation:Manager',0,'','',0,'','',2
GO

INSERT INTO HtmlLabelIndex values(19599,'薪酬变更') 
GO
INSERT INTO HtmlLabelInfo VALUES(19599,'薪酬变更',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19599,'Salary Changed Log',8) 
GO
INSERT INTO HtmlLabelIndex values(19603,'调整前薪酬') 
GO
INSERT INTO HtmlLabelInfo VALUES(19603,'调整前薪酬',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19603,'Old Salary',8) 
GO
INSERT INTO HtmlLabelIndex values(19604,'调整后薪酬') 
GO
INSERT INTO HtmlLabelInfo VALUES(19604,'调整后薪酬',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19604,'New Salary',8) 
GO