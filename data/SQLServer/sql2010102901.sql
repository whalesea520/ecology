delete from HtmlLabelIndex where id=25211 
GO
delete from HtmlLabelInfo where indexid=25211 
GO
INSERT INTO HtmlLabelIndex values(25211,'资金转入所属机构') 
GO
delete from HtmlLabelIndex where id=25212 
GO
delete from HtmlLabelInfo where indexid=25212 
GO
INSERT INTO HtmlLabelIndex values(25212,'资金转出所属机构') 
GO
INSERT INTO HtmlLabelInfo VALUES(25211,'资金转入所属机构',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25211,'Funds to the sector',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25211,'資金轉入所屬機構',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(25212,'资金转出所属机构',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25212,'Funds out of their organizations',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25212,'資金轉出所屬機構',9) 
GO
