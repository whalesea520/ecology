update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authHandledMatters',class_name='weaver.hrm.authority.manager.WorkflowHandledMattersManager' where code_name in ('T134', 'C133')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authPendingMatters',class_name='weaver.hrm.authority.manager.WorkflowPendingMattersManager' where code_name='T133'
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authMonitoring',class_name='weaver.hrm.authority.manager.WorkflowMonitoringManager' where code_name in ('T132', 'C132', 'D112')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authNodeGroup&gdtype=3',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('T131', 'D111')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authNodeGroup&gdtype=1',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('T211', 'D211')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authNodeGroup&gdtype=30',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('T311', 'D311')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authNodeGroup&gdtype=2',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('T401', 'D401')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authCreateWorkflow&gdtype=3',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('C131', 'D113')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authCreateWorkflow&gdtype=1',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('C231', 'D212')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authCreateWorkflow&gdtype=30',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('C331', 'D312')
/
update hrm_transfer_set set link_address='/hrm/HrmDialogTab.jsp?_fromURL=authCreateWorkflow&gdtype=2',class_name='weaver.hrm.authority.manager.WorkflowNodeGroupManager' where code_name in ('C421', 'D402')
/