delete from HtmlLabelIndex where id=21099 
GO
delete from HtmlLabelInfo where indexid=21099 
GO
INSERT INTO HtmlLabelIndex values(21099,'（从表单上的单文本字段中选择，生成文档的文档编号会赋给该字段。）') 
GO
delete from HtmlLabelIndex where id=21100 
GO
delete from HtmlLabelInfo where indexid=21100 
GO
INSERT INTO HtmlLabelIndex values(21100,'（从表单上的单文档浏览框中选择，会链接流程生成的文档。）') 
GO
delete from HtmlLabelIndex where id=21101 
GO
delete from HtmlLabelInfo where indexid=21101 
GO
INSERT INTO HtmlLabelIndex values(21101,'（从表单上的单文本字段中选择，该字段的值将赋给生成文档的文档标题。）') 
GO
delete from HtmlLabelIndex where id=21102 
GO
delete from HtmlLabelInfo where indexid=21102 
GO
INSERT INTO HtmlLabelIndex values(21102,'（从表单上的选择框字段中选择，会按照选定字段值对应的目录存放文档。）') 
GO
delete from HtmlLabelIndex where id=21098 
GO
delete from HtmlLabelInfo where indexid=21098 
GO
INSERT INTO HtmlLabelIndex values(21098,'文档标题字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(21098,'文档标题字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21098,'Document Title Field',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21099,'（从表单上的单文本字段中选择，生成文档的文档编号会赋给该字段。）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21099,'(It is chose from the single text field of form.The Number of created Document will be given it.)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21100,'（从表单上的单文档浏览框中选择，会链接流程生成的文档。）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21100,'(It is chose from the single document browser field of form.It will be linked to the created Document.)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21101,'（从表单上的单文本字段中选择，该字段的值将赋给生成文档的文档标题。）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21101,'(It is chose from the single text field of form.Its value will be given to the title of created Document.)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21102,'（从表单上的选择框字段中选择，会按照选定字段值对应的目录存放文档。）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21102,'(It is chose from the celect combo field of form.The created Document will be saved by the catalog of the field value corresponding.)',8) 
GO
