delete from workflow_groupdetail where groupid not in (select id from workflow_nodegroup)
/

