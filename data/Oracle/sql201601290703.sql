create table HrmJobTitlesSysBak as select * from HrmJobTitles 
/                           
ALTER TABLE HrmGroupshare 
ADD jobtitleid int
/
ALTER TABLE HrmGroupshare 
ADD jobtitlelevel INT
/
ALTER TABLE HrmGroupshare 
ADD scopeid VARCHAR(4000)
/
update MainMenuInfo SET linkAddress ='/hrm/jobtitles/index.jsp' WHERE id=62
/
UPDATE hrm_transfer_set SET link_address=null,class_name=NULL WHERE class_name ='weaver.hrm.authority.manager.HrmPostManager' AND code_name IN('T202','C201','C302')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'������Դ','T501','','' )
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̽ڵ������','T511','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','T521','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','T522','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ��ƶ�Ȩ��','T523','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�Ĭ�Ϲ���','T524','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���ĵ�Ŀ¼','T525','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','T531','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','T532','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���Ż�ҳ��','T541','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ͻ�','C501','','' )
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴��Ŀ','C511','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̴���Ȩ��','C521','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','C531','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','C532','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ��ƶ�Ȩ��','C533','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�Ĭ�Ϲ���','C534','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���ĵ�Ŀ¼','C535','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ĵ�','C536','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','C541','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','C542','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���Ż�ҳ��','C551','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ͻ�','D501','','' )
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴��Ŀ','D511','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̽ڵ������','D521','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'���̴���Ȩ��','D522','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','D531','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�����Ȩ��','D532','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ��ƶ�Ȩ��','D533','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ĵ�Ĭ�Ϲ���','D534','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���ĵ�Ŀ¼','D535','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'�ɲ鿴�ĵ�','D536','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','D541','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'Э������Ȩ��','D542','','')
/
INSERT INTO hrm_transfer_set( type ,name ,code_name ,link_address ,class_name)VALUES(0,'��ά���Ż�ҳ��','D551','','')
/
update hrm_transfer_set SET link_address= '/hrm/HrmDialogTab.jsp?_fromURL=authJobtitleResource'  WHERE code_name ='T501'
/
UPDATE SystemLogItem SET lableid=6086,itemdesc='��λ' WHERE itemid =26
/