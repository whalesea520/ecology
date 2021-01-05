alter table WorkPlanSet add showRemider int 
/
alter table WorkPlanSet add defaultRemider int 
/
alter table WorkPlanSet add infoDoc int 
/
alter table WorkPlanSet add infoWf int 
/
alter table WorkPlanSet add infoCrm int 
/
alter table WorkPlanSet add infoPrj int 
/
alter table WorkPlanSet add infoPrjTask int 
/
alter table WorkPlanSet add dscsDoc int 
/
alter table WorkPlanSet add dscsWf int 
/
alter table WorkPlanSet add dscsCrm int 
/
alter table WorkPlanSet add dscsPrj int 
/
update WorkPlanSet set showRemider=1,defaultRemider=1,infoDoc=1,infoWf=1,infoCrm=1,infoPrj=1,infoPrjTask=1,dscsDoc=1,dscsWf=1,dscsCrm=1,dscsPrj=1
/
