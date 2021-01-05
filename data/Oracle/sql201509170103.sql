alter table WorkPlanSet add infoaccessory int
/
alter table WorkPlanSet add infoaccessorydir VARCHAR2(10)
/
alter table WorkPlanSet add dscsaccessory int
/
alter table WorkPlanSet add dscsaccessorydir VARCHAR2(10)
/
alter table WorkPlan add attachs VARCHAR2(1000)
/
update WorkPlanSet set infoaccessory=0,infoaccessorydir='',dscsaccessory=0,dscsaccessorydir=''
/