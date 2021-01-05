create index SysPoppupRemindInfo_rdx  on SysPoppupRemindInfoNew(requestid)
GO

drop index SysPoppupRemindInfoNew.remindindex
GO
create index remindindex on SysPoppupRemindInfoNew(userid,usertype)
GO

create index sysfavourite_rdx on sysfavourite_favourite(sysfavouriteid)
GO

create index HrmMessagerA_udx on HrmMessagerAccount(userid)
GO

create index workplan_idx on workplan(id)
GO

create index WorkPlanShareDetail_udx on WorkPlanShareDetail(userid)
GO

create index WorkPlan_ridx on WorkPlan(remindDateBeforeEnd,remindTimeBeforeEnd,remindBeforeEnd)
GO

create index WorkPlan_cidx on WorkPlan(crmid)
GO

create index workflow_requestLog_odx on workflow_requestLog(operator,operatortype)
GO

create index sharetypes on CRM_ShareInfo(contents,sharetype)
GO
