/*dongping 修改icon图片在显示的时候会出问题*/
update workflow_filetypeicon set iconpath ='excel.gif' where extendName='xls'
/
update workflow_filetypeicon set iconpath ='word.gif' where extendName='doc'
/
update workflow_filetypeicon set iconpath ='html.gif' where extendName='html' or extendName='htm'
/
insert into workflow_filetypeicon (extendName,iconpath,describe) values('other','other.gif','其它文件')
/
