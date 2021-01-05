delete from HrmAnnualLeaveInfo
/
insert into HrmAnnualLeaveInfo (requestid,resourceid,startdate,starttime,enddate,endtime,leavetime,leavetype,otherleavetype,status) select a.requestid,a.resourceid,a.fromdate,a.fromtime,a.todate,a.totime,a.leavedays,a.leavetype,a.otherleavetype,1 from Bill_BoHaiLeave a,workflow_requestbase b where a.requestid = b.requestid and b.currentnodetype = 3
/