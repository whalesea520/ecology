alter table WorkPlanShareSet add companyVirtual varchar2(500)
/
alter table WorkPlanShare add companyVirtual varchar2(500)
/
alter table WorkPlanCreateShareSet add companyVirtual varchar2(500)
/
update WorkPlanShareSet set companyVirtual  = '1' where sharetype = 6
/
update WorkPlanShare set companyVirtual  = '1' where sharetype = 6
/
update WorkPlanCreateShareSet set companyVirtual  = '1' where sharetype = 6
/