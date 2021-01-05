delete from workflow_filetypeicon where extendName='png'
/
insert into workflow_filetypeicon(extendName,iconPath,describe) values('png','jpg_wev8.png','PNG Image')
/
update workflow_filetypeicon set iconPath='other_wev8.png' where iconPath='other_wev8.gif'
/
update workflow_filetypeicon set iconPath='jpg_wev8.png' where extendName in('bmp','gif')
/
update workflow_filetypeicon set iconPath='vedio_wev8.png' where extendName in('asf','asx','avi','rm','rmvb','mp2','mp2v','mpa','mpe','mpg','mpeg','mp4','wmv','wmx')
/
update workflow_filetypeicon set iconPath='voice_wev8.png' where extendName in('mid','midi','mp3','wav')
/
update workflow_filetypeicon set iconPath='exe_wev8.png' where extendName in('bat','exe','jar')
/
update workflow_filetypeicon set iconPath='txt_wev8.png' where extendName in('asp','c','cc','inc','inf','ini','java','jsp','log','sql','txt','vb','vbs')
/
update workflow_filetypeicon set iconPath='rar_wev8.png' where extendName in('tar','tbz','tbz2','zip','iso')
/
update workflow_filetypeicon set iconPath='html_wev8.png' where extendName in('xlshtml','xlsmhtml','xlthtml','xlxml','xml','xsl')
/