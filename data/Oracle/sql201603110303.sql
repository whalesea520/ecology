update workflow_currentoperator
set islasttimes = 1
where isremark = '0'
and agenttype = 2
and islasttimes = 0
and exists (select 1 from workflow_currentoperator t1
            where t1.requestid = workflow_currentoperator.requestid
            and t1.userid = workflow_currentoperator.userid
            and t1.usertype = workflow_currentoperator.usertype
            and t1.nodeid = t1.nodeid
            and t1.isremark = '2'
            and t1.agenttype = 1)
/
update workflow_currentoperator
set islasttimes = 0
where isremark = '2'
and agenttype = 1
and islasttimes = 1
and exists (select 1 from workflow_currentoperator t1
            where t1.requestid = workflow_currentoperator.requestid
            and t1.userid = workflow_currentoperator.userid
            and t1.usertype = workflow_currentoperator.usertype
            and t1.nodeid = t1.nodeid
            and t1.isremark = '0'
            and t1.agenttype = 2)
/