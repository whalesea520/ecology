delete from HtmlLabelIndex where id=82545 
GO
delete from HtmlLabelInfo where indexid=82545 
GO
INSERT INTO HtmlLabelIndex values(82545,'商机管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(82545,'商机管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82545,'SellChance management',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82545,'商機管理',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82545,'商機管理',10) 
GO

update LeftMenuInfo set labelid=82545  where id=27
GO

delete from HtmlLabelIndex where id=82546 
GO
delete from HtmlLabelInfo where indexid=82546 
GO
INSERT INTO HtmlLabelIndex values(82546,'我的商机') 
GO
INSERT INTO HtmlLabelInfo VALUES(82546,'我的商机',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82546,'My Sellchance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82546,'我的商機',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(82546,'我的商機',10) 
GO

delete from HtmlLabelIndex where id=32922 
GO
delete from HtmlLabelInfo where indexid=32922 
GO
INSERT INTO HtmlLabelIndex values(32922,'商机') 
GO
INSERT INTO HtmlLabelInfo VALUES(32922,'商机',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32922,'Sellchance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32922,'商機',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(32922,'商機',10) 
GO