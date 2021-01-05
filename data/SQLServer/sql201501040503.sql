update workflow_filetypeicon set iconpath = replace(iconpath,'_wev8','')
GO
update workflow_filetypeicon set iconpath = replace(iconpath,'.gif','_wev8.gif')
GO
update hpbaseelement set logo = replace(logo,'_wev8','')
GO
update hpbaseelement set logo = replace(logo,'.gif','_wev8.gif')
GO
update hpelement set logo = replace(logo,'_wev8','')
GO
update hpelement set logo = replace(logo,'.gif','_wev8.gif')
GO
update blog_app set iconpath = replace(iconpath,'_wev8','')
GO
update blog_app set iconpath = replace(iconpath,'.png','_wev8.png')
GO
update blog_AppItem set face = replace(face,'_wev8','')
GO
update blog_AppItem set face = replace(face,'.png','_wev8.png')
GO