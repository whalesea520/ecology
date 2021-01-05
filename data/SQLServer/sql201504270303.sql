insert into systemlogitem (itemid,lableid,itemdesc,typeid) values  (199,82487,'½»»»ÉèÖÃ',6)
GO
alter table wfec_indatadetail add tablename varchar(100)
GO
alter table  wfec_outdatawfdetail add tablename varchar(100)
GO
alter table wfec_outdatawfdetail add dsporder integer
GO
alter table wfec_indatasetdetail add dsporder integer
GO