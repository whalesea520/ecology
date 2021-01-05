update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmCoOrganiserManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authCoOrganiser' where code_name = 'T123'
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmDepartmentCusFieldsManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authDepartmentCusFields' where code_name in ('T124')
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmSubcompanyCusFieldsManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authSubcompanyCusFields' where code_name in ('T125')
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmPostManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authPost' where code_name in ('T202','C201','C302')
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmGroupManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authGroup' where code_name in ('T204','T303','C202','C303')
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmSubDepartmentManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authSubDepartment' where code_name = 'T201'
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmResourceManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authResource' where code_name = 'T203'
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmSubCompanyManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authSubCompany' where code_name = 'T301'
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmDepartmentManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authDepartment' where code_name in ('T302','C301')
/