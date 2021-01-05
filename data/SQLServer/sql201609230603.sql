CREATE TABLE FullSearch_CustomerSerDetail(
	id int IDENTITY(1,1) NOT NULL primary key,
	serviceID int NOT NULL,
	label varchar(1000) NULL,
	subcompanyid int NULL,
	departmentid int NULL,
	jobId int NULL,
	lastmoddate char(10) NULL,
	lastmodTime char(8) NULL
)
GO
CREATE TABLE FullSearch_FixedInst(
	id int IDENTITY(1,1) NOT NULL primary key,
	instructionName varchar(800) NOT NULL,
	instructionImgSrc varchar(800) NULL,
	showorder varchar(800) NULL,
	showExample varchar(800) NULL
	)
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('�绰','','1','��绰���Ծ�')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('����','','2','�����Ÿ��Ծ�')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('�ڲ���Ϣ','','3','����Ϣ���Ծ�')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('��������','','4','�����������')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('���ճ̱���','','5','���������翪��')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('����','','6','��Ҫǩ��')
GO
CREATE TABLE FullSearch_FixedInstShow(
	instructionId int NOT NULL,
	showValue varchar(800) NULL
) 
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��绰���Ծ�' from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ���绰' from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���ҽ�ͨ�Ծ��ĵ绰' from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ծ��ĵ绰' from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ծ�' from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ��ĵ绰' from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ծ�' from FullSearch_FixedInst where instructionName = '�绰'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ÿ��Ծ�' from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ�������' from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ÿ��Ծ���˵�����Ͼ͵�' from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ÿ��Ծ�������������7���' from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����֪ͨ������/��֪���Ծ�����Ҫ������' from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ϣ���Ծ�' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ�����Ϣ' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ϣ���Ծ���˵���Ժ�͵�' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ϣ���Ծ���������һ��Сʱ�����̸' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���ڲ���Ϣ֪ͨ������/��֪���Ծ�������2�㿪��' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����������' from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫ����������' from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'������������' from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�߸���������' from FullSearch_FixedInst where instructionName = '��������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���������翪��' from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫ���ճ�' from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫд����' from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ����ճ̣���������μӲ��Ż���' from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ծ������л�Ҫ�μ�' from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫǩ��' from FullSearch_FixedInst where instructionName = '���ճ̱���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫǩ��' from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫ����' from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����ǩ��' from FullSearch_FixedInst where instructionName = '����'
GO