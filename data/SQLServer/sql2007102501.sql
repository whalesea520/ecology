delete HtmlLabelIndex where id=20891
GO
delete HtmlLabelInfo where indexid=20891
GO
INSERT INTO HtmlLabelIndex values(20891,'职务说明')
GO
INSERT INTO HtmlLabelInfo VALUES(20891,'职务说明',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20891,'job explain',8)
GO

delete HtmlLabelIndex where id=20892
GO
delete HtmlLabelInfo where indexid=20892
GO
INSERT INTO HtmlLabelIndex values(20892,'岗位说明')
GO
INSERT INTO HtmlLabelInfo VALUES(20892,'岗位说明',7)
GO
INSERT INTO HtmlLabelInfo VALUES(20892,'job titles explain',8)
GO

delete from HtmlLabelIndex where id=20904
GO
delete from HtmlLabelInfo where indexid=20904
GO
INSERT INTO HtmlLabelIndex values(20904,'服务器正在处理数据导入，请稍候...') 
GO
INSERT INTO HtmlLabelInfo VALUES(20904,'服务器正在处理数据导入，请稍候...',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20904,'the data is being importing,please wait...',8)
GO

delete from HtmlLabelIndex where id=20951 
GO
delete from HtmlLabelInfo where indexid=20951 
GO
INSERT INTO HtmlLabelIndex values(20951,'归属部门') 
GO
INSERT INTO HtmlLabelInfo VALUES(20951,'归属部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20951,'which department belongs to',8) 
GO

delete from HtmlLabelIndex where id=20959 
GO
delete from HtmlLabelInfo where indexid=20959
GO
INSERT INTO HtmlLabelIndex values(20959,'工资平衡表')
GO
INSERT INTO HtmlLabelInfo VALUES(20959,'工资平衡表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20959,'salary balance report',8)
GO