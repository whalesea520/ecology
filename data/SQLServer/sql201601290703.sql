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
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'������Դ','T501','','' )
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̽ڵ������','T511','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','T521','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','T522','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ��ƶ�Ȩ��','T523','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�Ĭ�Ϲ���','T524','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���ĵ�Ŀ¼','T525','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','T531','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','T532','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���Ż�ҳ��','T541','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ͻ�','C501','','' )
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴��Ŀ','C511','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̴���Ȩ��','C521','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','C531','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','C532','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ��ƶ�Ȩ��','C533','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�Ĭ�Ϲ���','C534','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���ĵ�Ŀ¼','C535','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ĵ�','C536','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','C541','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','C542','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���Ż�ҳ��','C551','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ͻ�','D501','','' )
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴��Ŀ','D511','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̽ڵ������','D521','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̴���Ȩ��','D522','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','D531','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','D532','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ��ƶ�Ȩ��','D533','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�Ĭ�Ϲ���','D534','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���ĵ�Ŀ¼','D535','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ĵ�','D536','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','D541','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','D542','','')
GO
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���Ż�ҳ��','D551','','')
GO
update hrm_transfer_set SET link_address= '/hrm/HrmDialogTab.jsp?_fromURL=authJobtitleResource'  WHERE code_name ='T501'
GO
UPDATE SystemLogItem SET lableid=6086,itemdesc='��λ' WHERE itemid =26
GO