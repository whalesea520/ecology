UPDATE HrmListValidate SET name = '������Ϣ' WHERE id = 3
GO
UPDATE HrmListValidate SET name = '�Զ�������Ϣ' WHERE name='�Զ�������Ϣ'
GO
UPDATE HrmListValidate SET name = '���ʵ�����ϸ' WHERE name='������ϸ����'
GO
UPDATE HrmListValidate SET name = 'Ȩ����ϸ' WHERE name='ͳ��'
GO
INSERT INTO HrmListValidate( id ,name ,validate_n ,parentid ,TAB_url ,tab_type , tab_index)
VALUES  (36,'��Ƭ',1,3,NULL,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,
          type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 0,'jobactivity',1915,'int',3,24,7,1,1,1,1)
GO