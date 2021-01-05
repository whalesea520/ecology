update workflow_billfield set billid = 0 where billid = 180 and fieldname in ('leaveType','otherLeaveType')
GO
update workflow_browserurl set browserurl = '/systeminfo/BrowserMain.jsp?url=/hrm/attendance/hrmLeaveTypeColor/browser.jsp', tablename = 'hrmLeaveTypeColor', columname = 'field001', keycolumname = 'field004', linkurl = '' where id = 34
GO
delete from workflow_nodeform where nodeid in (select t2.id from workflow_flownode t1 left join workflow_nodebase t2 on t2.id = t1.nodeid where t1.workflowid in (select id from workflow_base where formid = 180) and (t2.IsFreeNode is null or t2.IsFreeNode!='1')) and fieldid in (select t1.id from workflow_billfield t1 where t1.fieldname = 'newLeaveType')
GO
insert into workflow_nodeform(nodeid,fieldid,isview,isedit,ismandatory,orderid) select nodeid,(select t1.id from workflow_billfield t1 where t1.billid = 180 and t1.fieldname = 'newLeaveType') as fieldid,isview,isedit,ismandatory,orderid from workflow_nodeform where nodeid in (select t2.id from workflow_flownode t1 left join workflow_nodebase t2 on t2.id = t1.nodeid where t1.workflowid in (select id from workflow_base where formid = 180) and (t2.IsFreeNode is null or t2.IsFreeNode!='1')) and fieldid = 653 order by nodeid
GO