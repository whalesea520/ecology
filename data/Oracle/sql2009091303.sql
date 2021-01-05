alter table hpFieldLength add imgtype varchar2(1) null
/
alter table hpFieldLength add imgsrc varchar2(200) null
/
update hpFieldLength set imgtype='0'
/