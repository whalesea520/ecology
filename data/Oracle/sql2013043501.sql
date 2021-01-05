delete from HtmlLabelIndex where id=31259 
/
delete from HtmlLabelInfo where indexid=31259 
/
INSERT INTO HtmlLabelIndex values(31259,'追加') 
/
delete from HtmlLabelIndex where id=31260 
/
delete from HtmlLabelInfo where indexid=31260 
/
INSERT INTO HtmlLabelIndex values(31260,'覆盖') 
/
INSERT INTO HtmlLabelInfo VALUES(31259,'追加',7) 
/
INSERT INTO HtmlLabelInfo VALUES(31259,'ADD',8) 
/
INSERT INTO HtmlLabelInfo VALUES(31259,'追加',9) 
/
INSERT INTO HtmlLabelInfo VALUES(31260,'覆盖',7) 
/
INSERT INTO HtmlLabelInfo VALUES(31260,'Cover',8) 
/
INSERT INTO HtmlLabelInfo VALUES(31260,'覆蓋',9) 
/

delete from HtmlLabelIndex where id=31261 
/
delete from HtmlLabelInfo where indexid=31261 
/
INSERT INTO HtmlLabelIndex values(31261,'选择导入类型。') 
/
INSERT INTO HtmlLabelInfo VALUES(31261,'选择导入类型。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(31261,'Select the type of import.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(31261,'選擇導入類型。',9) 
/
 
delete from HtmlLabelIndex where id=31262 
/
delete from HtmlLabelInfo where indexid=31262 
/
INSERT INTO HtmlLabelIndex values(31262,'导入类型为“追加”，就是把模版中的数据新增到该模块中；导入类型为“覆盖”会把该模块中所有的数据全部删除，然后再导入模版中的数据，请慎用！') 
/
INSERT INTO HtmlLabelInfo VALUES(31262,'导入类型为“追加”，就是把模版中的数据新增到该模块中；导入类型为“覆盖”会把该模块中所有的数据全部删除，然后再导入模版中的数据，请慎用！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(31262,'Import of type "append", is to add the template data to the module; import type "override" the module will be all delete all the data, and then import the template data, be used with caution!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(31262,'導入類型爲“追加”，就是把模版中的數據新增到該模塊中；導入類型爲“覆蓋”會把該模塊中所有的數據全部删除，然後再導入模版中的數據，請慎用！',9) 
/

delete from HtmlLabelIndex where id=31263 
/
delete from HtmlLabelInfo where indexid=31263 
/
INSERT INTO HtmlLabelIndex values(31263,'导入方式选择“覆盖”会把该模块中所有的数据全部删除，然后再导入模版中的数据，请慎用！') 
/
INSERT INTO HtmlLabelInfo VALUES(31263,'导入方式选择“覆盖”会把该模块中所有的数据全部删除，然后再导入模版中的数据，请慎用！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(31263,'Import options cover all the data in the module will be deleted in its entirety, and then import the data in the template, use it with caution!',8) 
/
INSERT INTO HtmlLabelInfo VALUES(31263,'導入方式選擇“覆蓋”會把該模塊中所有的數據全部删除，然後再導入模版中的數據，請慎用！',9) 
/



