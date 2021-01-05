DELETE FROM HtmlLabelIndex WHERE id=19909
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19909
GO
DELETE FROM HtmlLabelIndex WHERE id=19910
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19910
GO

INSERT INTO HtmlLabelIndex values(19909,'维护者') 
GO
INSERT INTO HtmlLabelIndex values(19910,'共享范围') 
GO
INSERT INTO HtmlLabelInfo VALUES(19909,'维护者',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19909,'maintenance person',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19910,'共享范围',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19910,'share area',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19911
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19911
GO

INSERT INTO HtmlLabelIndex values(19911,'共享维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(19911,'共享维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19911,'Share Maint',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19989
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19989
GO

INSERT INTO HtmlLabelIndex values(19989,'显示位置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19989,'显示位置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19989,'Show Lacation',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19997
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19997
GO

INSERT INTO HtmlLabelIndex values(19997,'页面锁定') 
GO
INSERT INTO HtmlLabelInfo VALUES(19997,'页面锁定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19997,'Page Locked',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19999
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19999
GO

INSERT INTO HtmlLabelIndex values(19999,'首页导航栏') 
GO
INSERT INTO HtmlLabelInfo VALUES(19999,'首页导航栏',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19999,'homepage navigate',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20013
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20013
GO

INSERT INTO HtmlLabelIndex values(20013,'前一个首页') 
GO
INSERT INTO HtmlLabelInfo VALUES(20013,'前一个首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20013,'previous homepage',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20014
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20014
GO

INSERT INTO HtmlLabelIndex values(20014,'上级首页') 
GO
INSERT INTO HtmlLabelInfo VALUES(20014,'上级首页',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20014,'Parent Homepage',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20015
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20015
GO
DELETE FROM HtmlLabelIndex WHERE id=20016
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20016
GO

INSERT INTO HtmlLabelIndex values(20016,'二级菜单') 
GO
INSERT INTO HtmlLabelIndex values(20015,'一级菜单') 
GO
INSERT INTO HtmlLabelInfo VALUES(20015,'一级菜单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20015,'Top Menu',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20016,'二级菜单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20016,'Second Menu',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20017
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20017
GO

INSERT INTO HtmlLabelIndex values(20017,'引用地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(20017,'引用地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20017,'Address For Refer',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20018
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20018
GO
DELETE FROM HtmlLabelIndex WHERE id=20019
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20019
GO
DELETE FROM HtmlLabelIndex WHERE id=20020
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20020
GO
DELETE FROM HtmlLabelIndex WHERE id=20021
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20021
GO
DELETE FROM HtmlLabelIndex WHERE id=20022
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20022
GO

INSERT INTO HtmlLabelIndex values(20021,'导航栏选中后字体颜色') 
GO
INSERT INTO HtmlLabelIndex values(20018,'导航栏背景颜色') 
GO
INSERT INTO HtmlLabelIndex values(20020,'导航栏选中后背景颜色') 
GO
INSERT INTO HtmlLabelIndex values(20019,'导航栏字体颜色') 
GO
INSERT INTO HtmlLabelIndex values(20022,'导航栏边框线颜色') 
GO
INSERT INTO HtmlLabelInfo VALUES(20018,'导航栏背景颜色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20018,'Navigate Background Color',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20019,'导航栏字体颜色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20019,'Navigate Background Color',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20020,'导航栏选中后背景颜色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20020,'Navigate Backgorund Color For Selected',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20021,'导航栏选中后字体颜色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20021,'Navigate Color For Selected',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20022,'导航栏边框线颜色',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20022,'Navigate Border Color',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20027
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20027
GO
DELETE FROM HtmlLabelIndex WHERE id=20028
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20028
GO

INSERT INTO HtmlLabelIndex values(20027,'导航栏背景图片') 
GO
INSERT INTO HtmlLabelIndex values(20028,'导航栏选中后背景图片') 
GO
INSERT INTO HtmlLabelInfo VALUES(20027,'导航栏背景图片',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20027,'Navigate Background Image',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20028,'导航栏选中后背景图片',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20028,'Navigate Background Image For Selected',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20048
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20048
GO

INSERT INTO HtmlLabelIndex values(20048,'股票代码') 
GO
INSERT INTO HtmlLabelInfo VALUES(20048,'股票代码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20048,'Stock Code',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20049
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20049
GO
DELETE FROM HtmlLabelIndex WHERE id=20050
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20050
GO

INSERT INTO HtmlLabelIndex values(20049,'多新闻页请用半角分号分开 如(1;2)') 
GO
INSERT INTO HtmlLabelIndex values(20050,'多股票请用半角分号分隔') 
GO
INSERT INTO HtmlLabelInfo VALUES(20049,'多新闻页请用半角分号分开 如(1;2)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20049,'More news page use semicolon',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20050,'多股票请用半角分号分隔',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20050,'More stock use semicolon',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20052
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20052
GO

INSERT INTO HtmlLabelIndex values(20052,'期刊列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(20052,'期刊列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20052,'Magazine List',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=20071
GO
DELETE FROM HtmlLabelInfo WHERE indexid=20071
GO

INSERT INTO HtmlLabelIndex values(20071,'首页显示顺序维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(20071,'首页显示顺序维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20071,'Homepage order maintance',8) 
GO

DELETE FROM HtmlLabelIndex WHERE id=19099
GO
DELETE FROM HtmlLabelInfo WHERE indexid=19099
GO

INSERT INTO HtmlLabelIndex values(19099,'期刊设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19099,'期刊设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19099,'Magazine Set',8) 
GO

insert into SystemRights (id,rightdesc,righttype) values (691,'首页显示顺序维护','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (691,7,'首页显示顺序维护','首页显示顺序维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (691,8,'Homepage order maintance','Homepage order maintance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4199,'首页显示顺序维护','hporder:maint',691) 
GO
insert into SystemRightToGroup (groupid, rightid) values (1,691)
GO

insert into SystemRights (id,rightdesc,righttype) values (453,'期刊设置维护','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (453,8,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (453,7,'期刊设置维护','期刊设置维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3144,'期刊设置维护','WebMagazine:Main',453) 
GO
insert into SystemRightToGroup (groupid, rightid) values (2,453)
GO