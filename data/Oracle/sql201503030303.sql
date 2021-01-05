update workflow_filetypeicon set iconPath = replace(iconPath,' ','_') where iconPath like '% %'
/