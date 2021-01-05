UPDATE hrm_transfer_set SET link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authNodeGroup&gdtype=58' ,class_name = 'weaver.hrm.authority.manager.WorkflowNodeGroupManager'
WHERE code_name = 'T511' 
/
UPDATE hrm_transfer_set SET link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authCreateWorkflow&gdtype=58' ,class_name = 'weaver.hrm.authority.manager.WorkflowNodeGroupManager'
WHERE code_name = 'C521'
/
UPDATE hrm_transfer_set SET link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authNodeGroup&gdtype=58' ,class_name = 'weaver.hrm.authority.manager.WorkflowNodeGroupManager'
WHERE code_name = 'D521'
/