insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'生成二维码','2','3','0','0','','0','168','1','11','生成二维码','0','0' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'批量生成二维码','2','3','0','0','','0','169','1','12','批量生成二维码','1','0' from modeinfo
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('生成二维码','2','3','0','0','','0','168','1','11','生成二维码','0','0')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('批量生成二维码','2','3','0','0','','0','169','1','12','批量生成二维码','1','0')
/

create table ModeQRCode
(
   ID INT primary key,
   modeid int,
   targetType int,
   targetUrl varchar(500),
   width INT,
   height INT,
   qrCodeDesc varchar(2000)
)
/
create sequence ModeQRCode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ModeQRCode_id_Tri
before insert on ModeQRCode
for each row
begin
select ModeQRCode_id.nextval into :new.id from dual;
end;
/