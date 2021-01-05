delete from HtmlLabelIndex where id=21536 
GO
delete from HtmlLabelInfo where indexid=21536 
GO
INSERT INTO HtmlLabelIndex values(21536,'该子目录无法删除。') 
GO
INSERT INTO HtmlLabelInfo VALUES(21536,'该子目录下有文档存在，或被流程字段中的选择框所绑定，或被流程创建文档中设置所绑定，或者被协作附件设置所绑定，无法删除。',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21536,'The category can not be deleted,because it was bound by any other config.',8) 
GO
