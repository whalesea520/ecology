delete from SystemRights where id = 709
go
delete from SystemRightsLanguage where id = 709
go
delete from SystemRightDetail where rightid = 709
go
insert into SystemRights (id,rightdesc,righttype) values (709,'资产编码设置','7') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (709,7,'资产编码设置','资产编码设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (709,8,'Capital Coding Setting','Capital Coding Setting') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4217,'资产编码设置','CapitalCodingSet:All',709) 
GO

delete from HtmlLabelIndex where id=22289 
GO
delete from HtmlLabelInfo where indexid=22289 
GO
INSERT INTO HtmlLabelIndex values(22289,'分部编号') 
GO
delete from HtmlLabelIndex where id=22290 
GO
delete from HtmlLabelInfo where indexid=22290 
GO
INSERT INTO HtmlLabelIndex values(22290,'部门编号') 
GO
delete from HtmlLabelIndex where id=22291 
GO
delete from HtmlLabelInfo where indexid=22291 
GO
INSERT INTO HtmlLabelIndex values(22291,'资产类型编号') 
GO
delete from HtmlLabelIndex where id=22293 
GO
delete from HtmlLabelInfo where indexid=22293 
GO
INSERT INTO HtmlLabelIndex values(22293,'月（购置日期）') 
GO
delete from HtmlLabelIndex where id=22296 
GO
delete from HtmlLabelInfo where indexid=22296 
GO
INSERT INTO HtmlLabelIndex values(22296,'月（入库日期）') 
GO
delete from HtmlLabelIndex where id=22299 
GO
delete from HtmlLabelInfo where indexid=22299 
GO
INSERT INTO HtmlLabelIndex values(22299,'部门单独流水') 
GO
delete from HtmlLabelIndex where id=22301 
GO
delete from HtmlLabelInfo where indexid=22301 
GO
INSERT INTO HtmlLabelIndex values(22301,'资产类型单独流水') 
GO
delete from HtmlLabelIndex where id=22302 
GO
delete from HtmlLabelInfo where indexid=22302 
GO
INSERT INTO HtmlLabelIndex values(22302,'购置日期单独流水') 
GO
delete from HtmlLabelIndex where id=22294 
GO
delete from HtmlLabelInfo where indexid=22294 
GO
INSERT INTO HtmlLabelIndex values(22294,'日（购置日期）') 
GO
delete from HtmlLabelIndex where id=22295 
GO
delete from HtmlLabelInfo where indexid=22295 
GO
INSERT INTO HtmlLabelIndex values(22295,'年（入库日期）') 
GO
delete from HtmlLabelIndex where id=22297 
GO
delete from HtmlLabelInfo where indexid=22297 
GO
INSERT INTO HtmlLabelIndex values(22297,'日（入库日期）') 
GO
delete from HtmlLabelIndex where id=22298 
GO
delete from HtmlLabelInfo where indexid=22298 
GO
INSERT INTO HtmlLabelIndex values(22298,'分部单独流水') 
GO
delete from HtmlLabelIndex where id=22292 
GO
delete from HtmlLabelInfo where indexid=22292 
GO
INSERT INTO HtmlLabelIndex values(22292,'年（购置日期）') 
GO
delete from HtmlLabelIndex where id=22300 
GO
delete from HtmlLabelInfo where indexid=22300 
GO
INSERT INTO HtmlLabelIndex values(22300,'资产组单独流水') 
GO
delete from HtmlLabelIndex where id=22303 
GO
delete from HtmlLabelInfo where indexid=22303 
GO
INSERT INTO HtmlLabelIndex values(22303,'入库日期单独流水') 
GO
INSERT INTO HtmlLabelInfo VALUES(22289,'分部编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22289,'subcompany code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22289,'分部編號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22290,'部门编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22290,'department code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22290,'部門編號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22291,'资产类型编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22291,'capital type code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22291,'資產類型編號',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22292,'年（购置日期）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22292,'year (buy date)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22292,'年（購置日期）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22293,'月（购置日期）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22293,'month (buy date)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22293,'月（購置日期）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22294,'日（购置日期）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22294,'day(buy date)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22294,'日（購置日期）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22295,'年（入库日期）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22295,'year(Warehousing date)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22295,'年（入庫日期）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22296,'月（入库日期）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22296,'month(Warehousing date)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22296,'月（入庫日期）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22297,'日（入库日期）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22297,'day(Warehousing date)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22297,'日（入庫日期）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22298,'分部单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22298,'subcompany Separate flow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22298,'分部單獨流水',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22299,'部门单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22299,'department independently flow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22299,'部門單獨流水',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22300,'资产组单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22300,'capital group independently flow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22300,'資產組單獨流水',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22301,'资产类型单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22301,'capital type independently flow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22301,'資產類型單獨流水',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22302,'购置日期单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22302,'buy date independently flow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22302,'購置日期單獨流水',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22303,'入库日期单独流水',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22303,'Warehousing date independently flow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22303,'入庫日期單獨流水',9) 
GO
delete from HtmlLabelIndex where id=22336 
GO
delete from HtmlLabelInfo where indexid=22336 
GO
INSERT INTO HtmlLabelIndex values(22336,'付款中') 
GO
delete from HtmlLabelIndex where id=22337 
GO
delete from HtmlLabelInfo where indexid=22337 
GO
INSERT INTO HtmlLabelIndex values(22337,'付款完毕') 
GO
delete from HtmlLabelIndex where id=22335 
GO
delete from HtmlLabelInfo where indexid=22335 
GO
INSERT INTO HtmlLabelIndex values(22335,'合同签订') 
GO
delete from HtmlLabelIndex where id=22334 
GO
delete from HtmlLabelInfo where indexid=22334 
GO
INSERT INTO HtmlLabelIndex values(22334,'请购中') 
GO
delete from HtmlLabelIndex where id=22333 
GO
delete from HtmlLabelInfo where indexid=22333 
GO
INSERT INTO HtmlLabelIndex values(22333,'采购状态') 
GO
INSERT INTO HtmlLabelInfo VALUES(22333,'采购状态',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22333,'purchase state',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22333,'采購狀態',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22334,'请购中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22334,'Please purchase in',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22334,'請購中',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22335,'合同签订',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22335,'Contract',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22335,'合同簽訂',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22336,'付款中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22336,'Payment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22336,'付款中',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22337,'付款完毕',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22337,'Payment finished',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22337,'付款完畢',9) 
GO
delete from HtmlLabelIndex where id=22338 
GO
delete from HtmlLabelInfo where indexid=22338 
GO
INSERT INTO HtmlLabelIndex values(22338,'已付金额') 
GO
INSERT INTO HtmlLabelInfo VALUES(22338,'已付金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22338,'The amount paid',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22338,'已付金額',9) 
GO
delete from HtmlLabelIndex where id=22339 
GO
delete from HtmlLabelInfo where indexid=22339 
GO
INSERT INTO HtmlLabelIndex values(22339,'是否海关监管') 
GO
delete from HtmlLabelIndex where id=22340 
GO
delete from HtmlLabelInfo where indexid=22340 
GO
INSERT INTO HtmlLabelIndex values(22340,'设备功率') 
GO
delete from HtmlLabelIndex where id=22341 
GO
delete from HtmlLabelInfo where indexid=22341 
GO
INSERT INTO HtmlLabelIndex values(22341,'附属设备') 
GO
INSERT INTO HtmlLabelInfo VALUES(22339,'是否海关监管',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22339,'Whether the customs supervision',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22339,'是否海關監管',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22340,'设备功率',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22340,'Power equipment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22340,'設備功率',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22341,'附属设备',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22341,'Ancillary equipment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22341,'附屬設備',9) 
GO
delete from HtmlLabelIndex where id=22343 
GO
delete from HtmlLabelInfo where indexid=22343 
GO
INSERT INTO HtmlLabelIndex values(22343,'技术资料') 
GO
INSERT INTO HtmlLabelInfo VALUES(22343,'技术资料',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22343,'Technical information',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22343,'技術資料',9) 
GO
delete from HtmlLabelIndex where id=22342 
GO
delete from HtmlLabelInfo where indexid=22342 
GO
INSERT INTO HtmlLabelIndex values(22342,'备品配件') 
GO
INSERT INTO HtmlLabelInfo VALUES(22342,'备品配件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22342,'Spare parts',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22342,'備品配件',9) 
GO
delete from HtmlLabelIndex where id=22349 
GO
delete from HtmlLabelInfo where indexid=22349 
GO
INSERT INTO HtmlLabelIndex values(22349,'功率') 
GO
delete from HtmlLabelIndex where id=22350 
GO
delete from HtmlLabelInfo where indexid=22350 
GO
INSERT INTO HtmlLabelIndex values(22350,'电压') 
GO
INSERT INTO HtmlLabelInfo VALUES(22349,'功率',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22349,'Power',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22349,'功率',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22350,'电压',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22350,'Voltage',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22350,'電壓',9) 
GO
delete from HtmlLabelIndex where id=22351 
GO
delete from HtmlLabelInfo where indexid=22351 
GO
INSERT INTO HtmlLabelIndex values(22351,'总重量') 
GO
delete from HtmlLabelIndex where id=22352 
GO
delete from HtmlLabelInfo where indexid=22352 
GO
INSERT INTO HtmlLabelIndex values(22352,'尺寸') 
GO
INSERT INTO HtmlLabelInfo VALUES(22351,'总重量',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22351,'Total weight',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22351,'總重量',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22352,'尺寸',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22352,'Size',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22352,'尺寸',9) 
GO
delete from HtmlLabelIndex where id=21282 
GO
delete from HtmlLabelInfo where indexid=21282 
GO
INSERT INTO HtmlLabelIndex values(21282,'合同号') 
GO
INSERT INTO HtmlLabelInfo VALUES(21282,'合同号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21282,'Contract No.',8) 
GO

delete from SystemRights where id = 817
go
delete from SystemRightsLanguage where id = 817
go
delete from SystemRightDetail where rightid = 817
go
insert into SystemRights (id,rightdesc,righttype) values (817,'资产查询定义','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (817,9,'資產查詢定義','資產查詢定義') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (817,7,'资产查询定义','资产查询定义') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (817,8,'The definition of assets inquiry','The definition of assets inquiry') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4328,'资产查询定义','cptdefinition:all',817) 
GO

delete from HtmlLabelIndex where id=22366 
GO
delete from HtmlLabelInfo where indexid=22366 
GO
INSERT INTO HtmlLabelIndex values(22366,'资产查询定义') 
GO
INSERT INTO HtmlLabelInfo VALUES(22366,'资产查询定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22366,'The definition of assets inquiry',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22366,'資產查詢定義',9) 
GO
delete from HtmlLabelIndex where id=22390 
GO
delete from HtmlLabelInfo where indexid=22390 
GO
INSERT INTO HtmlLabelIndex values(22390,'是否使用该字段作为查询条件或列表标题') 
GO
delete from HtmlLabelIndex where id=22393 
GO
delete from HtmlLabelInfo where indexid=22393 
GO
INSERT INTO HtmlLabelIndex values(22393,'是否作为高级查询条件') 
GO
delete from HtmlLabelIndex where id=22394 
GO
delete from HtmlLabelInfo where indexid=22394 
GO
INSERT INTO HtmlLabelIndex values(22394,'标题显示顺序') 
GO
delete from HtmlLabelIndex where id=22392 
GO
delete from HtmlLabelInfo where indexid=22392 
GO
INSERT INTO HtmlLabelIndex values(22392,'是否作为搜索条件') 
GO
delete from HtmlLabelIndex where id=22391 
GO
delete from HtmlLabelInfo where indexid=22391 
GO
INSERT INTO HtmlLabelIndex values(22391,'是否列表标题') 
GO
INSERT INTO HtmlLabelInfo VALUES(22390,'是否使用该字段作为查询条件或列表标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22390,'Whether or not to use the field as a query or a list of headings',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22390,'是否使用該字段作為查詢條件或列表標題',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22391,'是否列表标题',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22391,'Whether the list of title',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22391,'是否列表標題',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22392,'是否作为搜索条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22392,'Whether as a search criteria',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22392,'是否作為搜索條件',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22393,'是否作为高级查询条件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22393,'Whether as a senior query',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22393,'是否作為高級查詢條件',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22394,'标题显示顺序',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22394,'The title of the display order',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22394,'標題顯示順序',9) 
GO
delete from HtmlLabelIndex where id=22396 
GO
delete from HtmlLabelInfo where indexid=22396 
GO
INSERT INTO HtmlLabelIndex values(22396,'是否系统生成资产编码') 
GO
INSERT INTO HtmlLabelInfo VALUES(22396,'是否系统生成资产编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22396,'Whether the system-generated asset coding',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22396,'是否系統生成資產編碼',9) 
GO

delete from HtmlLabelIndex where id=22315 
GO
delete from HtmlLabelInfo where indexid=22315 
GO
INSERT INTO HtmlLabelIndex values(22315,'资产资料维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(22315,'资产资料维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22315,'Maintenance of asset information',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22315,'資產資料維護',9) 
GO


delete from SystemRights where id =818
GO
delete from SystemRightsLanguage where id =818
GO
delete from SystemRightDetail where id =4329
GO
insert into SystemRights (id,rightdesc,righttype) values (818,'资产变更维护','0') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (818,8,'Changes in the maintenance of assets','Changes in the maintenance of assets') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (818,9,'資產變更維護','資產變更維護') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (818,7,'资产变更维护','资产变更维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4329,'资产变更','CptCapital:modify',818) 
GO

delete from HtmlLabelIndex where id=21922 
GO
delete from HtmlLabelInfo where indexid=21922 
GO
INSERT INTO HtmlLabelIndex values(21922,'点击左边分部对该分部进行操作') 
GO
INSERT INTO HtmlLabelInfo VALUES(21922,'点击左边分部对该分部进行操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21922,'Click on the left branch of the Division for operations',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21922,'點擊左邊分部對該分部進行操作',9) 
GO

delete from HtmlLabelIndex where id=22357 
GO
delete from HtmlLabelInfo where indexid=22357 
GO
INSERT INTO HtmlLabelIndex values(22357,'新建资产资料') 
GO
INSERT INTO HtmlLabelInfo VALUES(22357,'新建资产资料',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22357,'New assets',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22357,'新建資產資料',9) 
GO

delete from HtmlLabelIndex where id=22457 
GO
delete from HtmlLabelInfo where indexid=22457 
GO
INSERT INTO HtmlLabelIndex values(22457,'维修期限') 
GO
INSERT INTO HtmlLabelInfo VALUES(22457,'维修期限',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22457,'Repair period',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22457,'維修期限',9) 
GO
delete from HtmlLabelIndex where id=22459 
GO
delete from HtmlLabelInfo where indexid=22459 
GO
INSERT INTO HtmlLabelIndex values(22459,'资产送修') 
GO
INSERT INTO HtmlLabelInfo VALUES(22459,'资产送修',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22459,'Asset repair',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22459,'資產送修',9) 
GO