insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'����������','2','3','0','0','','0','170','1','170','����������','0','0' from modeinfo
GO
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'��������������','2','3','0','0','','0','171','1','171','��������������','1','0' from modeinfo
GO
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('����������','2','3','0','0','','0','170','1','170','����������','0','0')
GO
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('��������������','2','3','0','0','','0','171','1','171','��������������','1','0')
GO
create table mode_barcode(
    id int identity(1,1) not null,
    modeid int,
    isused int,
    resolution varchar(10),
    codesize varchar(10),
    codenum varchar(500),
    info varchar(2000)
)
GO