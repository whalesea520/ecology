INSERT INTO HtmlLabelIndex values(19569,'增加按钮') 
GO
INSERT INTO HtmlLabelIndex values(19573,'表尾标签') 
GO
INSERT INTO HtmlLabelIndex values(19571,'选择框标签') 
GO
INSERT INTO HtmlLabelIndex values(19572,'表头标签') 
GO
INSERT INTO HtmlLabelIndex values(19570,'删除按钮') 
GO
INSERT INTO HtmlLabelInfo VALUES(19569,'增加按钮',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19569,'add button',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19570,'删除按钮',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19570,'delete button',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19571,'选择框标签',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19571,'SelectCombo label',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19572,'表头标识',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19572,'head label',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19573,'表尾标识',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19573,'end label',8) 
GO
INSERT INTO HtmlLabelIndex values(19574,'第一行前不能加入表头标识！') 
GO
INSERT INTO HtmlLabelInfo VALUES(19574,'第一行前不能加入表头标识！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19574,'can not add head label of first row',8) 
GO
update HtmlLabelInfo set labelname='All closed' where indexid=16348 and languageid=8
go
update HtmlLabelInfo set labelname='All pending' where indexid=16347 and languageid=8
go

update HtmlLabelInfo set labelname='Node type' where indexid=15536 and languageid=8
go
update HtmlLabelInfo set labelname='Receive date' where indexid=17994 and languageid=8
go
update HtmlLabelInfo set labelname='Ergency degree' where indexid=15534 and languageid=8
go