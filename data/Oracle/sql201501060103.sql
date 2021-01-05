UPDATE workflow_filetypeicon SET iconPath='doc_wev8.png' WHERE extendName = 'docx' OR extendName = 'doc' 
/
UPDATE workflow_filetypeicon SET iconPath='html_wev8.png' WHERE extendName = 'html' 
/
UPDATE workflow_filetypeicon SET iconPath='jpg_wev8.png' WHERE extendName = 'jpg' 
/
UPDATE workflow_filetypeicon SET iconPath='pdf_wev8.png' WHERE extendName = 'pdf' 
/
UPDATE workflow_filetypeicon SET iconPath='ppt_wev8.png' WHERE extendName = 'ppt' 
/
UPDATE workflow_filetypeicon SET iconPath='rar_wev8.png' WHERE extendName = 'rar' 
/
UPDATE workflow_filetypeicon SET iconPath='xls_wev8.png' WHERE extendName = 'xlsx' OR extendName = 'xls' 
/
update workflow_filetypeicon set iconpath = replace(iconpath,'_wev8.png','.png')
/
update workflow_filetypeicon set iconpath = replace(iconpath,'.png','_wev8.png')
/