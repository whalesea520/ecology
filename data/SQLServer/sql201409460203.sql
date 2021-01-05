update WorkPlanUpdate set hasUpdated=1
go
alter table WorkPlanUpdate add hasUpdatedNew char(1)
go
update WorkPlanUpdate set hasUpdatedNew=2
go