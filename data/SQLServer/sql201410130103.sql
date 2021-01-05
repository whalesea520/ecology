update hrm_transfer_set set name='文档所有者' where code_name = 'T148'
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'下属','D101','/hrm/HrmDialogTab.jsp?_fromURL=authSubordinate','weaver.hrm.authority.manager.HrmSubordinateManager' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'角色','D102','/hrm/HrmDialogTab.jsp?_fromURL=authRole','weaver.hrm.authority.manager.HrmRoleManager' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协办人','D103','/hrm/HrmDialogTab.jsp?_fromURL=authCoOrganiser','weaver.hrm.authority.manager.HrmCoOrganiserManager' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'部门自定义字段','D104','/hrm/HrmDialogTab.jsp?_fromURL=authDepartmentCusFields','weaver.hrm.authority.manager.HrmDepartmentCusFieldsManager' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'分部自定义字段','D105','/hrm/HrmDialogTab.jsp?_fromURL=authSubcompanyCusFields','weaver.hrm.authority.manager.HrmSubcompanyCusFieldsManager' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程节点操作者','D111','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可监控流程','D112','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程创建权限','D113','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档创建权限','D121','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档复制权限','D122','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档移动权限','D123','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档默认共享','D124','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'虚拟目录管理权限','D125','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档主目录','D126','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档分目录','D127','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看文档','D128','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'参与会议','D131','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'日程','D141','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作创建权限','D151','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作管理权限','D152','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'参与协作','D153','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护门户页面','D161','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看客户','D171','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看项目','D181','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'群组','D201','/hrm/HrmDialogTab.jsp?_fromURL=authGroup','weaver.hrm.authority.manager.HrmGroupManager' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程节点操作者','D211','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程创建权限','D212','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档创建权限','D221','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档复制权限','D222','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档移动权限','D223','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档默认共享','D224','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档主目录','D225','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档分目录','D226','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看文档','D227','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作创建权限','D231','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作管理权限','D232','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护门户页面','D241','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看客户','D251','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看项目','D261','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'群组','D301','/hrm/HrmDialogTab.jsp?_fromURL=authGroup','weaver.hrm.authority.manager.HrmGroupManager' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程节点操作者','D311','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程创建权限','D312','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档创建权限','D321','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档复制权限','D322','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档移动权限','D323','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档默认共享','D324','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档主目录','D325','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档分目录','D326','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看文档','D327','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作创建权限','D331','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作管理权限','D332','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护门户页面','D341','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看客户','D351','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看项目','D361','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程节点操作者','D401','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'流程创建权限','D402','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档创建权限','D411','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档复制权限','D412','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档移动权限','D413','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'文档默认共享','D414','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档主目录','D415','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护文档分目录','D416','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看文档','D417','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作创建权限','D421','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'协作管理权限','D422','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可维护门户页面','D431','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看客户','D441','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(2,'可查看项目','D451','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可查看文档','T149','','' )
GO