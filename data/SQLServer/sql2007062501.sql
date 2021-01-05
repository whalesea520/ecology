Delete HtmlLabelIndex where id in(19410,20482,19490)
Go
Delete HtmlLabelInfo where indexid in(19410,20482,19490)
Go
INSERT INTO HtmlLabelIndex values(19410,'虚拟目录设置') 
GO
INSERT INTO HtmlLabelIndex values(20482,'虚拟目录') 
GO
INSERT INTO HtmlLabelIndex values(19490,'虚拟目录显示') 
GO
INSERT INTO HtmlLabelInfo VALUES(19410,'虚拟目录设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19410,'dummy catalog Setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19490,'虚拟目录显示',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19490,'View by dummy catalog',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20482,'虚拟目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20482,'dummy catalog',8) 
GO

Delete HtmlLabelIndex where id=20484
Go
Delete HtmlLabelInfo where indexid=20484
Go

INSERT INTO HtmlLabelIndex values(20484,'导入文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(20484,'导入文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20484,'Input Docs',8) 
GO


Delete HtmlLabelIndex where id=20485
Go
Delete HtmlLabelInfo where indexid=20485
Go
Delete HtmlLabelIndex where id=20486
Go
Delete HtmlLabelInfo where indexid=20486
Go

INSERT INTO HtmlLabelIndex values(20485,'导入选中结果到虚拟目录') 
GO
INSERT INTO HtmlLabelIndex values(20486,'导入全部结果到虚拟目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(20485,'导入选中结果到虚拟目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20485,'Import Seleted To Dummy Catelog',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20486,'导入全部结果到虚拟目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20486,'Import All To Dummy Catelog',8) 
GO


Delete HtmlLabelIndex where id=20487
Go
Delete HtmlLabelInfo where indexid=20487
Go

INSERT INTO HtmlLabelIndex values(20487,'导入到虚拟目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(20487,'导入到虚拟目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20487,'Import To Dummy Catelog',8) 
GO


Delete HtmlLabelIndex where id=19485
Go
Delete HtmlLabelInfo where indexid=19485
Go
INSERT INTO HtmlLabelIndex values(19485,'虚拟目录字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(19485,'虚拟目录字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19485,'Dummy Catelog Field',8) 
GO

Delete HtmlLabelIndex where id=19414
Go
Delete HtmlLabelInfo where indexid=19414
Go
INSERT INTO HtmlLabelIndex values(19414,'系统不支持10层以上的虚拟目录！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19414,'系统不支持10层以上的虚拟目录！',7) 
GO

Delete HtmlLabelIndex where id=20497
Go
Delete HtmlLabelInfo where indexid=20497
Go
Delete HtmlLabelIndex where id=20498
Go
Delete HtmlLabelInfo where indexid=20498
Go
INSERT INTO HtmlLabelIndex values(20497,'允许使用虚拟目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(20497,'允许使用虚拟目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20497,'Allow To Use Dummy Catalog',8) 
GO
INSERT INTO HtmlLabelIndex values(20498,'默认虚拟目录') 
GO
INSERT INTO HtmlLabelInfo VALUES(20498,'默认虚拟目录',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20498,'Defualt Dummy Catalog',8) 
GO

Delete HtmlLabelIndex where id=19133
Go
Delete HtmlLabelInfo where indexid=19133
Go
INSERT INTO HtmlLabelIndex values(19133,'移出') 
GO
INSERT INTO HtmlLabelInfo VALUES(19133,'移出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19133,'Remove',8) 
GO

Delete HtmlLabelIndex where id=20515
Go
Delete HtmlLabelInfo where indexid=20515
Go
INSERT INTO HtmlLabelIndex values(20515,'导入时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(20515,'导入时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20515,'Import Date',8) 

GO
Delete HtmlLabelIndex where id=20516
Go
Delete HtmlLabelInfo where indexid=20516
Go
Delete HtmlLabelIndex where id=20517
Go
Delete HtmlLabelInfo where indexid=20517
Go
INSERT INTO HtmlLabelIndex values(20517,'已发布') 
GO
INSERT INTO HtmlLabelIndex values(20516,'未发布') 
GO
INSERT INTO HtmlLabelInfo VALUES(20516,'未发布',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20516,'No Public',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20517,'已发布',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20517,'Publiced',8) 
GO
delete HtmlLabelIndex where id=20551
GO
delete HtmlLabelInfo where indexid=20551
GO
INSERT INTO HtmlLabelIndex values(20551,'没有选择任何数据!') 
GO
INSERT INTO HtmlLabelInfo VALUES(20551,'没有选择任何数据!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20551,'None has been selected!',8) 
GO

delete HtmlLabelIndex where id=20552
GO
delete HtmlLabelInfo where indexid=20552
GO
INSERT INTO HtmlLabelIndex values(20552,'该虚拟目录已经被引用,不能进行删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(20552,'该虚拟目录已经被引用,不能进行删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20552,'This dummy catagory is been used,Can not delete!',8) 
GO

insert into SystemRights (id,rightdesc,righttype) values (716,'虚拟目录','1') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (716,8,'Dummy Category','Dummy Category') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (716,7,'虚拟目录','虚拟目录') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4224,'虚拟目录维护','DummyCata:Maint',716) 
GO