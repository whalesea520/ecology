delete from HtmlLabelIndex where id=27669 
GO
delete from HtmlLabelInfo where indexid=27669 
GO
INSERT INTO HtmlLabelIndex values(27669,'隐藏字段信息') 
GO
delete from HtmlLabelIndex where id=27670 
GO
delete from HtmlLabelInfo where indexid=27670 
GO
INSERT INTO HtmlLabelIndex values(27670,'sql语句') 
GO
delete from HtmlLabelIndex where id=27671 
GO
delete from HtmlLabelInfo where indexid=27671 
GO
INSERT INTO HtmlLabelIndex values(27671,'存储过程') 
GO
delete from HtmlLabelIndex where id=27672 
GO
delete from HtmlLabelInfo where indexid=27672 
GO
INSERT INTO HtmlLabelIndex values(27672,'请先选择数据源') 
GO
delete from HtmlLabelIndex where id=27673 
GO
delete from HtmlLabelInfo where indexid=27673 
GO
INSERT INTO HtmlLabelIndex values(27673,'请谨慎使用update，delete操作') 
GO
delete from HtmlLabelIndex where id=27674 
GO
delete from HtmlLabelInfo where indexid=27674 
GO
INSERT INTO HtmlLabelIndex values(27674,'只能同步当前流程主表数据的到其他数据表中') 
GO
delete from HtmlLabelIndex where id=27675 
GO
delete from HtmlLabelInfo where indexid=27675 
GO
INSERT INTO HtmlLabelIndex values(27675,'如果DML类型为update、delete，那么必须有DML主表条件或者自定义主表条件，否则此DML不被执行') 
GO
delete from HtmlLabelIndex where id=27676 
GO
delete from HtmlLabelInfo where indexid=27676 
GO
INSERT INTO HtmlLabelIndex values(27676,'对各数据库中大对象数据类型字段，以及二进制数据类型字段不做同步，具体如下') 
GO
delete from HtmlLabelIndex where id=27677 
GO
delete from HtmlLabelInfo where indexid=27677 
GO
INSERT INTO HtmlLabelIndex values(27677,'对于自定义主表条件，具体格式如下') 
GO
delete from HtmlLabelIndex where id=27678 
GO
delete from HtmlLabelInfo where indexid=27678 
GO
INSERT INTO HtmlLabelIndex values(27678,'流程字段名称') 
GO
delete from HtmlLabelIndex where id=27679 
GO
delete from HtmlLabelInfo where indexid=27679 
GO
INSERT INTO HtmlLabelIndex values(27679,'sql中') 
GO
delete from HtmlLabelIndex where id=27680 
GO
delete from HtmlLabelInfo where indexid=27680 
GO
INSERT INTO HtmlLabelIndex values(27680,'以字段名开始(不能以where或者and开始)，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型决定。') 
GO
delete from HtmlLabelIndex where id=27681 
GO
delete from HtmlLabelInfo where indexid=27681 
GO
INSERT INTO HtmlLabelIndex values(27681,'对于自定义主表DML语句，具体格式如下') 
GO
delete from HtmlLabelIndex where id=27682 
GO
delete from HtmlLabelInfo where indexid=27682 
GO
INSERT INTO HtmlLabelIndex values(27682,'{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型,以及字段类型决定。') 
GO
delete from HtmlLabelIndex where id=27683 
GO
delete from HtmlLabelInfo where indexid=27683 
GO
INSERT INTO HtmlLabelIndex values(27683,'由于各数据库中，日期数据类型不同，为保证数据正确同步，建议使用自定义主表DML语句，比如') 
GO
delete from HtmlLabelIndex where id=27684 
GO
delete from HtmlLabelInfo where indexid=27684 
GO
INSERT INTO HtmlLabelIndex values(27684,'自定义主表DML语句类型为存储过程时，各数据库调用方式如下(未列出的数据库请参看各数据库帮助)') 
GO
delete from HtmlLabelIndex where id=27685 
GO
delete from HtmlLabelInfo where indexid=27685 
GO
INSERT INTO HtmlLabelIndex values(27685,'不正确') 
GO
delete from HtmlLabelIndex where id=27686 
GO
delete from HtmlLabelInfo where indexid=27686 
GO
INSERT INTO HtmlLabelIndex values(27686,'请重新输入') 
GO
delete from HtmlLabelIndex where id=27687 
GO
delete from HtmlLabelInfo where indexid=27687 
GO
INSERT INTO HtmlLabelIndex values(27687,'显示字段信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(27669,'隐藏字段信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27669,'Hidden field information',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27669,'隐藏字段信息',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27670,'sql语句',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27670,'sql statement',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27670,'sql語句',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27671,'存储过程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27671,'Stored Procedures',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27671,'存儲過程',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27672,'请先选择数据源',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27672,'Please select the data source',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27672,'請先選擇數據源',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27673,'请谨慎使用update，delete操作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27673,'Please use caution update, delete operation',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27673,'請謹慎使用update，delete操作',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27674,'只能同步当前流程主表数据的到其他数据表中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27674,'The current process can only sync the main table of data to other data tables',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27674,'隻能同步當前流程主表數據的到其他數據表中',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27675,'如果DML类型为update、delete，那么必须有DML主表条件或者自定义主表条件，否则此DML不被执行',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27675,'If the DML type of update, delete, then there must be conditions for the main table or DML to customize the main table, otherwise this will not be executed DML',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27675,'如果DML類型爲update、delete，那麽必須有DML主表條件或者自定義主表條件，否則此DML不被執行',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27676,'对各数据库中大对象数据类型字段，以及二进制数据类型字段不做同步，具体如下',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27676,'Large object in the database for each data type field, and do not do synchronous binary data type fields, as follows',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27676,'對各數據庫中大對象數據類型字段，以及二進制數據類型字段不做同步，具體如下',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27677,'对于自定义主表条件，具体格式如下',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27677,'For custom master table conditions, the following format',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27677,'對于自定義主表條件，具體格式如下',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27678,'流程字段名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27678,'Flow field name',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27678,'流程字段名稱',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27679,'sql中',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27679,'in sql',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27679,'sql中',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27680,'以字段名开始(不能以where或者and开始)，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型决定。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27680,'Field names begin with (and can not be started or where), {? Flow field name *} will be replaced with the corresponding flow field data. Specific sql format, according to the type of data source database.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27680,'以字段名開始(不能以where或者and開始)，{?流程字段名稱*}将會被替換爲流程中的對應字段的數據。具體sql格式，根據數據源數據庫類型決定。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27681,'对于自定义主表DML语句，具体格式如下',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27681,'Customize the main table for DML statements, the following format',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27681,'對于自定義主表DML語句，具體格式如下',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27682,'{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型,以及字段类型决定。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27682,'{? Flow field name *} will be replaced with the corresponding flow field data. Specific sql format, according to the source database data types, and field type.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27682,'{?流程字段名稱*}将會被替換爲流程中的對應字段的數據。具體sql格式，根據數據源數據庫類型,以及字段類型決定。',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27683,'由于各数据库中，日期数据类型不同，为保证数据正确同步，建议使用自定义主表DML语句，比如',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27683,'As a result of the database, the date data types, in order to ensure proper synchronization of data, it is recommended to use a custom master table DML statements, such as',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27683,'由于各數據庫中，日期數據類型不同，爲保證數據正确同步，建議使用自定義主表DML語句，比如',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27684,'自定义主表DML语句类型为存储过程时，各数据库调用方式如下(未列出的数据库请参看各数据库帮助)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27684,'Customize the type of DML statement is the main table when the stored procedure call to the database as follows (not listed in the database, see the database to help)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27684,'自定義主表DML語句類型爲存儲過程時，各數據庫調用方式如下(未列出的數據庫請參看各數據庫幫助)',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27685,'不正确',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27685,'Incorrect',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27685,'不正确',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27686,'请重新输入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27686,'Please re-enter',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27686,'請重新輸入',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27687,'显示字段信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27687,'Display field information',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27687,'顯示字段信息',9) 
GO
