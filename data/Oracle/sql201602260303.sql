insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'生成条形码','2','3','0','0','','0','170','1','170','生成条形码','0','0' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'批量生成条形码','2','3','0','0','','0','171','1','171','批量生成条形码','1','0' from modeinfo
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('生成条形码','2','3','0','0','','0','170','1','170','生成条形码','0','0')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('批量生成条形码','2','3','0','0','','0','171','1','171','批量生成条形码','1','0')
/
create table mode_barcode(
    id int primary key,
    modeid int,
    isused int,
    resolution varchar2(10),
    codesize varchar2(10),
    codenum varchar2(500),
    info varchar2(2000)
)
/
create sequence mode_barcode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_barcode_id_Tri
before insert on mode_barcode
for each row
begin
selectmode_barcode_id.nextval into :new.id from dual;
end;
/