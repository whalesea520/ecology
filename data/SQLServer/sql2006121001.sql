delete from HtmlLabelIndex where id=19665
GO
delete from HtmlLabelInfo where indexid=19665
GO

INSERT INTO HtmlLabelIndex values(19665,'Interface Setting')
GO
INSERT INTO HtmlLabelInfo VALUES(19665,'接口设置',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19665,'Interface Setting',8)
GO

delete from HtmlLabelIndex where id>=19900 and id<=19906
GO
delete from HtmlLabelInfo where indexid>=19900 and indexid<=19906
GO

INSERT INTO HtmlLabelIndex values(19900,'其它系统')
GO
INSERT INTO HtmlLabelIndex values(19904,'项目管理系统')
GO
INSERT INTO HtmlLabelIndex values(19902,'档案管理系统')
GO
INSERT INTO HtmlLabelIndex values(19903,'售楼管理系统')
GO
INSERT INTO HtmlLabelIndex values(19905,'项目流程提醒')
GO
INSERT INTO HtmlLabelIndex values(19906,'集成帐号设置')
GO
INSERT INTO HtmlLabelIndex values(19901,'金蝶e-hr系统')
GO
INSERT INTO HtmlLabelInfo VALUES(19900,'其它系统',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19900,'other systems',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19901,'金蝶e-hr系统',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19901,'Kingdee ehr system',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19902,'档案管理系统',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19902,'document management system',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19903,'售楼管理系统',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19903,'Estate management system',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19904,'项目管理系统',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19904,'Project management system',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19905,'项目流程提醒',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19905,'Project workflow remind',8)
GO
INSERT INTO HtmlLabelInfo VALUES(19906,'集成帐号设置',7)
GO
INSERT INTO HtmlLabelInfo VALUES(19906,'Integration account setting',8)
GO
