update FullSearch_FixedInstShow set showValue = '���ڲ���Ϣ֪ͨ�Ծ�������������2�㿪��' where instructionId = 3 and showValue = '���ڲ���Ϣ֪ͨ������/��֪���Ծ�������2�㿪��' 
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���ڲ���Ϣ����(��֪)�Ծ���˵����2�㿪��',6 from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO