UPDATE workflow_filetypeicon SET iconPath='doc_wev8.png' WHERE extendName = 'docx' OR extendName = 'doc' 
GO
UPDATE workflow_filetypeicon SET iconPath='html_wev8.png' WHERE extendName = 'html' 
GO
UPDATE workflow_filetypeicon SET iconPath='jpg_wev8.png' WHERE extendName = 'jpg' 
GO
UPDATE workflow_filetypeicon SET iconPath='pdf_wev8.png' WHERE extendName = 'pdf' 
GO
UPDATE workflow_filetypeicon SET iconPath='ppt_wev8.png' WHERE extendName = 'ppt' 
GO
UPDATE workflow_filetypeicon SET iconPath='rar_wev8.png' WHERE extendName = 'rar' 
GO
UPDATE workflow_filetypeicon SET iconPath='xls_wev8.png' WHERE extendName = 'xlsx' OR extendName = 'xls' 
GO
update workflow_filetypeicon set iconpath = replace(iconpath,'_wev8.png','.png')
GO
update workflow_filetypeicon set iconpath = replace(iconpath,'.png','_wev8.png')
GO