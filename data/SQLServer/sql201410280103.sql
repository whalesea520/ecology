update WorkPlanShareDetail set objId=userid where shareType=1
GO
update WorkPlanShareDetail set objId=userid where shareType=6
GO
update WorkPlanShareDetail set objId=userid where shareType=7
GO
drop index WorkPlanShareDetail_UserID on WorkPlanShareDetail 
GO