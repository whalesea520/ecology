alter table WorkPlanSet add infoaccessory int 
GO
alter table WorkPlanSet add infoaccessorydir VARCHAR(10) 
GO
alter table WorkPlanSet add dscsaccessory int 
GO
alter table WorkPlanSet add dscsaccessorydir VARCHAR(10) 
GO
alter table WorkPlan add attachs VARCHAR(1000)
GO
update WorkPlanSet set infoaccessory=0,infoaccessorydir='',dscsaccessory=0,dscsaccessorydir=''
GO
