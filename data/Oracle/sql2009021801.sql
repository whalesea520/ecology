delete from SystemRights where id = 709
/
delete from SystemRightsLanguage where id = 709
/
delete from SystemRightDetail where rightid = 709
/
insert into SystemRights (id,rightdesc,righttype) values (709,'资产编码设置','7') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (709,7,'资产编码设置','资产编码设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (709,8,'Capital Coding Setting','Capital Coding Setting') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4217,'资产编码设置','CapitalCodingSet:All',709) 
/

delete from HtmlLabelIndex where id=22289 
/
delete from HtmlLabelInfo where indexid=22289 
/
INSERT INTO HtmlLabelIndex values(22289,'分部编号') 
/
delete from HtmlLabelIndex where id=22290 
/
delete from HtmlLabelInfo where indexid=22290 
/
INSERT INTO HtmlLabelIndex values(22290,'部门编号') 
/
delete from HtmlLabelIndex where id=22291 
/
delete from HtmlLabelInfo where indexid=22291 
/
INSERT INTO HtmlLabelIndex values(22291,'资产类型编号') 
/
delete from HtmlLabelIndex where id=22293 
/
delete from HtmlLabelInfo where indexid=22293 
/
INSERT INTO HtmlLabelIndex values(22293,'月（购置日期）') 
/
delete from HtmlLabelIndex where id=22296 
/
delete from HtmlLabelInfo where indexid=22296 
/
INSERT INTO HtmlLabelIndex values(22296,'月（入库日期）') 
/
delete from HtmlLabelIndex where id=22299 
/
delete from HtmlLabelInfo where indexid=22299 
/
INSERT INTO HtmlLabelIndex values(22299,'部门单独流水') 
/
delete from HtmlLabelIndex where id=22301 
/
delete from HtmlLabelInfo where indexid=22301 
/
INSERT INTO HtmlLabelIndex values(22301,'资产类型单独流水') 
/
delete from HtmlLabelIndex where id=22302 
/
delete from HtmlLabelInfo where indexid=22302 
/
INSERT INTO HtmlLabelIndex values(22302,'购置日期单独流水') 
/
delete from HtmlLabelIndex where id=22294 
/
delete from HtmlLabelInfo where indexid=22294 
/
INSERT INTO HtmlLabelIndex values(22294,'日（购置日期）') 
/
delete from HtmlLabelIndex where id=22295 
/
delete from HtmlLabelInfo where indexid=22295 
/
INSERT INTO HtmlLabelIndex values(22295,'年（入库日期）') 
/
delete from HtmlLabelIndex where id=22297 
/
delete from HtmlLabelInfo where indexid=22297 
/
INSERT INTO HtmlLabelIndex values(22297,'日（入库日期）') 
/
delete from HtmlLabelIndex where id=22298 
/
delete from HtmlLabelInfo where indexid=22298 
/
INSERT INTO HtmlLabelIndex values(22298,'分部单独流水') 
/
delete from HtmlLabelIndex where id=22292 
/
delete from HtmlLabelInfo where indexid=22292 
/
INSERT INTO HtmlLabelIndex values(22292,'年（购置日期）') 
/
delete from HtmlLabelIndex where id=22300 
/
delete from HtmlLabelInfo where indexid=22300 
/
INSERT INTO HtmlLabelIndex values(22300,'资产组单独流水') 
/
delete from HtmlLabelIndex where id=22303 
/
delete from HtmlLabelInfo where indexid=22303 
/
INSERT INTO HtmlLabelIndex values(22303,'入库日期单独流水') 
/
INSERT INTO HtmlLabelInfo VALUES(22289,'分部编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22289,'subcompany code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22289,'分部編號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22290,'部门编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22290,'department code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22290,'部門編號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22291,'资产类型编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22291,'capital type code',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22291,'資產類型編號',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22292,'年（购置日期）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22292,'year (buy date)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22292,'年（購置日期）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22293,'月（购置日期）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22293,'month (buy date)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22293,'月（購置日期）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22294,'日（购置日期）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22294,'day(buy date)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22294,'日（購置日期）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22295,'年（入库日期）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22295,'year(Warehousing date)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22295,'年（入庫日期）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22296,'月（入库日期）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22296,'month(Warehousing date)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22296,'月（入庫日期）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22297,'日（入库日期）',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22297,'day(Warehousing date)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22297,'日（入庫日期）',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22298,'分部单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22298,'subcompany Separate flow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22298,'分部單獨流水',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22299,'部门单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22299,'department independently flow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22299,'部門單獨流水',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22300,'资产组单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22300,'capital group independently flow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22300,'資產組單獨流水',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22301,'资产类型单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22301,'capital type independently flow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22301,'資產類型單獨流水',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22302,'购置日期单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22302,'buy date independently flow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22302,'購置日期單獨流水',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22303,'入库日期单独流水',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22303,'Warehousing date independently flow',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22303,'入庫日期單獨流水',9) 
/
delete from HtmlLabelIndex where id=22336 
/
delete from HtmlLabelInfo where indexid=22336 
/
INSERT INTO HtmlLabelIndex values(22336,'付款中') 
/
delete from HtmlLabelIndex where id=22337 
/
delete from HtmlLabelInfo where indexid=22337 
/
INSERT INTO HtmlLabelIndex values(22337,'付款完毕') 
/
delete from HtmlLabelIndex where id=22335 
/
delete from HtmlLabelInfo where indexid=22335 
/
INSERT INTO HtmlLabelIndex values(22335,'合同签订') 
/
delete from HtmlLabelIndex where id=22334 
/
delete from HtmlLabelInfo where indexid=22334 
/
INSERT INTO HtmlLabelIndex values(22334,'请购中') 
/
delete from HtmlLabelIndex where id=22333 
/
delete from HtmlLabelInfo where indexid=22333 
/
INSERT INTO HtmlLabelIndex values(22333,'采购状态') 
/
INSERT INTO HtmlLabelInfo VALUES(22333,'采购状态',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22333,'purchase state',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22333,'采購狀態',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22334,'请购中',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22334,'Please purchase in',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22334,'請購中',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22335,'合同签订',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22335,'Contract',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22335,'合同簽訂',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22336,'付款中',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22336,'Payment',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22336,'付款中',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22337,'付款完毕',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22337,'Payment finished',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22337,'付款完畢',9) 
/
delete from HtmlLabelIndex where id=22338 
/
delete from HtmlLabelInfo where indexid=22338 
/
INSERT INTO HtmlLabelIndex values(22338,'已付金额') 
/
INSERT INTO HtmlLabelInfo VALUES(22338,'已付金额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22338,'The amount paid',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22338,'已付金額',9) 
/
delete from HtmlLabelIndex where id=22339 
/
delete from HtmlLabelInfo where indexid=22339 
/
INSERT INTO HtmlLabelIndex values(22339,'是否海关监管') 
/
delete from HtmlLabelIndex where id=22340 
/
delete from HtmlLabelInfo where indexid=22340 
/
INSERT INTO HtmlLabelIndex values(22340,'设备功率') 
/
delete from HtmlLabelIndex where id=22341 
/
delete from HtmlLabelInfo where indexid=22341 
/
INSERT INTO HtmlLabelIndex values(22341,'附属设备') 
/
INSERT INTO HtmlLabelInfo VALUES(22339,'是否海关监管',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22339,'Whether the customs supervision',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22339,'是否海關監管',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22340,'设备功率',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22340,'Power equipment',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22340,'設備功率',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22341,'附属设备',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22341,'Ancillary equipment',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22341,'附屬設備',9) 
/
delete from HtmlLabelIndex where id=22343 
/
delete from HtmlLabelInfo where indexid=22343 
/
INSERT INTO HtmlLabelIndex values(22343,'技术资料') 
/
INSERT INTO HtmlLabelInfo VALUES(22343,'技术资料',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22343,'Technical information',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22343,'技術資料',9) 
/
delete from HtmlLabelIndex where id=22342 
/
delete from HtmlLabelInfo where indexid=22342 
/
INSERT INTO HtmlLabelIndex values(22342,'备品配件') 
/
INSERT INTO HtmlLabelInfo VALUES(22342,'备品配件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22342,'Spare parts',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22342,'備品配件',9) 
/
delete from HtmlLabelIndex where id=22349 
/
delete from HtmlLabelInfo where indexid=22349 
/
INSERT INTO HtmlLabelIndex values(22349,'功率') 
/
delete from HtmlLabelIndex where id=22350 
/
delete from HtmlLabelInfo where indexid=22350 
/
INSERT INTO HtmlLabelIndex values(22350,'电压') 
/
INSERT INTO HtmlLabelInfo VALUES(22349,'功率',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22349,'Power',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22349,'功率',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22350,'电压',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22350,'Voltage',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22350,'電壓',9) 
/
delete from HtmlLabelIndex where id=22351 
/
delete from HtmlLabelInfo where indexid=22351 
/
INSERT INTO HtmlLabelIndex values(22351,'总重量') 
/
delete from HtmlLabelIndex where id=22352 
/
delete from HtmlLabelInfo where indexid=22352 
/
INSERT INTO HtmlLabelIndex values(22352,'尺寸') 
/
INSERT INTO HtmlLabelInfo VALUES(22351,'总重量',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22351,'Total weight',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22351,'總重量',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22352,'尺寸',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22352,'Size',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22352,'尺寸',9) 
/
delete from HtmlLabelIndex where id=21282 
/
delete from HtmlLabelInfo where indexid=21282 
/
INSERT INTO HtmlLabelIndex values(21282,'合同号') 
/
INSERT INTO HtmlLabelInfo VALUES(21282,'合同号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21282,'Contract No.',8) 
/

delete from SystemRights where id = 817
/
delete from SystemRightsLanguage where id = 817
/
delete from SystemRightDetail where rightid = 817
/
insert into SystemRights (id,rightdesc,righttype) values (817,'资产查询定义','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (817,9,'資產查詢定義','資產查詢定義') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (817,7,'资产查询定义','资产查询定义') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (817,8,'The definition of assets inquiry','The definition of assets inquiry') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4328,'资产查询定义','cptdefinition:all',817) 
/

delete from HtmlLabelIndex where id=22366 
/
delete from HtmlLabelInfo where indexid=22366 
/
INSERT INTO HtmlLabelIndex values(22366,'资产查询定义') 
/
INSERT INTO HtmlLabelInfo VALUES(22366,'资产查询定义',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22366,'The definition of assets inquiry',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22366,'資產查詢定義',9) 
/
delete from HtmlLabelIndex where id=22390 
/
delete from HtmlLabelInfo where indexid=22390 
/
INSERT INTO HtmlLabelIndex values(22390,'是否使用该字段作为查询条件或列表标题') 
/
delete from HtmlLabelIndex where id=22393 
/
delete from HtmlLabelInfo where indexid=22393 
/
INSERT INTO HtmlLabelIndex values(22393,'是否作为高级查询条件') 
/
delete from HtmlLabelIndex where id=22394 
/
delete from HtmlLabelInfo where indexid=22394 
/
INSERT INTO HtmlLabelIndex values(22394,'标题显示顺序') 
/
delete from HtmlLabelIndex where id=22392 
/
delete from HtmlLabelInfo where indexid=22392 
/
INSERT INTO HtmlLabelIndex values(22392,'是否作为搜索条件') 
/
delete from HtmlLabelIndex where id=22391 
/
delete from HtmlLabelInfo where indexid=22391 
/
INSERT INTO HtmlLabelIndex values(22391,'是否列表标题') 
/
INSERT INTO HtmlLabelInfo VALUES(22390,'是否使用该字段作为查询条件或列表标题',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22390,'Whether or not to use the field as a query or a list of headings',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22390,'是否使用該字段作為查詢條件或列表標題',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22391,'是否列表标题',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22391,'Whether the list of title',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22391,'是否列表標題',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22392,'是否作为搜索条件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22392,'Whether as a search criteria',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22392,'是否作為搜索條件',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22393,'是否作为高级查询条件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22393,'Whether as a senior query',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22393,'是否作為高級查詢條件',9) 
/
INSERT INTO HtmlLabelInfo VALUES(22394,'标题显示顺序',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22394,'The title of the display order',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22394,'標題顯示順序',9) 
/
delete from HtmlLabelIndex where id=22396 
/
delete from HtmlLabelInfo where indexid=22396 
/
INSERT INTO HtmlLabelIndex values(22396,'是否系统生成资产编码') 
/
INSERT INTO HtmlLabelInfo VALUES(22396,'是否系统生成资产编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22396,'Whether the system-generated asset coding',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22396,'是否系統生成資產編碼',9) 
/

delete from HtmlLabelIndex where id=22315 
/
delete from HtmlLabelInfo where indexid=22315 
/
INSERT INTO HtmlLabelIndex values(22315,'资产资料维护') 
/
INSERT INTO HtmlLabelInfo VALUES(22315,'资产资料维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22315,'Maintenance of asset information',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22315,'資產資料維護',9) 
/


delete from SystemRights where id =818
/
delete from SystemRightsLanguage where id =818
/
delete from SystemRightDetail where id =4329
/
insert into SystemRights (id,rightdesc,righttype) values (818,'资产变更维护','0') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (818,8,'Changes in the maintenance of assets','Changes in the maintenance of assets') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (818,9,'資產變更維護','資產變更維護') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (818,7,'资产变更维护','资产变更维护') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4329,'资产变更','CptCapital:modify',818) 
/

delete from HtmlLabelIndex where id=21922 
/
delete from HtmlLabelInfo where indexid=21922 
/
INSERT INTO HtmlLabelIndex values(21922,'点击左边分部对该分部进行操作') 
/
INSERT INTO HtmlLabelInfo VALUES(21922,'点击左边分部对该分部进行操作',7) 
/
INSERT INTO HtmlLabelInfo VALUES(21922,'Click on the left branch of the Division for operations',8) 
/
INSERT INTO HtmlLabelInfo VALUES(21922,'點擊左邊分部對該分部進行操作',9) 
/

delete from HtmlLabelIndex where id=22357 
/
delete from HtmlLabelInfo where indexid=22357 
/
INSERT INTO HtmlLabelIndex values(22357,'新建资产资料') 
/
INSERT INTO HtmlLabelInfo VALUES(22357,'新建资产资料',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22357,'New assets',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22357,'新建資產資料',9) 
/

delete from HtmlLabelIndex where id=22457 
/
delete from HtmlLabelInfo where indexid=22457 
/
INSERT INTO HtmlLabelIndex values(22457,'维修期限') 
/
INSERT INTO HtmlLabelInfo VALUES(22457,'维修期限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22457,'Repair period',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22457,'維修期限',9) 
/
delete from HtmlLabelIndex where id=22459 
/
delete from HtmlLabelInfo where indexid=22459 
/
INSERT INTO HtmlLabelIndex values(22459,'资产送修') 
/
INSERT INTO HtmlLabelInfo VALUES(22459,'资产送修',7) 
/
INSERT INTO HtmlLabelInfo VALUES(22459,'Asset repair',8) 
/
INSERT INTO HtmlLabelInfo VALUES(22459,'資產送修',9) 
/
