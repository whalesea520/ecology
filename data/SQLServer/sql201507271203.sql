alter table WorkPlanSet add showRemider int 
GO
alter table WorkPlanSet add defaultRemider int 
GO
alter table WorkPlanSet add infoDoc int 
GO
alter table WorkPlanSet add infoWf int 
GO
alter table WorkPlanSet add infoCrm int 
GO
alter table WorkPlanSet add infoPrj int 
GO
alter table WorkPlanSet add infoPrjTask int 
GO
alter table WorkPlanSet add dscsDoc int 
GO
alter table WorkPlanSet add dscsWf int 
GO
alter table WorkPlanSet add dscsCrm int 
GO
alter table WorkPlanSet add dscsPrj int 
GO
update WorkPlanSet set showRemider=1,defaultRemider=1,infoDoc=1,infoWf=1,infoCrm=1,infoPrj=1,infoPrjTask=1,dscsDoc=1,dscsWf=1,dscsCrm=1,dscsPrj=1
GO
