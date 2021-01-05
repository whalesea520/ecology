delete from HtmlLabelIndex where id=128884 
GO
delete from HtmlLabelInfo where indexid=128884 
GO
INSERT INTO HtmlLabelIndex values(128884,'导入说明') 
GO
delete from HtmlLabelIndex where id=128885 
GO
delete from HtmlLabelInfo where indexid=128885 
GO
INSERT INTO HtmlLabelIndex values(128885,'预算科目名称（必填）') 
GO
delete from HtmlLabelIndex where id=128886 
GO
delete from HtmlLabelInfo where indexid=128886 
GO
INSERT INTO HtmlLabelIndex values(128886,'预算科目编码（当科目编码作为重复验证字段时，该字段必填）') 
GO
delete from HtmlLabelIndex where id=128887 
GO
delete from HtmlLabelInfo where indexid=128887 
GO
INSERT INTO HtmlLabelIndex values(128887,'预算科目名称（当科目名称作为重复验证字段时，且该科目非一级科目时，该字段必填）') 
GO
delete from HtmlLabelIndex where id=128888 
GO
delete from HtmlLabelInfo where indexid=128888 
GO
INSERT INTO HtmlLabelIndex values(128888,'预算科目编码（当科目编码作为重复验证字段时，且该科目非一级科目时，该字段必填）') 
GO
delete from HtmlLabelIndex where id=128889 
GO
delete from HtmlLabelInfo where indexid=128889 
GO
INSERT INTO HtmlLabelIndex values(128889,'可选值：每月、每季度、每半年、每年（一级科目必填）') 
GO
delete from HtmlLabelIndex where id=128890 
GO
delete from HtmlLabelInfo where indexid=128890 
GO
INSERT INTO HtmlLabelIndex values(128890,'同一科目上下级条线中只有一个科目可以开启可编制预算选项') 
GO
delete from HtmlLabelIndex where id=128891 
GO
delete from HtmlLabelInfo where indexid=128891 
GO
INSERT INTO HtmlLabelIndex values(128891,'开启可编制预算的科目必填，可选值：是、否') 
GO
delete from HtmlLabelIndex where id=128892 
GO
delete from HtmlLabelInfo where indexid=128892 
GO
INSERT INTO HtmlLabelIndex values(128892,'可选值：未封存、已封存（为空表示未封存）') 
GO
delete from HtmlLabelIndex where id=128893 
GO
delete from HtmlLabelInfo where indexid=128893 
GO
INSERT INTO HtmlLabelIndex values(128893,'整数') 
GO
delete from HtmlLabelIndex where id=128894 
GO
delete from HtmlLabelInfo where indexid=128894 
GO
INSERT INTO HtmlLabelIndex values(128894,'可选值：收入、支出（为空表示支出）') 
GO
delete from HtmlLabelIndex where id=128895 
GO
delete from HtmlLabelInfo where indexid=128895 
GO
INSERT INTO HtmlLabelIndex values(128895,'文本') 
GO
delete from HtmlLabelIndex where id=128896 
GO
delete from HtmlLabelInfo where indexid=128896 
GO
INSERT INTO HtmlLabelIndex values(128896,'整数部分最多三位，小数部分最多三位的数字（可为负数）') 
GO
INSERT INTO HtmlLabelInfo VALUES(128896,'整数部分最多三位，小数部分最多三位的数字（可为负数）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128896,'Integer part of up to three, the number of decimal places up to three digits (can be negative)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128896,'整數部分最多三位，小數部分最多三位的數字（可爲負數）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128895,'文本',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128895,'text',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128895,'文本',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128894,'可选值：收入、支出（为空表示支出）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128894,'Optional value: income, expenditure (as an empty representation)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128894,'可選值：收入、支出（爲空表示支出）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128893,'整数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128893,'integer',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128893,'整數',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128892,'可选值：未封存、已封存（为空表示未封存）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128892,'Optional value: not sealed, has been sealed (for the space that is not sealed)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128892,'可選值：未封存、已封存（爲空表示未封存）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128891,'开启可编制预算的科目必填，可选值：是、否',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128891,'Open account required, budgeting can be optional: Yes or no',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128891,'開啓可編制預算的科目必填，可選值：是、否',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128890,'同一科目上下级条线中只有一个科目可以开启可编制预算选项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128890,'Only one subject in the same subject can be turned on to prepare budget options.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128890,'同一科目上下級條線中隻有一個科目可以開啓可編制預算選項',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128889,'可选值：每月、每季度、每半年、每年（一级科目必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128889,'Optional: monthly, quarterly, half yearly, annual (a subject required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128889,'可選值：每月、每季度、每半年、每年（一級科目必填）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128888,'预算科目编码（当科目编码作为重复验证字段时，且该科目非一级科目时，该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128888,'The budget items (when subjects encoding encoding as the replicated field, and the subject is not a primary subject, the field is required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128888,'預算科目編碼（當科目編碼作爲重複驗證字段時，且該科目非一級科目時，該字段必填）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128887,'预算科目名称（当科目名称作为重复验证字段时，且该科目非一级科目时，该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128887,'The budget subject name (when the subject name as a replicated field, and the subject is not a primary subject, the field is required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128887,'預算科目名稱（當科目名稱作爲重複驗證字段時，且該科目非一級科目時，該字段必填）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128886,'预算科目编码（当科目编码作为重复验证字段时，该字段必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128886,'The budget items (when subjects encoding encoding as the replicated field, the field is required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128886,'預算科目編碼（當科目編碼作爲重複驗證字段時，該字段必填）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128885,'预算科目名称（必填）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128885,'Budget account name (Required)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128885,'預算科目名稱（必填）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(128884,'导入说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128884,'Import description',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128884,'導入說明',9) 
GO
delete from HtmlLabelIndex where id=128883 
GO
delete from HtmlLabelInfo where indexid=128883 
GO
INSERT INTO HtmlLabelIndex values(128883,'请按【下载模板】中的【导入说明】填入科目数据后进行批量导入') 
GO
INSERT INTO HtmlLabelInfo VALUES(128883,'请按【下载模板】中的【导入说明】填入科目数据后进行批量导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128883,'Please click [download template] [import description] in the subject data into the batch import',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128883,'請按【下載模闆】中的【導入說明】填入科目數據後進行批量導入',9) 
GO
delete from HtmlLabelIndex where id=128898 
GO
delete from HtmlLabelInfo where indexid=128898 
GO
INSERT INTO HtmlLabelIndex values(128898,'不能大于9层') 
GO
INSERT INTO HtmlLabelInfo VALUES(128898,'不能大于9层',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128898,'Can not be more than 9 layers',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128898,'不能大于9層',9) 
GO
delete from HtmlLabelIndex where id=128899 
GO
delete from HtmlLabelInfo where indexid=128899 
GO
INSERT INTO HtmlLabelIndex values(128899,'科目层级只能在1~9级之间') 
GO
INSERT INTO HtmlLabelInfo VALUES(128899,'科目层级只能在1~9级之间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(128899,'The level of the subject can only be between 1~9 levels',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(128899,'科目層級隻能在1~9級之間',9) 
GO
