create sequence hrm_transfer_set_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
create table hrm_transfer_set(
	id number NOT NULL primary key,
	type number NOT NULL,
	name varchar2(50),
	code_name varchar2(50),
	link_address varchar2(1000),
	class_name varchar2(1000)
)
/
CREATE OR REPLACE TRIGGER hrm_transfer_set_Trigger before insert on hrm_transfer_set for each row begin select hrm_transfer_set_id.nextval into :new.id from dual; end;
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'客户','T101','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'负责项目','T111','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'参与项目','T112','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'项目任务','T113','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'下属','T121','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'角色','T122','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协办人','T123','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'部门自定义字段','T124','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'分部自定义字段','T125','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T131','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可监控流程','T132','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'待办事宜','T133','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'已办事宜','T134','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T141','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T142','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T143','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T144','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'虚拟目录管理权限','T145','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T146','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T147','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档','T148','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'负责会议','T151','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'参与会议','T152','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'日程','T161','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'资产','T171','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作主题','T181','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T182','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T183','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T191','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'下级部门','T201','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'岗位','T202','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'人力资源','T203','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'群组','T204','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T211','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T221','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T222','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T223','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T224','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T225','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T226','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T231','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T232','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T241','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'下级分部','T301','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'部门','T302','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'群组','T303','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T311','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T321','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T322','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T323','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T324','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T325','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T326','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T331','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T332','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T341','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'流程节点操作者','T401','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档创建权限','T411','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档复制权限','T412','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档移动权限','T413','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'文档默认共享','T414','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档主目录','T415','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护文档分目录','T416','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作创建权限','T421','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'协作管理权限','T422','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'可维护门户页面','T431','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C101','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'参与项目','C111','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C112','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'角色','C121','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'部门自定义字段','C122','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'分部自定义字段','C123','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C131','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可监控流程','C132','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'已办事宜','C133','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C141','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C142','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C143','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C144','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'虚拟目录管理权限','C145','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C146','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C147','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C148','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'参与会议','C151','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'日程','C161','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'参与协作','C171','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作区创建权限','C172','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作区管理权限','C173','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C181','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'岗位','C201','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'群组','C202','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C211','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C221','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C231','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C241','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C242','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C243','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C244','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C245','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C246','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C247','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作创建权限','C251','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作管理权限','C252','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C261','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'部门','C301','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'岗位','C302','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'群组','C303','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C311','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C321','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C331','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C341','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C342','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C343','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C344','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C345','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C346','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C347','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作创建权限','C351','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作管理权限','C352','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C361','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看客户','C401','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看项目','C411','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'流程创建权限','C421','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档创建权限','C431','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档复制权限','C432','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档移动权限','C433','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'文档默认共享','C434','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档主目录','C435','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护文档分目录','C436','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可查看文档','C437','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作创建权限','C441','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'协作管理权限','C442','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'可维护门户页面','C451','','' )
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmRoleManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authRole' where code_name in ('T122','C121')
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmSubordinateManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authSubordinate' where code_name = 'T121'
/