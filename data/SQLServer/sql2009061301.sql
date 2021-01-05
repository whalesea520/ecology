delete from SystemRightDetail where rightid = 855
GO
delete from SystemRightsLanguage where id = 855
GO
delete from SystemRights where id = 855
GO
insert into SystemRights (id,rightdesc,righttype) values (855,'外部数据触发流程设置','5') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (855,7,'外部数据触发流程设置','外部数据触发流程设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (855,8,'workflow for outside data setting','workflow for outside data setting') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (855,9,'外部數據觸發流程設置','外部數據觸發流程設置') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4370,'外部数据触发流程设置','OutDataInterface:Setting',855) 
GO

delete from HtmlLabelIndex where id=23076 
GO
delete from HtmlLabelInfo where indexid=23076 
GO
INSERT INTO HtmlLabelIndex values(23076,'外部数据触发流程设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(23076,'外部数据触发流程设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23076,'workflow for outside data setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23076,'外部數據觸發流程設置',9) 
GO

delete from HtmlLabelIndex where id=19928 
GO
delete from HtmlLabelInfo where indexid=19928 
GO
INSERT INTO HtmlLabelIndex values(19928,'外部接口设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(19928,'外部接口设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19928,'Interface Setting',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19928,'外部接口設置',9) 
GO

delete from HtmlLabelIndex where id=21900 
GO
delete from HtmlLabelInfo where indexid=21900 
GO
INSERT INTO HtmlLabelIndex values(21900,'表名') 
GO
INSERT INTO HtmlLabelInfo VALUES(21900,'表名',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21900,'Table Name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21900,'表名',9) 
GO

delete from HtmlLabelIndex where id=23107 
GO
delete from HtmlLabelInfo where indexid=23107 
GO
INSERT INTO HtmlLabelIndex values(23107,'外部主表回写设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(23107,'外部主表回写设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23107,'setting of writing outer main table',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23107,'外部主表回寫設置',9) 
GO
delete from HtmlLabelIndex where id=23108 
GO
delete from HtmlLabelInfo where indexid=23108 
GO
INSERT INTO HtmlLabelIndex values(23108,'流程触发成功时') 
GO
INSERT INTO HtmlLabelInfo VALUES(23108,'流程触发成功时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23108,'when workflow is created successful',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23108,'流程觸發成功時',9) 
GO

delete from HtmlLabelIndex where id=23109 
GO
delete from HtmlLabelInfo where indexid=23109 
GO
INSERT INTO HtmlLabelIndex values(23109,'流程触发失败时') 
GO
INSERT INTO HtmlLabelInfo VALUES(23109,'流程触发失败时',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23109,'when workflow is created unsuccessful',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23109,'流程觸發失敗時',9) 
GO

delete from HtmlLabelIndex where id=23111 
GO
delete from HtmlLabelInfo where indexid=23111 
GO
INSERT INTO HtmlLabelIndex values(23111,'触发说明1') 
GO
delete from HtmlLabelIndex where id=23110 
GO
delete from HtmlLabelInfo where indexid=23110 
GO
INSERT INTO HtmlLabelIndex values(23110,'触发说明2') 
GO
INSERT INTO HtmlLabelInfo VALUES(23110,'条件以“where”开头，如：“where fieldname1=1 and fieldname2=''value2''”；回写设置以“set”开头，如：“set flag=1,isok=true”。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23110,'condition begin with "where",such as "where where fieldname1=1 and fieldname2=''''''''value2''''''''",return sql begin with "set",such as "set flag=1,isok=true"',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23110,'條件以“where”開頭，如：“where fieldname1=1 and fieldname2=''value2''”；回寫設置以“set”開頭，如：“set flag=1,isok=true”。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(23111,'说明：该流程自动触发时，将根据外部主表条件搜索外部主表，有多少条记录即触发多少条流程；流程主字段的值来源于外部主表，而每条流程的各明细值将分别根据明细表条件搜索明细表得到的结果进行赋值；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23111,'remark:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23111,'說明：該流程自動觸發時，將根據外部主表條件搜索外部主表，有多少條記錄即觸發多少條流程；流程主字段的值來源於外部主表，而每條流程的各明細值將分別根據明細表條件搜索明細表得到的結果進行賦值；',9) 
GO

delete from HtmlLabelIndex where id=23112 
GO
delete from HtmlLabelInfo where indexid=23112 
GO
INSERT INTO HtmlLabelIndex values(23112,'触发周期设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(23112,'触发周期设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23112,'period setting of trigger',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23112,'觸發周期設置',9) 
GO

delete from HtmlLabelIndex where id=23136 
GO
delete from HtmlLabelInfo where indexid=23136 
GO
INSERT INTO HtmlLabelIndex values(23136,'触发周期') 
GO
INSERT INTO HtmlLabelInfo VALUES(23136,'触发周期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23136,'period of trigger',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23136,'觸發周期',9) 
GO

delete from HtmlLabelIndex where id=23137 
GO
delete from HtmlLabelInfo where indexid=23137 
GO
INSERT INTO HtmlLabelIndex values(23137,'以分钟为单位') 
GO
INSERT INTO HtmlLabelInfo VALUES(23137,'以分钟为单位',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23137,'by minute',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23137,'以分鐘為單位',9) 
GO

delete from HtmlLabelIndex where id=23113 
GO
delete from HtmlLabelInfo where indexid=23113 
GO
INSERT INTO HtmlLabelIndex values(23113,'触发流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(23113,'触发流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23113,'workflow that is triggered',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23113,'觸發流程',9) 
GO

delete from HtmlLabelIndex where id=23123 
GO
delete from HtmlLabelInfo where indexid=23123 
GO
INSERT INTO HtmlLabelIndex values(23123,'说明：选择外部字段与流程字段一一对应，在将外部字段赋值的过程中，如果外部字段的数据库类型与流程字段类型不匹配将按以下规则处理：') 
GO
INSERT INTO HtmlLabelInfo VALUES(23123,'说明：选择外部字段与流程字段一一对应，在将外部字段赋值的过程中，如果外部字段的数据库类型与流程字段类型不匹配将按以下规则处理：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23123,'Note: Select the external field-one correspondence with the flow field, external field in the process of assignment, if the external database field types and field types do not match the process according to the following rules:',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23123,'說明：選擇外部字段與流程字段一一對應，在將外部字段賦值的過程中，如果外部字段的數據庫類型與流程字段類型不匹配將按以下規則處理：',9) 
GO

delete from HtmlLabelIndex where id=23124 
GO
delete from HtmlLabelInfo where indexid=23124 
GO
INSERT INTO HtmlLabelIndex values(23124,'1：流程字段是字符型，如果外部数据超长，则对外部数据进行截位后赋值给流程字段；') 
GO
INSERT INTO HtmlLabelInfo VALUES(23124,'1：流程字段是字符型，如果外部数据超长，则对外部数据进行截位后赋值给流程字段；',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23124,'1: flow field is character, if the long external data, external data on post-cut-off value to the process field;',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23124,'1：流程字段是字符型，如果外部數據超長，則對外部數據進行截位後賦值給流程字段；',9) 
GO

delete from HtmlLabelIndex where id=23125 
GO
delete from HtmlLabelInfo where indexid=23125 
GO
INSERT INTO HtmlLabelIndex values(23125,'2：流程字段是整型或浮点型，如果外部数据为字符，则赋值-1给流程字段。') 
GO
INSERT INTO HtmlLabelInfo VALUES(23125,'2：流程字段是整型或浮点型，如果外部数据为字符，则赋值-1给流程字段。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23125,'2: flow field is integer or floating-point type, if the external data for the characters, -1 is assigned to the flow field.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23125,'2：流程字段是整型或浮點型，如果外部數據為字符，則賦值-1給流程字段。',9) 
GO

delete from HtmlLabelIndex where id=23126 
GO
delete from HtmlLabelInfo where indexid=23126 
GO
INSERT INTO HtmlLabelIndex values(23126,'转换规则：转换规则只针对人力资源浏览框，部门浏览框和分部浏览框，如果选择了转换规则，将按照转换规则字段与外部字段对应，再通过转换字段找到人力资源浏览框，部门浏览框和分部浏览框对应的值。') 
GO
delete from HtmlLabelIndex where id=23127 
GO
delete from HtmlLabelInfo where indexid=23127 
GO
INSERT INTO HtmlLabelIndex values(23127,'流程标题：可以选择某个外部字段做为流程标题的来源，如果没选择，流程标题按“流程名-创建人名-日期”的格式自动生成。') 
GO
INSERT INTO HtmlLabelInfo VALUES(23126,'转换规则：转换规则只针对人力资源浏览框，部门浏览框和分部浏览框，如果选择了转换规则，将按照转换规则字段与外部字段对应，再通过转换字段找到人力资源浏览框，部门浏览框和分部浏览框对应的值。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23126,'Conversion rules: transformation rules only browser frame for human resources, departments, divisions browser browser box and the box, if you select the conversion rules, conversion rules will be in accordance with the external field and the corresponding',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23126,'轉換規則：轉換規則只針對人力資源瀏覽框，部門瀏覽框和分部瀏覽框，如果選擇了轉換規則，將按照轉換規則字段與外部字段對應，再通過轉換字段找到人力資源瀏覽框，部門瀏覽框和分部瀏覽框對應的值。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(23127,'流程标题：可以选择某个外部字段做为流程标题的来源，如果没选择，流程标题按“流程名-创建人名-日期”的格式自动生成。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23127,'Process Title: can choose an external flow field as the source of the title, if not choice, the process according to the title of "the process of - the creation of names - the date" format automatically.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23127,'流程標題：可以選擇某個外部字段做為流程標題的來源，如果沒選擇，流程標題按“流程名-創建人名-日期”的格式自動生成。',9) 
GO

delete from HtmlLabelIndex where id=23128 
GO
delete from HtmlLabelInfo where indexid=23128 
GO
INSERT INTO HtmlLabelIndex values(23128,'转换规则') 
GO
INSERT INTO HtmlLabelInfo VALUES(23128,'转换规则',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23128,'Conversion rules',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23128,'轉換規則',9) 
GO

delete from HtmlLabelIndex where id=23135 
GO
delete from HtmlLabelInfo where indexid=23135 
GO
INSERT INTO HtmlLabelIndex values(23135,'归档时是否回写') 
GO
INSERT INTO HtmlLabelInfo VALUES(23135,'归档时是否回写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23135,'if write back when the workflow is over',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23135,'歸檔時是否回寫',9) 
GO

delete from HtmlLabelIndex where id=23138 
GO
delete from HtmlLabelInfo where indexid=23138 
GO
INSERT INTO HtmlLabelIndex values(23138,'更改后需要重启服务才能生效') 
GO
INSERT INTO HtmlLabelInfo VALUES(23138,'更改后需要重启服务才能生效',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(23138,'it is only actived when restart the service after it is changed',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(23138,'更改後需要重啟服務才能生效',9) 
GO
