delete from HtmlLabelIndex where id=21631 
GO
delete from HtmlLabelInfo where indexid=21631 
GO
INSERT INTO HtmlLabelIndex values(21631,'是否必须保留痕迹') 
GO
delete from HtmlLabelIndex where id=21632 
GO
delete from HtmlLabelInfo where indexid=21632 
GO
INSERT INTO HtmlLabelIndex values(21632,'是否取消审阅') 
GO
INSERT INTO HtmlLabelInfo VALUES(21631,'是否必须保留痕迹',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21631,'hold mark or not',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21632,'是否取消审阅',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21632,'Cancel check or not',8) 
GO
delete from HtmlLabelIndex where id=21638 
GO
delete from HtmlLabelInfo where indexid=21638 
GO
INSERT INTO HtmlLabelIndex values(21638,'正文的修改痕迹一律不能被清除') 
GO
delete from HtmlLabelIndex where id=21637 
GO
delete from HtmlLabelInfo where indexid=21637 
GO
INSERT INTO HtmlLabelIndex values(21637,'除第一次在创建节点外，其余对正文的修改都将被保留痕迹') 
GO
INSERT INTO HtmlLabelInfo VALUES(21637,'除第一次在创建节点外，其余对正文的修改都将被保留痕迹',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21637,'Except the first create node, all mark will be saved',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21638,'正文的修改痕迹一律不能被清除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21638,'The mark of the content cannot be clean out',8) 
GO
