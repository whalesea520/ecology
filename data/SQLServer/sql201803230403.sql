alter table WorkPlanShareSet add companyVirtual varchar(500)
GO
alter table WorkPlanShare add companyVirtual varchar(500)
GO
alter table WorkPlanCreateShareSet add companyVirtual varchar(500)
GO
update WorkPlanShareSet set companyVirtual  = '1' where sharetype = 6
GO
update WorkPlanShare set companyVirtual  = '1' where sharetype = 6
GO
update WorkPlanCreateShareSet set companyVirtual  = '1' where sharetype = 6
GO