delete from HtmlLabelIndex where id=23151 
/
delete from HtmlLabelInfo where indexid=23151 
/
INSERT INTO HtmlLabelIndex values(23151,'触发说明3') 
/
delete from HtmlLabelIndex where id=23152 
/
delete from HtmlLabelInfo where indexid=23152 
/
INSERT INTO HtmlLabelIndex values(23152,'触发说明4') 
/
INSERT INTO HtmlLabelInfo VALUES(23151,'外部主表中必须要有id(唯一主键),FtriggerFlag(char(1)型,已读标记),requestid(整型,请求id)这三个字段, FtriggerFlag的初始值必须为’0’，并且在填写“外部主表回写设置”时不能设置FtriggerFlag和requestid这两个字段，这两个字段自动回写；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23151,'remark3',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23151,'外部主表中必須要有id(唯一主鍵),FtriggerFlag(char(1)型,已讀標記),requestid(整型,請求id)這三個字段, FtriggerFlag的初始值必須為’0’，並且在填寫“外部主表回寫設置”時不能設置FtriggerFlag和requestid這兩個字段，這兩個字段自動回寫；',9) 
/
INSERT INTO HtmlLabelInfo VALUES(23152,'FtriggerFlag=0表示未读，FtriggerFlag=1表示已读，requestid=0表示流程创建人对应的外部字段值为空，requestid=-1表示外部字段保存的人员信息在oa中不存在，requestid=-2表示未知原因导致流程触发未成功。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23152,'remark4',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23152,'FtriggerFlag=0表示未讀，FtriggerFlag=1表示已讀，requestid=0表示流程創建人對應的外部字段值為空，requestid=-1表示外部字段保存的人員信息在oa中不存在，requestid=-2表示未知原因導致流程觸發未成功。',9) 
/

delete from HtmlLabelIndex where id=23111 
/
delete from HtmlLabelInfo where indexid=23111 
/
INSERT INTO HtmlLabelIndex values(23111,'触发说明1') 
/
INSERT INTO HtmlLabelInfo VALUES(23111,'该流程自动触发时，将根据外部主表条件搜索外部主表，有多少条记录即触发多少条流程；流程主字段的值来源于外部主表，而每条流程的各明细值将分别根据明细表条件搜索明细表得到的结果进行赋值；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23111,'remark1',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23111,'該流程自動觸發時，將根據外部主表條件搜索外部主表，有多少條記錄即觸發多少條流程；流程主字段的值來源於外部主表，而每條流程的各明細值將分別根據明細表條件搜索明細表得到的結果進行賦值；',9) 
/

delete from HtmlLabelIndex where id=23154 
/
delete from HtmlLabelInfo where indexid=23154 
/
INSERT INTO HtmlLabelIndex values(23154,'触发说明1') 
/
INSERT INTO HtmlLabelInfo VALUES(23154,'主表中必须包含id(主键)，requestid(请求id，整型)，FTriggerFlag(已读未读标记位，初始值必须为0，表示未读，读取后会自动更新为1)这三个字段；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23154,'reamrk1.1',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23154,'主表中必須包含id(主鍵)，requestid(請求id，整型)，FTriggerFlag(已讀未讀標記位，初始值必須為0，表示未讀，讀取後會自動更新為1)這三個字段；',9) 
/

delete from HtmlLabelIndex where id=23110 
/
delete from HtmlLabelInfo where indexid=23110 
/
INSERT INTO HtmlLabelIndex values(23110,'触发说明2') 
/
INSERT INTO HtmlLabelInfo VALUES(23110,'条件以“where”开头，如：“where fieldname1=1 and fieldname2=''value2''”；回写设置以“set”开头，如：“set flag=1,isok=true”，FtriggerFlag和requestid字段自动更新，不能在此设置；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23110,'condition begin with "where",such as "where where fieldname1=1 and fieldname2=''value2''",return sql begin with',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23110,'條件以“where”開頭，如：“where fieldname1=1 and fieldname2=''value2''”；回寫設置以“set”開頭，如：“set flag=1,isok=true”，FtriggerFlag和requestid字段自動更新，不能在此設置；',9) 
/

delete from HtmlLabelIndex where id=23152 
/
delete from HtmlLabelInfo where indexid=23152 
/
INSERT INTO HtmlLabelIndex values(23152,'触发说明4') 
/
INSERT INTO HtmlLabelInfo VALUES(23152,'流程触发时会回写外部主表，FtriggerFlag=0表示未读，FtriggerFlag=1表示已读，requestid=0表示流程创建人对应的外部字段值为空，requestid=-1表示外部字段保存的人员信息在oa中不存在，requestid=-2表示未知原因导致流程触发未成功。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23152,'remark4',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23152,'流程觸發時會回寫外部主表，FtriggerFlag=0表示未讀，FtriggerFlag=1表示已讀，requestid=0表示流程創建人對應的外部字段值為空，requestid=-1表示外部字段保存的人員信息在oa中不存在，requestid=-2表示未知原因導致流程觸發未成功。',9) 
/

delete from HtmlLabelIndex where id=23155 
/
delete from HtmlLabelInfo where indexid=23155 
/
INSERT INTO HtmlLabelIndex values(23155,'固定创建人选择') 
/
INSERT INTO HtmlLabelInfo VALUES(23155,'固定创建人选择',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23155,'choose the creater',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23155,'固定创建人选择',9) 
/

delete from HtmlLabelIndex where id=23123 
/
delete from HtmlLabelInfo where indexid=23123 
/
INSERT INTO HtmlLabelIndex values(23123,'选择外部字段与流程字段一一对应，在将外部字段赋值的过程中，如果外部字段的数据库类型与流程字段类型不匹配将按以下规则处理：') 
/
INSERT INTO HtmlLabelInfo VALUES(23123,'选择外部字段与流程字段一一对应，在将外部字段赋值的过程中，如果外部字段的数据库类型与流程字段类型不匹配将按以下规则处理：',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23123,'Select the external field-one correspondence with the flow field, external field in the process of assignment, if the external database field types and field types do not match the process according to the following rules:',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23123,'選擇外部字段與流程字段一一對應，在將外部字段賦值的過程中，如果外部字段的數據庫類型與流程字段類型不匹配將按以下規則處理：',9) 
/

delete from HtmlLabelIndex where id=23124 
/
delete from HtmlLabelInfo where indexid=23124 
/
INSERT INTO HtmlLabelIndex values(23124,'流程字段是字符型，如果外部数据超长，则对外部数据进行截位后赋值给流程字段；') 
/
delete from HtmlLabelIndex where id=23125 
/
delete from HtmlLabelInfo where indexid=23125 
/
INSERT INTO HtmlLabelIndex values(23125,'流程字段是整型或浮点型，如果外部数据为字符，则赋值-1给流程字段。') 
/
INSERT INTO HtmlLabelInfo VALUES(23124,'流程字段是字符型，如果外部数据超长，则对外部数据进行截位后赋值给流程字段；',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23124,'flow field is character, if the long external data, external data on post-cut-off value to the process field;',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23124,'流程字段是字符型，如果外部數據超長，則對外部數據進行截位後賦值給流程字段；',9) 
/
INSERT INTO HtmlLabelInfo VALUES(23125,'流程字段是整型或浮点型，如果外部数据为字符，则赋值-1给流程字段。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23125,'flow field is integer or floating-point type, if the external data for the characters, -1 is assigned to the flow field.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23125,'流程字段是整型或浮點型，如果外部數據為字符，則賦值-1給流程字段。',9) 
/

delete from HtmlLabelIndex where id=23157 
/
delete from HtmlLabelInfo where indexid=23157 
/
INSERT INTO HtmlLabelIndex values(23157,'创建人设定') 
/
INSERT INTO HtmlLabelInfo VALUES(23157,'创建人可以在转换规则中选择“固定创建人选择”，选择的人员即做为触发流程的创建人，如果没有选择，则以系统管理员做为创建人。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(23157,'about the creater',8) 
/
INSERT INTO HtmlLabelInfo VALUES(23157,'創建人可以在轉換規則中選擇“固定創建人選擇”，選擇的人員即做為觸發流程的創建人，如果沒有選擇，則以系統管理員做為創建人。',9) 
/
