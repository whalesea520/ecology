insert into systemlogitem (itemid,lableid,itemdesc,typeid) values  (199,82487,'½»»»ÉèÖÃ',6)
/
alter table wfec_indatadetail add tablename varchar2(100)
/
alter table  wfec_outdatawfdetail add tablename varchar2(100)
/
alter table wfec_outdatawfdetail add dsporder integer
/
alter table wfec_indatasetdetail add dsporder integer
/