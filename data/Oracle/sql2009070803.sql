alter table hpsetting_wfcenter add  showCopy varchar2(5)
/
update hpsetting_wfcenter set showCopy = '1'
/