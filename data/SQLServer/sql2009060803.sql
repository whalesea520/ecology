delete from workflow_filetypeicon where extendname in('docx','xlsx','pptx')
GO
insert into workflow_filetypeicon (extendname, iconpath, describe)
values ('docx', 'word2007.gif', 'Microsoft Word 2007')
GO
insert into workflow_filetypeicon (extendname, iconpath, describe)
values ('xlsx', 'excel2007.gif', 'Microsoft Excel 2007')
GO
insert into workflow_filetypeicon (extendname, iconpath, describe)
values ('pptx', 'ppt2007.gif', 'Microsoft PowerPoint 2007')
GO