delete from HtmlLabelIndex where id=28064 
GO
delete from HtmlLabelInfo where indexid=28064 
GO
INSERT INTO HtmlLabelIndex values(28064,'不需同步字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(28064,'不需同步字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28064,'Fields what is neednot synchronize',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28064,'不需同步字段',9) 
GO
 
delete from HtmlLabelIndex where id=28065 
GO
delete from HtmlLabelInfo where indexid=28065 
GO
INSERT INTO HtmlLabelIndex values(28065,'仅用于Html模式下的模板同步，被勾选的字段，目标字段的显示属性不会被同步') 
GO
INSERT INTO HtmlLabelInfo VALUES(28065,'仅用于Html模式下的模板同步，被勾选的字段，目标字段的显示属性不会被同步',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(28065,'Only for Html-mode.',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(28065,'僅用于Html模式下的模闆同步，被勾選的字段，目标字段的顯示屬性不會被同步',9) 
GO

delete from HtmlLabelIndex where id=27966 
GO
delete from HtmlLabelInfo where indexid=27966 
GO
INSERT INTO HtmlLabelIndex values(27966,'将此模版引用到以下节点') 
GO
INSERT INTO HtmlLabelInfo VALUES(27966,'将此模版引用到以下节点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27966,'Will this template references to the node',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27966,'将此模版引用到以下節點',9) 
GO