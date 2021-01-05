Delete HtmlLabelIndex where id in(19410,20482,19490)
/
Delete HtmlLabelInfo where indexid in(19410,20482,19490)
/
INSERT INTO HtmlLabelIndex values(19410,'虚拟目录设置') 
/
INSERT INTO HtmlLabelIndex values(20482,'虚拟目录') 
/
INSERT INTO HtmlLabelIndex values(19490,'虚拟目录显示') 
/
INSERT INTO HtmlLabelInfo VALUES(19410,'虚拟目录设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19410,'dummy catalog Setting',8) 
/
INSERT INTO HtmlLabelInfo VALUES(19490,'虚拟目录显示',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19490,'View by dummy catalog',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20482,'虚拟目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20482,'dummy catalog',8) 
/


Delete HtmlLabelIndex where id=20484
/
Delete HtmlLabelInfo where indexid=20484
/

INSERT INTO HtmlLabelIndex values(20484,'导入文档') 
/
INSERT INTO HtmlLabelInfo VALUES(20484,'导入文档',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20484,'Input Docs',8) 
/


Delete HtmlLabelIndex where id=20485
/
Delete HtmlLabelInfo where indexid=20485
/
Delete HtmlLabelIndex where id=20486
/
Delete HtmlLabelInfo where indexid=20486
/

INSERT INTO HtmlLabelIndex values(20485,'导入选中结果到虚拟目录') 
/
INSERT INTO HtmlLabelIndex values(20486,'导入全部结果到虚拟目录') 
/
INSERT INTO HtmlLabelInfo VALUES(20485,'导入选中结果到虚拟目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20485,'Import Seleted To Dummy Catelog',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20486,'导入全部结果到虚拟目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20486,'Import All To Dummy Catelog',8) 
/


Delete HtmlLabelIndex where id=20487
/
Delete HtmlLabelInfo where indexid=20487
/

INSERT INTO HtmlLabelIndex values(20487,'导入到虚拟目录') 
/
INSERT INTO HtmlLabelInfo VALUES(20487,'导入到虚拟目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20487,'Import To Dummy Catelog',8) 
/


Delete HtmlLabelIndex where id=19485
/
Delete HtmlLabelInfo where indexid=19485
/
INSERT INTO HtmlLabelIndex values(19485,'虚拟目录字段') 
/
INSERT INTO HtmlLabelInfo VALUES(19485,'虚拟目录字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19485,'Dummy Catelog Field',8) 
/

Delete HtmlLabelIndex where id=19414
/
Delete HtmlLabelInfo where indexid=19414
/
INSERT INTO HtmlLabelIndex values(19414,'系统不支持10层以上的虚拟目录！') 
/
INSERT INTO HtmlLabelInfo VALUES(19414,'系统不支持10层以上的虚拟目录！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19414,'The system doesn''t support 10 level of dummy catelog field!',8) 
/


Delete HtmlLabelIndex where id=20497
/
Delete HtmlLabelInfo where indexid=20497
/
Delete HtmlLabelIndex where id=20498
/
Delete HtmlLabelInfo where indexid=20498
/
INSERT INTO HtmlLabelIndex values(20497,'允许使用虚拟目录') 
/
INSERT INTO HtmlLabelInfo VALUES(20497,'允许使用虚拟目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20497,'Allow To Use Dummy Catalog',8) 
/
INSERT INTO HtmlLabelIndex values(20498,'默认虚拟目录') 
/
INSERT INTO HtmlLabelInfo VALUES(20498,'默认虚拟目录',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20498,'Defualt Dummy Catalog',8) 
/

Delete HtmlLabelIndex where id=19133
/
Delete HtmlLabelInfo where indexid=19133
/
INSERT INTO HtmlLabelIndex values(19133,'移出') 
/
INSERT INTO HtmlLabelInfo VALUES(19133,'移出',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19133,'Remove',8) 
/

Delete HtmlLabelIndex where id=20515
/
Delete HtmlLabelInfo where indexid=20515
/
INSERT INTO HtmlLabelIndex values(20515,'导入时间') 
/
INSERT INTO HtmlLabelInfo VALUES(20515,'导入时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20515,'Import Date',8) 
/
Delete HtmlLabelIndex where id=20516
/
Delete HtmlLabelInfo where indexid=20516
/
Delete HtmlLabelIndex where id=20517
/
Delete HtmlLabelInfo where indexid=20517
/
INSERT INTO HtmlLabelIndex values(20517,'已发布') 
/
INSERT INTO HtmlLabelIndex values(20516,'未发布') 
/
INSERT INTO HtmlLabelInfo VALUES(20516,'未发布',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20516,'No Public',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20517,'已发布',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20517,'Publiced',8) 
/


delete HtmlLabelIndex where id=20551
/
delete HtmlLabelInfo where indexid=20551
/
INSERT INTO HtmlLabelIndex values(20551,'没有选择任何数据!') 
/
INSERT INTO HtmlLabelInfo VALUES(20551,'没有选择任何数据!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20551,'None has been selected!',8) 
/

delete HtmlLabelIndex where id=20552
/
delete HtmlLabelInfo where indexid=20552
/
INSERT INTO HtmlLabelIndex values(20552,'该虚拟目录已经被引用,不能进行删除') 
/
INSERT INTO HtmlLabelInfo VALUES(20552,'该虚拟目录已经被引用,不能进行删除',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20552,'This dummy catagory is been used,Can not delete!',8) 
/

insert into SystemRights (id,rightdesc,righttype) values (716,'虚拟目录','1') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (716,8,'Dummy Category','Dummy Category') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (716,7,'虚拟目录','虚拟目录') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4224,'虚拟目录维护','DummyCata:Maint',716) 
/