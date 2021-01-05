delete from HtmlLabelIndex where id=20421 or id=18446
/
delete from HtmlLabelInfo where indexid=20421 or indexid=18446
/
delete from HtmlLabelIndex where id=20422
/
delete from HtmlLabelInfo where indexid=20422
/
delete from HtmlLabelIndex where id=20454
/
delete from HtmlLabelInfo where indexid=20454
/

delete from HtmlLabelIndex where id>=20456 and id<=20469
/
delete from HtmlLabelInfo where indexid>=20456 and indexid<=20469
/
delete from HtmlLabelIndex where id=20472 or id=20473 or id=20475 or id=20478 or  id=20479 or id=20480 or id=20488
/
delete from HtmlLabelInfo where indexid=20472 or indexid=20473 or indexid=20475 or indexid=20478 or  indexid=20479 or indexid=20480 or indexid=2048
/
INSERT INTO HtmlLabelIndex values(18446,'全文检索') 
/
INSERT INTO HtmlLabelInfo VALUES(18446,'全文检索',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18446,'Search ALL',8) 
/

INSERT INTO HtmlLabelIndex values(20422,'文档全文检索的索引库管理')
/
INSERT INTO HtmlLabelIndex values(20421,'文档内容的全文检索搜索')
/
INSERT INTO HtmlLabelInfo VALUES(20421,'全文搜索',7)
/
INSERT INTO HtmlLabelInfo VALUES(20421,'docs search',8)
/
INSERT INTO HtmlLabelInfo VALUES(20422,'搜索索引管理',7)
/
INSERT INTO HtmlLabelInfo VALUES(20422,'Manager index of search',8)
/

INSERT INTO HtmlLabelIndex values(20457,'搜索结果为空')
/
INSERT INTO HtmlLabelIndex values(20458,'创建索引添加完成')
/
INSERT INTO HtmlLabelIndex values(20462,'删除失败')
/
INSERT INTO HtmlLabelIndex values(20463,'索引库名称不能为空')
/
INSERT INTO HtmlLabelIndex values(20467,'索引库管理及配置')
/
INSERT INTO HtmlLabelIndex values(20468,'手动创建索引设置')
/
INSERT INTO HtmlLabelIndex values(20469,'数据源范围')
/
INSERT INTO HtmlLabelIndex values(20475,'索引库名称')
/
INSERT INTO HtmlLabelIndex values(20454,'文档全文检索')
/
INSERT INTO HtmlLabelIndex values(20456,'关键字不能为空!')
/
INSERT INTO HtmlLabelIndex values(20459,'数据源已创建过')
/
INSERT INTO HtmlLabelIndex values(20461,'删除成功')
/
INSERT INTO HtmlLabelIndex values(20464,'确认删除该索引库吗,无法恢复(Y/N)')
/
INSERT INTO HtmlLabelIndex values(20465,'请选择起始日期')
/
INSERT INTO HtmlLabelIndex values(20466,'和结束日期')
/
INSERT INTO HtmlLabelIndex values(20472,'创建索引')
/
INSERT INTO HtmlLabelIndex values(20460,'索引库')
/
INSERT INTO HtmlLabelIndex values(20473,'搜索系统属性设置')
/
INSERT INTO HtmlLabelInfo VALUES(20454,'文档全文检索',7)
/
INSERT INTO HtmlLabelInfo VALUES(20454,'Document full-text search',8)
/
INSERT INTO HtmlLabelInfo VALUES(20456,'关键字不能为空!',7)
/
INSERT INTO HtmlLabelInfo VALUES(20456,'Keywords can not be empty!',8)
/
INSERT INTO HtmlLabelInfo VALUES(20457,'关键字{key}搜索结果为空,或最后一页了!',7)
/
INSERT INTO HtmlLabelInfo VALUES(20457,'{key} keyword search results for the air, or the last one!',8)
/
INSERT INTO HtmlLabelInfo VALUES(20458,'创建索引添加完成,正在创建中,请继续其他操作.',7)
/
INSERT INTO HtmlLabelInfo VALUES(20458,'Create index added completion, which is being created, please continue other operations.',8)
/
INSERT INTO HtmlLabelInfo VALUES(20459,'数据源已创建过',7)
/
INSERT INTO HtmlLabelInfo VALUES(20459,'Index Source data has established over',8)
/
INSERT INTO HtmlLabelInfo VALUES(20460,'索引库',7)
/
INSERT INTO HtmlLabelInfo VALUES(20460,'Index database',8)
/
INSERT INTO HtmlLabelInfo VALUES(20461,'删除成功',7)
/
INSERT INTO HtmlLabelInfo VALUES(20461,'delete success',8)
/
INSERT INTO HtmlLabelInfo VALUES(20462,'删除失败',7)
/
INSERT INTO HtmlLabelInfo VALUES(20462,'Delete failure',8)
/
INSERT INTO HtmlLabelInfo VALUES(20463,'索引库名称不能为空',7)
/
INSERT INTO HtmlLabelInfo VALUES(20463,'Index of the name can not be empty',8)
/
INSERT INTO HtmlLabelInfo VALUES(20464,'确认删除该索引库吗,无法恢复(Y/N)',7)
/
INSERT INTO HtmlLabelInfo VALUES(20464,'Are you confirm the deletion of the index database, unable to resume(Y/N)',8)
/
INSERT INTO HtmlLabelInfo VALUES(20465,'请选择起始日期',7)
/
INSERT INTO HtmlLabelInfo VALUES(20465,'Please choose the start date',8)
/
INSERT INTO HtmlLabelInfo VALUES(20466,'和结束日期',7)
/
INSERT INTO HtmlLabelInfo VALUES(20466,'and end date',8)
/
INSERT INTO HtmlLabelInfo VALUES(20467,'索引库管理及配置',7)
/
INSERT INTO HtmlLabelInfo VALUES(20467,'Index database manager and configure',8)
/
INSERT INTO HtmlLabelInfo VALUES(20468,'手动创建索引设置',7)
/
INSERT INTO HtmlLabelInfo VALUES(20468,'Setup manually create indexes',8)
/
INSERT INTO HtmlLabelInfo VALUES(20469,'数据源范围',7)
/
INSERT INTO HtmlLabelInfo VALUES(20469,'Index Sources scope',8)
/
INSERT INTO HtmlLabelInfo VALUES(20472,'创建索引',7)
/
INSERT INTO HtmlLabelInfo VALUES(20472,'Create index',8)
/
INSERT INTO HtmlLabelInfo VALUES(20473,'搜索系统属性设置',7)
/
INSERT INTO HtmlLabelInfo VALUES(20473,'Search System properties setup',8)
/
INSERT INTO HtmlLabelInfo VALUES(20475,'索引库名称',7)
/
INSERT INTO HtmlLabelInfo VALUES(20475,'Index database name',8)
/
INSERT INTO HtmlLabelIndex values(20478,'指定某一月份')
/
INSERT INTO HtmlLabelIndex values(20479,'起始日期到结束日期')
/
INSERT INTO HtmlLabelIndex values(20480,'起始日期至昨天')
/
INSERT INTO HtmlLabelInfo VALUES(20478,'指定某一月份',7)
/
INSERT INTO HtmlLabelInfo VALUES(20478,'A month',8)
/
INSERT INTO HtmlLabelInfo VALUES(20479,'起始日期到结束日期',7)
/
INSERT INTO HtmlLabelInfo VALUES(20479,'Start date to the end date',8)
/
INSERT INTO HtmlLabelInfo VALUES(20480,'起始日期至昨天',7)
/
INSERT INTO HtmlLabelInfo VALUES(20480,'Start date to yesterday',8)
/
INSERT INTO HtmlLabelIndex values(20488,'数据源日期最大范围')
/
INSERT INTO HtmlLabelInfo VALUES(20488,'注意:数据源日期最大范围为一个月内.',7)
/
INSERT INTO HtmlLabelInfo VALUES(20488,'Note : Index source of the range to the date within a month.',8)
/

delete from HtmlLabelIndex where id>=20524 and id<=20531
/
delete from HtmlLabelInfo where indexid>=20524 and indexid<=20531
/
delete from HtmlLabelIndex where id=19653 or id=20534
/
delete from HtmlLabelInfo where indexid=19653 or indexid=20534
/
INSERT INTO HtmlLabelIndex values(19653,'设置') 
/
INSERT INTO HtmlLabelInfo VALUES(19653,'设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19653,'Setting',8) 
/
INSERT INTO HtmlLabelIndex values(20527,'是否启动自动索引任务') 
/
INSERT INTO HtmlLabelIndex values(20528,'任务开始时间') 
/
INSERT INTO HtmlLabelIndex values(20529,'索引时,内存中最大Document数') 
/
INSERT INTO HtmlLabelIndex values(20526,'索引库名称列表') 
/
INSERT INTO HtmlLabelIndex values(20524,'索引库最大容量(M)') 
/
INSERT INTO HtmlLabelIndex values(20525,'索引库的保存路径') 
/
INSERT INTO HtmlLabelIndex values(20530,'一个Segment中最大的文档数量') 
/
INSERT INTO HtmlLabelIndex values(20531,'搜索结果每页最大记录数') 
/
INSERT INTO HtmlLabelInfo VALUES(20524,'索引库最大容量',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20524,'Index of the maximum capacity(M)',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20525,'索引库的保存路径',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20525,'Index database for the save path',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20526,'索引库名称列表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20526,'Index database list of file name',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20527,'是否启用自动索引任务',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20527,'Whether to enabled the automatic indexing task',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20528,'任务开始时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20528,'start date of task',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20529,'索引时,内存中最大Document数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20529,'The max number of Documents when Indexing in memory',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20530,'一个Segment中最大的文档数量',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20530,'Segment one of the max Documents',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20531,'搜索结果每页最大记录数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20531,'Search Results page recorded the max number of',8) 
/
INSERT INTO HtmlLabelIndex values(20534,'搜索用时描述') 
/
INSERT INTO HtmlLabelInfo VALUES(20534,'用时{key}秒',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20534,'Time {key}s',8) 
/


delete from HtmlLabelIndex where id=18015
/
delete from HtmlLabelInfo where indexid=18015
/
INSERT INTO HtmlLabelIndex values(18015,'流程') 
/
INSERT INTO HtmlLabelInfo VALUES(18015,'流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18015,'Workflow',8) 
/