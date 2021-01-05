update HrmAnnualLeaveInfo set leaveType = (case when leaveType between 1 and 3 then (select min(id) from hrm_leave_type where field004 = leaveType and field005 = 'leaveType' group by field004) else (select min(id) from hrm_leave_type where field004 = otherLeaveType and field005 = 'otherLeaveType' group by field004) end) where ((leaveType between 1 and 4) or (otherLeaveType !=0))
GO
