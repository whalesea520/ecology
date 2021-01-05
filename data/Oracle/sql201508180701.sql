alter table mode_dmlactionset add isResetRight int 
/

alter table mode_dmlactionset add targetModeid int 
/

delete from HtmlLabelIndex where id=125371 
/
delete from HtmlLabelInfo where indexid=125371 
/
INSERT INTO HtmlLabelIndex values(125371,'如果不是外部数据源，建议此项设置为空') 
/
INSERT INTO HtmlLabelInfo VALUES(125371,'如果不是外部数据源，建议此项设置为空',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125371,'If it is not external data sources, it is recommended that this setting is empty',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125371,'如果不是外部數據源，建議此項設置爲空',9) 
/

delete from HtmlLabelIndex where id=125368 
/
delete from HtmlLabelInfo where indexid=125368 
/
INSERT INTO HtmlLabelIndex values(125368,'是否重构数据权限') 
/
INSERT INTO HtmlLabelInfo VALUES(125368,'是否重构数据权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125368,'reconstructing data permissions',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125368,'是否重構數據權限',9) 
/
delete from HtmlLabelIndex where id=125369 
/
delete from HtmlLabelInfo where indexid=125369 
/
INSERT INTO HtmlLabelIndex values(125369,'插入数据目标模块') 
/
INSERT INTO HtmlLabelInfo VALUES(125369,'插入数据目标模块',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125369,'insert data to the target module',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125369,'插入數據目标模塊',9) 
/
delete from HtmlLabelIndex where id=125370 
/
delete from HtmlLabelInfo where indexid=125370 
/
INSERT INTO HtmlLabelIndex values(125370,'insert操作时，如果要插入的数据为模块数据，则需要设置此项') 
/
INSERT INTO HtmlLabelInfo VALUES(125370,'insert操作时，如果要插入的数据为模块数据，则需要设置此项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125370,'Insert operations, if the data you want to insert data for the module, you need to set this',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125370,'insert操作時，如果要插入的數據爲模塊數據，則需要設置此項',9) 
/

