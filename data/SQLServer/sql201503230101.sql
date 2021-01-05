delete from HtmlLabelIndex where id=82644 
GO
delete from HtmlLabelInfo where indexid=82644 
GO
INSERT INTO HtmlLabelIndex values(82644,'上期结余预算数') 
GO
delete from HtmlLabelIndex where id=82645 
GO
delete from HtmlLabelInfo where indexid=82645 
GO
INSERT INTO HtmlLabelIndex values(82645,'本期原预算数') 
GO
INSERT INTO HtmlLabelInfo VALUES(82645,'本期原预算数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82645,'This period the original budget number',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82645,'本期原預算數',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82645,'в этот период число первоначального бюджета',10) 
GO
INSERT INTO HtmlLabelInfo VALUES(82644,'上期结余预算数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82644,'The old balance budget',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82644,'上期結餘預算數',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82644,'профицит бюджета в предыдущий период число',10) 
GO


delete from HtmlLabelIndex where id=82646 
GO
delete from HtmlLabelInfo where indexid=82646 
GO
INSERT INTO HtmlLabelIndex values(82646,'本期原预算数 = 本期预算总数 - 上期结余预算数') 
GO
INSERT INTO HtmlLabelInfo VALUES(82646,'本期原预算数 = 本期预算总数 - 上期结余预算数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82646,'This period the original budget number = current budget total - old balance budget',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82646,'本期原預算數 = 本期預算總數 - 上期結餘預算數',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82646,'в этот период первоначального бюджета в этот период число = общее число - в предыдущий период число бюджетных счетах бюджета',10) 
GO