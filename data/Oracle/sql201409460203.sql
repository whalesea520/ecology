update WorkPlanUpdate set hasUpdated=1
/
alter table WorkPlanUpdate add hasUpdatedNew char(1)
/
update WorkPlanUpdate set hasUpdatedNew=2
/