update WorkPlanShareDetail set objId=userid where shareType=1
/
update WorkPlanShareDetail set objId=userid where shareType=6
/
update WorkPlanShareDetail set objId=userid where shareType=7
/
drop index WorkPlanShareDetail_UserID
/