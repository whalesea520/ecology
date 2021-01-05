ALTER TABLE HrmGroupshare 
ADD seclevelto INT
GO
update hrm_transfer_set SET class_name= 'weaver.hrm.authority.manager.HrmResourceManager'  WHERE code_name ='T501'
GO