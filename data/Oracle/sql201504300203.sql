alter table Prj_TaskProcess add( temprealmandays  number(15,2))     
/
update Prj_TaskProcess set temprealmandays = realmandays 
/
update Prj_TaskProcess set realmandays = '' 
/
ALTER TABLE Prj_TaskProcess modify realmandays  number(15,2)
/
update Prj_TaskProcess set realmandays = temprealmandays 
/
alter table Prj_TaskProcess drop column temprealmandays
/

alter table Prj_TaskProcess add( tempworkday  number(15,2))     
/
update Prj_TaskProcess set tempworkday = workday 
/
update Prj_TaskProcess set workday = '' 
/
ALTER TABLE Prj_TaskProcess modify workday  number(15,2)
/
update Prj_TaskProcess set workday = tempworkday 
/
alter table Prj_TaskProcess drop column tempworkday
/


ALTER TABLE Prj_TaskProcess ADD begintime VARCHAR(10)
/
ALTER TABLE Prj_TaskProcess ADD endtime VARCHAR(10)
/
ALTER TABLE Prj_TaskProcess ADD actualbegintime VARCHAR(10)
/
ALTER TABLE Prj_TaskProcess ADD actualendtime VARCHAR(10)
/
UPDATE Prj_TaskProcess SET begintime ='00:00',endtime='23:59',actualbegintime='00:00',actualendtime='23:59'
/