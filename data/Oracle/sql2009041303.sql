update workflow_billfield set fielddbtype = 'number(15,2)' where billid = 180 and fieldname = 'leaveDays'
/
alter table Bill_BoHaiLeave add tempcol varchar2(10)
/
update Bill_BoHaiLeave set tempcol = leaveDays
/
alter table Bill_BoHaiLeave drop column leaveDays
/
alter table Bill_BoHaiLeave add leaveDays number(15,2)
/
update Bill_BoHaiLeave set leaveDays = tempcol
/
alter table Bill_BoHaiLeave drop column tempcol
/


