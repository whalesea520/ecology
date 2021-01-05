insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) values('保存并新建','2','3','0','0','','1','9','1','10')
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag) select id,'保存并新建','2','3','0','0','','1','9','1','10' from modeinfo
/