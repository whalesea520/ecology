insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'���ɶ�ά��','2','3','0','0','','0','168','1','11','���ɶ�ά��','0','0' from modeinfo
go
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'�������ɶ�ά��','2','3','0','0','','0','169','1','12','�������ɶ�ά��','1','0' from modeinfo
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('���ɶ�ά��','2','3','0','0','','0','168','1','11','���ɶ�ά��','0','0')
go
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('�������ɶ�ά��','2','3','0','0','','0','169','1','12','�������ɶ�ά��','1','0')
go
create table ModeQRCode
(
   ID INT primary key identity(1,1),
   modeid int,
   targetType int,
   targetUrl varchar(500),
   width INT,
   height INT,
   qrCodeDesc varchar(2000)
)
GO