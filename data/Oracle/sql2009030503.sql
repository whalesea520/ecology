alter table hpFieldLength add imgsize varchar2(50)
/
update hpFieldLength set imgsize = '120*108'
/
alter table imagefile add imgsize varchar2(50)
/
update imagefile set imgsize = '120*108'
/
