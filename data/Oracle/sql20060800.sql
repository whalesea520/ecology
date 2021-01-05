update docdetail set docstatus=2  where id in(select approveid from bill_approve where approvetype=9 and status=1)
/