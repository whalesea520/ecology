UPDATE HtmlLabelIndex SET indexdesc = '系统会更新被转移人的客户,项目,人力资源,文档和归档流程的数量' WHERE id = 18734
GO
UPDATE HtmlLabelInfo SET labelname = '系统会更新被转移人的客户,项目,人力资源,文档和归档流程的数量' WHERE indexid = 18734 AND languageid = 7
GO
UPDATE HtmlLabelInfo SET labelname = 'System will renew the amount of customers,projects,human resources,documents,archive workflow of the man transfer from' WHERE indexid = 18734 AND languageid = 8
GO

INSERT INTO HtmlLabelIndex values(19017,'选择要转移权限的流程,并且只处理归档流程.') 
GO
INSERT INTO HtmlLabelInfo VALUES(19017,'选择要转移权限的流程,并且只处理归档流程.',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19017,'Please choose the workflow you want to change perview and we only accept archive workflow.',8) 
GO