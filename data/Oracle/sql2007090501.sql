delete from HtmlLabelIndex where id in (18776,20612,20616,20617,20618,20619,20620)
/
delete from HtmlLabelInfo where indexId in(18776,20612,20616,20617,20618,20619,20620)
/
INSERT INTO HtmlLabelIndex values(20612,'是否填报多行') 
/
INSERT INTO HtmlLabelInfo VALUES(20612,'是否填报多行',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20612,'Input Multi-Line Or Not',8) 
/
INSERT INTO HtmlLabelIndex values(18776,'输入周期') 
/
INSERT INTO HtmlLabelInfo VALUES(18776,'输入周期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18776,'Input Cycle',8) 
/
INSERT INTO HtmlLabelIndex values(20616,'年报') 
/
INSERT INTO HtmlLabelIndex values(20618,'旬报') 
/
INSERT INTO HtmlLabelIndex values(20620,'日报') 
/
INSERT INTO HtmlLabelIndex values(20617,'月报') 
/
INSERT INTO HtmlLabelIndex values(20619,'周报') 
/
INSERT INTO HtmlLabelInfo VALUES(20616,'年报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20616,'Year Report',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20617,'月报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20617,'Month Report',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20618,'旬报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20618,'Ten Days Report',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20619,'周报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20619,'Week Report',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20620,'日报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20620,'Daily Report',8) 
/

delete from HtmlLabelIndex where id in (20786,20787,20788,20789,20790,20791,20792,20793,20794)
/
delete from HtmlLabelInfo where indexId in(20786,20787,20788,20789,20790,20791,20792,20793,20794)
/
INSERT INTO HtmlLabelIndex values(20786,'输入表重名') 
/
INSERT INTO HtmlLabelIndex values(20787,'输入报表信息') 
/
INSERT INTO HtmlLabelIndex values(20788,'填报开始日期') 
/
INSERT INTO HtmlLabelIndex values(20789,'填报截至日期') 
/
INSERT INTO HtmlLabelIndex values(20791,'选择型') 
/
INSERT INTO HtmlLabelIndex values(20792,'计算型') 
/
INSERT INTO HtmlLabelIndex values(20793,'可录入人员') 
/
INSERT INTO HtmlLabelIndex values(20790,'Excel中的位置') 
/
INSERT INTO HtmlLabelInfo VALUES(20786,'输入表重名',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20786,'Input Report Table Repeated',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20787,'输入报表信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20787,'Input Report Table Info',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20788,'填报开始日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20788,'Input Start Date',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20789,'填报截至日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20789,'Input End Date',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20790,'Excel中的位置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20790,'The Location Of Excel',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20791,'选择型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20791,'Select Type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20792,'计算型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20792,'Caculate Type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20793,'可录入人员',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20793,'Input User',8) 
/

INSERT INTO HtmlLabelIndex values(20794,'输入报表中已有重名的表，是否继续?') 
/
INSERT INTO HtmlLabelInfo VALUES(20794,'输入报表中已有重名的表，是否继续?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20794,'The input tables has the same name table,continue?',8) 
/

delete from HtmlLabelIndex where id in (20801,20802,20803)
/
delete from HtmlLabelInfo where indexId in(20801,20802,20803)
/
INSERT INTO HtmlLabelIndex values(20801,'输入项类型名称') 
/
INSERT INTO HtmlLabelIndex values(20802,'输入项类型描述') 
/
INSERT INTO HtmlLabelInfo VALUES(20801,'输入项类型名称',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20801,'Name Of Input Item Type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20802,'输入项类型描述',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20802,'Description Of Input Item Type',8) 
/
INSERT INTO HtmlLabelIndex values(20803,'输入报表中已有重名的列，是否继续?') 
/
INSERT INTO HtmlLabelInfo VALUES(20803,'输入报表中已有重名的列，是否继续?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20803,'The input tables has the same name col,continue?',8) 
/
 
delete from HtmlLabelIndex where id in (20715)
/
delete from HtmlLabelInfo where indexId in(20715)
/
INSERT INTO HtmlLabelIndex values(20715,'填报人') 
/
INSERT INTO HtmlLabelInfo VALUES(20715,'填报人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20715,'reporter',8) 
/

delete from HtmlLabelIndex where id in (20806)
/
delete from HtmlLabelInfo where indexId in(20806)
/
INSERT INTO HtmlLabelIndex values(20806,'该输入项类型有输入项，不能删除！') 
/
INSERT INTO HtmlLabelInfo VALUES(20806,'该输入项类型有输入项，不能删除！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20806,'The input item type has input item,couldn''t been deleted!',8) 
/
delete from HtmlLabelIndex where id in(20826,20828,20829,20831,20832,20839)
/
delete from HtmlLabelInfo where indexId in(20826,20828,20829,20831,20832,20839)
/
INSERT INTO HtmlLabelIndex values(20826,'输入项字段类型') 
/
INSERT INTO HtmlLabelInfo VALUES(20826,'输入项字段类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20826,'Field Type Of The Inputed Item',8) 
/
INSERT INTO HtmlLabelIndex values(20829,'报表查看') 
/
INSERT INTO HtmlLabelIndex values(20828,'报表填报') 
/
INSERT INTO HtmlLabelInfo VALUES(20828,'报表填报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20828,'Report Input',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20829,'报表查看',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20829,'Report Output',8) 
/
INSERT INTO HtmlLabelIndex values(20831,'是否显示于报表填报') 
/
INSERT INTO HtmlLabelIndex values(20832,'是否显示于报表查看') 
/
INSERT INTO HtmlLabelInfo VALUES(20831,'是否显示于报表填报',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20831,'Show On Report Input Or Not',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20832,'是否显示于报表查看',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20832,'Show On Report Output Or Not',8) 
/
INSERT INTO HtmlLabelIndex values(20839,'批量') 
/
INSERT INTO HtmlLabelInfo VALUES(20839,'批量',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20839,'Batch',8) 
/



delete from HtmlLabelIndex where id=19201
/
delete from HtmlLabelInfo where indexId=19201
/
INSERT INTO HtmlLabelIndex values(19201,'请输入不同的值！') 
/
INSERT INTO HtmlLabelInfo VALUES(19201,'请输入不同的值！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19201,'Please input different value!',8) 
/


delete from HtmlLabelIndex where id=20857
/
delete from HtmlLabelInfo where indexId=20857
/
INSERT INTO HtmlLabelIndex values(20857,'请先维护输入项类型！') 
/
INSERT INTO HtmlLabelInfo VALUES(20857,'请先维护输入项类型！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20857,'Please maintain type of the inputed item first!',8) 
/

DELETE FROM HtmlLabelInfo where indexId in(20881,20882)
/
DELETE FROM HtmlLabelIndex where id in(20881,20882)
/
INSERT INTO HtmlLabelIndex values(20881,'该值不能变小，请重新维护！') 
/
INSERT INTO HtmlLabelIndex values(20882,'请输入以下范围的整数') 
/
INSERT INTO HtmlLabelInfo VALUES(20881,'该值不能变小，请重新维护！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20881,'The value couldn''t been changed smaller,maintenance again please!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20882,'请输入以下范围的整数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20882,'Please input a integer been in the range',8) 
/


DELETE FROM HtmlLabelIndex WHERE id=20774
/
INSERT INTO HtmlLabelIndex values(20774,'报表模板及填报注意事项') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20774
/
INSERT INTO HtmlLabelInfo VALUES(20774,'报表模板及填报注意事项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20774,'Report template and making note',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=20775
/
INSERT INTO HtmlLabelIndex values(20775,'报表数据已存在') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20775
/
INSERT INTO HtmlLabelInfo VALUES(20775,'报表数据已存在',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20775,'Report data already exists',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=20776
/
INSERT INTO HtmlLabelIndex values(20776,'报表数据在处于草稿状态，继续导入吗(Y/N)') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20776
/
INSERT INTO HtmlLabelInfo VALUES(20776,'报表数据在处于草稿状态，继续导入吗(Y/N)',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20776,'Report data at the state of the draft, continue to import? (Y / N)',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=20777
/
INSERT INTO HtmlLabelIndex values(20777,'当前报表为单行数据，已有数据处于草稿状态,是否导入覆盖(Y/N)') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20777
/
INSERT INTO HtmlLabelInfo VALUES(20777,'当前报表为单行数据，已有数据处于草稿状态,是否导入覆盖(Y/N)',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20777,'In separate reports to the current data, the available data in the draft state, into coverage (Y/N)',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=20774
/
INSERT INTO HtmlLabelIndex values(20774,'报表模板及填报注意事项') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20774
/
INSERT INTO HtmlLabelInfo VALUES(20774,'报表模板及填报注意事项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20774,'Report template and making note',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=20775
/
INSERT INTO HtmlLabelIndex values(20775,'报表数据已存在') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20775
/
INSERT INTO HtmlLabelInfo VALUES(20775,'报表数据已存在',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20775,'Report data already exists',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=20776
/
INSERT INTO HtmlLabelIndex values(20776,'报表数据在处于草稿状态，继续导入吗(Y/N)') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20776
/
INSERT INTO HtmlLabelInfo VALUES(20776,'报表数据在处于草稿状态，继续导入吗(Y/N)',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20776,'Report data at the state of the draft, continue to import? (Y / N)',8) 
/

DELETE FROM HtmlLabelIndex WHERE id=20777
/
INSERT INTO HtmlLabelIndex values(20777,'当前报表为单行数据，已有数据处于草稿状态,是否导入覆盖(Y/N)') 
/

DELETE FROM HtmlLabelInfo WHERE indexid=20777
/
INSERT INTO HtmlLabelInfo VALUES(20777,'当前报表为单行数据，已有数据处于草稿状态,是否导入覆盖(Y/N)',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20777,'In separate reports to the current data, the available data in the draft state, into coverage (Y/N)',8) 
/


delete from HtmlLabelIndex where id >=20715 and id<=20761
/
delete from HtmlLabelInfo where indexid >=20715 and indexid<=20761
/

INSERT INTO HtmlLabelIndex values(20732,'多个字段间用逗号分隔例如:f_a,f_b') 
/
INSERT INTO HtmlLabelIndex values(20738,'您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！') 
/
INSERT INTO HtmlLabelIndex values(20717,'可录入人员权限设置') 
/
INSERT INTO HtmlLabelIndex values(20719,'报表模板文件') 
/
INSERT INTO HtmlLabelIndex values(20720,'可填报字段') 
/
INSERT INTO HtmlLabelIndex values(20725,'汇总的基层单位') 
/
INSERT INTO HtmlLabelIndex values(20726,'汇总周期') 
/
INSERT INTO HtmlLabelIndex values(20731,'分类汇总字段') 
/
INSERT INTO HtmlLabelIndex values(20730,'添加数据库表') 
/
INSERT INTO HtmlLabelIndex values(20740,'还未填报!是否继续汇总?') 
/
INSERT INTO HtmlLabelIndex values(20741,'已经存在汇总数据!是否重新汇总?') 
/
INSERT INTO HtmlLabelIndex values(20742,'您选择的期间已经关闭!') 
/
INSERT INTO HtmlLabelIndex values(20743,'报表项定义') 
/
INSERT INTO HtmlLabelIndex values(20744,'报表项类型') 
/
INSERT INTO HtmlLabelIndex values(20746,'数据库取值') 
/
INSERT INTO HtmlLabelIndex values(20747,'其它表格取值') 
/
INSERT INTO HtmlLabelIndex values(20749,'文本内容') 
/
INSERT INTO HtmlLabelIndex values(20750,'其它表格取值表达式') 
/
INSERT INTO HtmlLabelIndex values(20751,'说明: 用 $A2 标识一个表格') 
/
INSERT INTO HtmlLabelIndex values(20752,'用 $rowcount 标识展开的行数') 
/
INSERT INTO HtmlLabelIndex values(20753,'图形统计') 
/
INSERT INTO HtmlLabelIndex values(20756,'打印设置') 
/
INSERT INTO HtmlLabelIndex values(20757,'打印预览') 
/
INSERT INTO HtmlLabelIndex values(20760,'目标报表项') 
/
INSERT INTO HtmlLabelIndex values(20761,'备注，当源报表项为列或者行时，目标报表项只能为列或者行') 
/
INSERT INTO HtmlLabelIndex values(20715,'填报人') 
/
INSERT INTO HtmlLabelIndex values(20721,'收缩') 
/
INSERT INTO HtmlLabelIndex values(20722,'汇总设置') 
/
INSERT INTO HtmlLabelIndex values(20723,'添加汇总') 
/
INSERT INTO HtmlLabelIndex values(20724,'删除汇总') 
/
INSERT INTO HtmlLabelIndex values(20728,'半月') 
/
INSERT INTO HtmlLabelIndex values(20727,'汇总源数据库表') 
/
INSERT INTO HtmlLabelIndex values(20733,'条件前不需要加and例如:f_a=2 and f_b=3') 
/
INSERT INTO HtmlLabelIndex values(20735,'字段对照') 
/
INSERT INTO HtmlLabelIndex values(20737,'请至少选择一个基层单位!') 
/
INSERT INTO HtmlLabelIndex values(20754,'图形统计项') 
/
INSERT INTO HtmlLabelIndex values(20755,'非计算') 
/
INSERT INTO HtmlLabelIndex values(20758,'报表项复制') 
/
INSERT INTO HtmlLabelIndex values(20759,'源报表项') 
/
INSERT INTO HtmlLabelIndex values(20716,'填报日期') 
/
INSERT INTO HtmlLabelIndex values(20729,'半年') 
/
INSERT INTO HtmlLabelIndex values(20745,'报表项描述') 
/
INSERT INTO HtmlLabelIndex values(20718,'可填报基层单位') 
/
INSERT INTO HtmlLabelIndex values(20734,'汇总条件') 
/
INSERT INTO HtmlLabelIndex values(20736,'源汇总字段') 
/
INSERT INTO HtmlLabelIndex values(20739,'报表输入选择项') 
/
INSERT INTO HtmlLabelIndex values(20748,'报表项信息') 
/
INSERT INTO HtmlLabelInfo VALUES(20715,'填报人',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20715,'reporter',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20716,'填报日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20716,'report date',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20717,'可录入人员权限设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20717,'Input user right setting',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20718,'可填报基层单位',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20718,'Input CRM',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20719,'报表模板文件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20719,'Report model file',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20720,'可填报字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20720,'Input fields',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20721,'收缩',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20721,'Collapse',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20722,'汇总设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20722,'Collect setting',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20723,'添加汇总',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20723,'Add collect',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20724,'删除汇总',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20724,'Delete collect',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20725,'汇总的基层单位',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20725,'Collect CRM',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20726,'汇总周期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20726,'Collect cycle',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20727,'汇总源数据库表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20727,'Collect table',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20728,'半月',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20728,'Half month',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20729,'半年',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20729,'Half year',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20730,'添加数据库表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20730,'Add table',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20731,'分类汇总字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20731,'Group fields',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20732,'多个字段间用逗号分隔例如:f_a#f_b',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20732,'Multi-field example:f_a#f_b',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20733,'条件前不需要加and例如:f_a=2 and f_b=3',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20733,'Example:f_a=2 and f_b=3',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20734,'汇总条件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20734,'Collect condition',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20735,'字段对照',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20735,'Field counterpoint',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20736,'源汇总字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20736,'Source field',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20737,'请至少选择一个基层单位!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20737,'Select CRM,Please!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20738,'您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20738,'Select Crm troppo,afresh select please!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20739,'报表输入选择项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20739,'Report input select item',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20740,'还未填报!是否继续汇总?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20740,'not input!whether / on collect?',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20741,'已经存在汇总数据!是否重新汇总?',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20741,'Exist collect data!whether afresh collect?',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20742,'您选择的期间已经关闭!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20742,'You are select period closed!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20743,'报表项定义',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20743,'Report item setting',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20744,'报表项类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20744,'Report item type',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20745,'报表项描述',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20745,'Report item describe',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20746,'数据库取值',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20746,'Database',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20747,'其它表格取值',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20747,'Other tabulation',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20748,'报表项信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20748,'Report item infomation',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20749,'文本内容',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20749,'Text content',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20750,'其它表格取值表达式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20750,'Other tabulation get value expression',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20751,'说明: 用 $A2 标识一个表格',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20751,'explain:$A2 express a form',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20752,'用 $rowcount 标识展开的行数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20752,'$rowcount express expanding row num',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20753,'图形统计',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20753,'Graph Stat.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20754,'图形统计项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20754,'Graph Stat. item',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20755,'非计算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20755,'non-account',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20756,'打印设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20756,'Print Setting',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20757,'打印预览',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20757,'Print preview',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20758,'报表项复制',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20758,'Report item copy',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20759,'源报表项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20759,'Source report item',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20760,'目标报表项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20760,'Target report item',8) 
/
INSERT INTO HtmlLabelInfo VALUES(20761,'备注，当源报表项为列或者行时，目标报表项只能为列或者行',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20761,'',8) 
/

delete from HtmlLabelIndex where id =20769
/
delete from HtmlLabelInfo where indexid=20769
/
INSERT INTO HtmlLabelIndex values(20769,'查看汇总SQL') 
/
INSERT INTO HtmlLabelInfo VALUES(20769,'查看汇总SQL',7) 
/
INSERT INTO HtmlLabelInfo VALUES(20769,'Collect SQL',8) 
/

