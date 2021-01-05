delete from HtmlLabelIndex where id=131396 
GO
delete from HtmlLabelInfo where indexid=131396 
GO
INSERT INTO HtmlLabelIndex values(131396,'覆盖时将替换原人员列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(131396,'覆盖时将替换原人员列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131396,'When overridden, the original staff list will be replaced',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131396,'覆蓋時將替換原人員列表',9) 
GO
delete from HtmlLabelIndex where id=131423 
GO
delete from HtmlLabelInfo where indexid=131423 
GO
INSERT INTO HtmlLabelIndex values(131423,'开启表示查询同时存在所选常用组中的人员') 
GO
INSERT INTO HtmlLabelInfo VALUES(131423,'开启表示查询同时存在所选常用组中的人员',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(131423,'Open the query indicating the presence of people in the selected common group',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(131423,'開啟表示查詢同時存在所選常用組中的人員',9) 
GO
alter table hrmsearchmould drop column groupid 
GO
alter table hrmsearchmould add groupid char(480)
GO
alter table hrmsearchmould add groupVaild char(1)
GO
