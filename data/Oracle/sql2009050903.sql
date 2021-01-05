insert into cptcodeset(codeid,showname,showtype,value,codeorder) values (1,'22877',1,0,2)
/

update cptcodeset set value = 5 where showtype = 2 and showname = '18811'
/
update cptcodeset set value = 1 where showtype = 1 and showname = '22877'
/

update cptcode set isuse = 1 
/
alter table cptcode add assetdataflow varchar2(10)
/
alter table cptcapitalcodeseq add assetid int
/
update cptcapitalcodeseq set assetid=-1
/
update cptcode set assetdataflow = 1 
/







