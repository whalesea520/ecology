delete from hrm_transfer_set where code_name in ('Temail001','Temail002') and type=0 
/
insert into hrm_transfer_set(type,name,code_name,link_address,class_name) values (0,'�ڲ��ʼ����ռ��䣩','Temail001','/email/transfer/EmailTab.jsp?_fromURL=Temail001&folderid=0','weaver.hrm.authority.manager.EmailManager')
/
insert into hrm_transfer_set(type,name,code_name,link_address,class_name) values (0,'�ڲ��ʼ����ѷ��ͣ�','Temail002','/email/transfer/EmailTab.jsp?_fromURL=Temail002&folderid=-1','weaver.hrm.authority.manager.EmailManager')
/