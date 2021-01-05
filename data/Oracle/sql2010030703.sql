alter table hpelement add shareuser varchar2(1000)
/
update hpelement set shareuser = '5_1' 
/
alter table hpinfo add maintainer varchar2(200)
/
