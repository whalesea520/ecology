INSERT INTO mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) VALUES('��ʾ�ж���','2','3','0','0','','1','106','1','106','��ʾ�ж���','1','0')
GO
INSERT INTO mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) SELECT id,'��ʾ�ж���','2','3','0','0','','1','106','1','106','��ʾ�ж���','1','0' FROM modeinfo
GO