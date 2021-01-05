SELECT * INTO HrmJobTitlesSysBak FROM HrmJobTitles
GO                                                
ALTER TABLE HrmGroupshare 
ADD jobtitleid int
GO
ALTER TABLE HrmGroupshare 
ADD jobtitlelevel INT
GO
ALTER TABLE HrmGroupshare 
ADD scopeid VARCHAR(4000)
GO
update MainMenuInfo SET linkAddress ='/hrm/jobtitles/index.jsp' WHERE id=62
GO
UPDATE hrm_transfer_set SET link_address=null,class_name=NULL WHERE class_name ='weaver.hrm.authority.manager.HrmPostManager' AND code_name IN('T202','C201','C302')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'人力资源','T501','','' )
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'流程节点操作者','T511','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档创建权限','T521','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档复制权限','T522','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档移动权限','T523','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档默认共享','T524','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可维护文档目录','T525','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'协作创建权限','T531','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'协作管理权限','T532','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可维护门户页面','T541','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可查看客户','C501','','' )
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可查看项目','C511','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'流程创建权限','C521','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档创建权限','C531','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档复制权限','C532','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档移动权限','C533','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档默认共享','C534','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可维护文档目录','C535','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可查看文档','C536','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'协作创建权限','C541','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'协作管理权限','C542','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可维护门户页面','C551','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可查看客户','D501','','' )
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可查看项目','D511','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'流程节点操作者','D521','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'流程创建权限','D522','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档创建权限','D531','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档复制权限','D532','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档移动权限','D533','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'文档默认共享','D534','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可维护文档目录','D535','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可查看文档','D536','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'协作创建权限','D541','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'协作管理权限','D542','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'可维护门户页面','D551','','')
GO
update hrm_transfer_set SET link_address= '/hrm/HrmDialogTab.jsp?_fromURL=authJobtitleResource'  WHERE code_name ='T501'
GO
UPDATE SystemLogItem SET lableid=6086,itemdesc='岗位' WHERE itemid =26
GO