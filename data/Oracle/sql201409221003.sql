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
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ͻ�','T101','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'������Ŀ','T111','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'������Ŀ','T112','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��Ŀ����','T113','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'����','T121','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ɫ','T122','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э����','T123','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�����Զ����ֶ�','T124','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ֲ��Զ����ֶ�','T125','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'���̽ڵ������','T131','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ɼ������','T132','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��������','T133','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�Ѱ�����','T134','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T141','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T142','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ��ƶ�Ȩ��','T143','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�Ĭ�Ϲ���','T144','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'����Ŀ¼����Ȩ��','T145','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T146','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T147','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�','T148','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�������','T151','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�������','T152','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ճ�','T161','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ʲ�','T171','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������','T181','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T182','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T183','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���Ż�ҳ��','T191','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�¼�����','T201','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��λ','T202','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'������Դ','T203','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Ⱥ��','T204','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'���̽ڵ������','T211','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T221','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T222','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ��ƶ�Ȩ��','T223','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�Ĭ�Ϲ���','T224','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T225','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T226','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T231','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T232','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���Ż�ҳ��','T241','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�¼��ֲ�','T301','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'����','T302','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Ⱥ��','T303','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'���̽ڵ������','T311','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T321','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T322','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ��ƶ�Ȩ��','T323','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�Ĭ�Ϲ���','T324','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T325','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T326','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T331','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T332','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���Ż�ҳ��','T341','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'���̽ڵ������','T401','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T411','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�����Ȩ��','T412','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ��ƶ�Ȩ��','T413','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'�ĵ�Ĭ�Ϲ���','T414','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T415','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���ĵ���Ŀ¼','T416','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T421','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'Э������Ȩ��','T422','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(0,'��ά���Ż�ҳ��','T431','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ͻ�','C101','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'������Ŀ','C111','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴��Ŀ','C112','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ɫ','C121','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�����Զ����ֶ�','C122','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ֲ��Զ����ֶ�','C123','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'���̴���Ȩ��','C131','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɼ������','C132','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�Ѱ�����','C133','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C141','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C142','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ��ƶ�Ȩ��','C143','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�Ĭ�Ϲ���','C144','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'����Ŀ¼����Ȩ��','C145','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C146','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C147','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ĵ�','C148','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�������','C151','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ճ�','C161','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'����Э��','C171','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э��������Ȩ��','C172','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э��������Ȩ��','C173','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���Ż�ҳ��','C181','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��λ','C201','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Ⱥ��','C202','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ͻ�','C211','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴��Ŀ','C221','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'���̴���Ȩ��','C231','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C241','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C242','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ��ƶ�Ȩ��','C243','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�Ĭ�Ϲ���','C244','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C245','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C246','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ĵ�','C247','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э������Ȩ��','C251','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э������Ȩ��','C252','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���Ż�ҳ��','C261','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'����','C301','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��λ','C302','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Ⱥ��','C303','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ͻ�','C311','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴��Ŀ','C321','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'���̴���Ȩ��','C331','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C341','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C342','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ��ƶ�Ȩ��','C343','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�Ĭ�Ϲ���','C344','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C345','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C346','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ĵ�','C347','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э������Ȩ��','C351','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э������Ȩ��','C352','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���Ż�ҳ��','C361','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ͻ�','C401','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴��Ŀ','C411','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'���̴���Ȩ��','C421','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C431','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�����Ȩ��','C432','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ��ƶ�Ȩ��','C433','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ĵ�Ĭ�Ϲ���','C434','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C435','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���ĵ���Ŀ¼','C436','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'�ɲ鿴�ĵ�','C437','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э������Ȩ��','C441','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'Э������Ȩ��','C442','','' )
/
insert into hrm_transfer_set (type,name,code_name,link_address,class_name ) values(1,'��ά���Ż�ҳ��','C451','','' )
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmRoleManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authRole' where code_name in ('T122','C121')
/
update hrm_transfer_set set class_name = 'weaver.hrm.authority.manager.HrmSubordinateManager',link_address = '/hrm/HrmDialogTab.jsp?_fromURL=authSubordinate' where code_name = 'T121'
/