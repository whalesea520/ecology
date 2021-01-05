INSERT INTO HtmlLabelIndex values(18899,'你确定要结束吗？') 
GO
INSERT INTO HtmlLabelIndex values(18900,'你确定要重新打开吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(18899,'你确定要结束吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18899,'Are you sure to end it?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18900,'你确定要重新打开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18900,'Are you sure to reopen it?',8) 
GO

INSERT INTO HtmlLabelIndex values(19076,'结束这个协作') 
GO
INSERT INTO HtmlLabelIndex values(19077,'重新打开这个协作') 
GO
INSERT INTO HtmlLabelInfo VALUES(19076,'结束这个协作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19076,'End this cowork',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19077,'重新打开这个协作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19077,'Reopen this cowork',8) 
GO

update htmllabelinfo set labelname='Mail Send Successfully' where indexid=2044 and languageid=8
GO
update htmllabelinfo set labelname='Mail Send Failed' where indexid=2045 and languageid=8
GO

INSERT INTO HtmlLabelIndex values(19004,'联系人还没保存，真的要离开吗？') 
GO
INSERT INTO HtmlLabelIndex values(19005,'销售机会还没保存，真的要离开吗？') 
GO
INSERT INTO HtmlLabelIndex values(19006,'文档还没保存，真的要离开吗？') 
GO
INSERT INTO HtmlLabelIndex values(19007,'文档保存错误！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19004,'联系人还没保存，真的要离开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19004,'Contacter is not saved,sure to leave now?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19005,'销售机会还没保存，真的要离开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19005,'Sell chance is not saved,sure to leave now?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19006,'文档还没保存，真的要离开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19006,'Doc is not saved,sure to leave now?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19007,'文档保存错误！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19007,'Doc saved error!',8) 
GO

delete from HtmlLabelInfo where indexid=17529 and languageid=8
GO
INSERT INTO HtmlLabelInfo VALUES(17529,'Level Batch Change',8) 
GO
delete from HtmlLabelInfo where indexid=17530 and languageid=8
GO
INSERT INTO HtmlLabelInfo VALUES(17530,'Up Level',8) 
GO
delete from HtmlLabelInfo where indexid=17531 and languageid=8
GO
INSERT INTO HtmlLabelInfo VALUES(17531,'Down Level',8) 
GO

INSERT INTO HtmlLabelIndex values(19067,'系统管理用户不具有个人信息') 
GO
INSERT INTO HtmlLabelIndex values(19066,'你所查看的用户为系统管理用户') 
GO
INSERT INTO HtmlLabelInfo VALUES(19066,'你所查看的用户为系统管理用户',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19066,'The user you viewed is system administrator',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19067,'系统管理用户不具有个人信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19067,'System adminnistrator does not have personal information',8) 
GO

INSERT INTO HtmlLabelIndex values(19065,'你没有选中任何文档！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19065,'你没有选中任何文档！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19065,'You do not choose any doc!',8) 
GO

update HtmlLabelInfo set labelname='Documents Replied to Other''s Subject' where indexid=18490 and languageid=8
GO
update HtmlLabelInfo set labelname='Documents Replied' where indexid=18491 and languageid=8
GO

INSERT INTO HtmlLabelIndex values(19068,'登录页模板维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(19068,'登录页模板维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19068,'Login Page Template Maintenance',8) 
GO

INSERT INTO HtmlLabelIndex values(19069,'登录页模板名称') 
GO
INSERT INTO HtmlLabelInfo VALUES(19069,'登录页模板名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19069,'Login Page Template Name',8) 
GO

INSERT INTO HtmlLabelIndex values(19070,'登录页窗口标题') 
GO
INSERT INTO HtmlLabelInfo VALUES(19070,'登录页窗口标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19070,'Login Page Window Title',8) 
GO

INSERT INTO HtmlLabelIndex values(19071,'模式') 
GO
INSERT INTO HtmlLabelInfo VALUES(19071,'模式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19071,'Mode',8) 
GO

INSERT INTO HtmlLabelIndex values(19072,'横向') 
GO
INSERT INTO HtmlLabelInfo VALUES(19072,'横向',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19072,'Transverse',8) 
GO

INSERT INTO HtmlLabelIndex values(19073,'纵向') 
GO
INSERT INTO HtmlLabelInfo VALUES(19073,'纵向',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19073,'Vertical',8) 
GO

INSERT INTO HtmlLabelIndex values(19074,'背景图片') 
GO
INSERT INTO HtmlLabelInfo VALUES(19074,'背景图片',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19074,'Background Picture',8) 
GO

INSERT INTO HtmlLabelIndex values(19075,'最佳大小') 
GO
INSERT INTO HtmlLabelInfo VALUES(19075,'最佳大小',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19075,'Best Fit',8) 
GO

INSERT INTO HtmlLabelIndex values(18795,'窗口标题') 
GO
INSERT INTO HtmlLabelInfo VALUES(18795,'窗口标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18795,'Window Title',8) 
GO