create table hrm_transfer_set(
	id int identity(1,1) NOT NULL primary key,
	type int NOT NULL default 0,
	name varchar(50),
	code_name varchar(50),
	link_address varchar(1000),
	class_name varchar(1000)
)
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'客户','T101','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'负责项目','T111','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'参与项目','T112','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'项目任务','T113','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'下属','T121','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'角色','T122','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协办人','T123','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'部门自定义字段','T124','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'分部自定义字段','T125','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T131','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可监控流程','T132','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'待办事宜','T133','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'已办事宜','T134','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T141','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T142','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T143','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T144','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'虚拟目录管理权限','T145','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T146','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T147','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档','T148','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'负责会议','T151','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'参与会议','T152','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'日程','T161','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'资产','T171','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作主题','T181','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T182','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T183','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T191','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'下级部门','T201','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'岗位','T202','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'人力资源','T203','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'群组','T204','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T211','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T221','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T222','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T223','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T224','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T225','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T226','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T231','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T232','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T241','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'下级分部','T301','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'部门','T302','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'群组','T303','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T311','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T321','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T322','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T323','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T324','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T325','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T326','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T331','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T332','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T341','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T401','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T411','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T412','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T413','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T414','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T415','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T416','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T421','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T422','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T431','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C101','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'参与项目','C111','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C112','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'角色','C121','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'部门自定义字段','C122','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'分部自定义字段','C123','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C131','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可监控流程','C132','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'已办事宜','C133','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C141','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C142','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C143','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C144','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'虚拟目录管理权限','C145','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C146','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C147','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C148','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'参与会议','C151','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'日程','C161','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'参与协作','C171','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作区创建权限','C172','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作区管理权限','C173','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C181','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'岗位','C201','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'群组','C202','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C211','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C221','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C231','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C241','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C242','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C243','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C244','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C245','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C246','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C247','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作创建权限','C251','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作管理权限','C252','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C261','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'部门','C301','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'岗位','C302','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'群组','C303','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C311','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C321','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C331','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C341','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C342','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C343','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C344','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C345','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C346','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C347','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作创建权限','C351','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作管理权限','C352','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C361','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C401','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C411','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C421','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C431','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C432','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C433','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C434','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C435','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C436','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C437','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作创建权限','C441','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作管理权限','C442','','' )
GO
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C451','','' )
GO
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmRoleManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authRole' where code_name in ('T122','C121')
GO
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmSubordinateManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authSubordinate' where code_name = 'T121'
GO