truncate table FullSearch_FixedInstShow 
GO
alter table FullSearch_FixedInstShow add id int IDENTITY(1,1) NOT NULL
GO
alter table FullSearch_FixedInstShow add dsporder int NULL
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��绰���Ծ�',1 from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���Ծ���绰',2 from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���ҽ�ͨ�Ծ��ĵ绰',3 from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����Ծ��ĵ绰',4 from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����Ծ�',5 from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���Ծ��ĵ绰',6 from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'����Ծ�',7 from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����Ÿ��Ծ�',1 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���Ծ�������',2 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����Ÿ��Ծ���˵�����Ͼ͵�',3 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����Ÿ��Ծ�������������7���',4 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'����֪ͨ������/��֪���Ծ�����Ҫ������',5 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'����Ϣ���Ծ�',1 from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���Ծ�����Ϣ',2 from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'����Ϣ���Ծ���˵���Ժ�͵�',3 from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'����Ϣ���Ծ���������һ��Сʱ�����̸',4 from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���ڲ���Ϣ֪ͨ������/��֪���Ծ�������2�㿪��',5 from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����������',1 from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫ����������',2 from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'������������',3 from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�߸���������',4 from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���������翪��',1 from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫ���ճ�',2 from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫд����',3 from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���Ծ����ճ̣���������μӲ��Ż���',4 from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����Ծ������л�Ҫ�μ�',5 from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫǩ��',1 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫǩ��',2 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫ����',3 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'����ǩ��',4 from FullSearch_FixedInst where instructionName = '����'
GO