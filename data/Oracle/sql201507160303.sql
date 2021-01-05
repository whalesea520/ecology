INSERT INTO mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) VALUES('显示列定制','2','3','0','0','','1','106','1','106','显示列定制','1','0')
/
INSERT INTO mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) SELECT id,'显示列定制','2','3','0','0','','1','106','1','106','显示列定制','1','0' FROM modeinfo
/