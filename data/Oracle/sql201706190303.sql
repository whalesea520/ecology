alter table hrmgroupmembers rename column dsporder to dsporder_old
/
alter table hrmgroupmembers add dsporder number(18,1)
/
update hrmgroupmembers set dsporder=dsporder_old
/
alter table hrmgroupmembers drop column  dsporder_old
/
alter table hrmuserdefine add hasgroup char(1)
/
update hrmuserdefine set hasgroup = '1'
/
alter table hrmsearchmould add groupid varchar2(1000)
/
