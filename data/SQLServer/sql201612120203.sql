insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('���ڱ���','',7,'�����ұ��µĿ������','/fullsearch/img/checkInReport_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('�������','',8,'�һ��м������','/fullsearch/img/holiday_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('����','',9,'��ôȥ��������','/fullsearch/img/navigation_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('���������','',10,'���ж��ٴ�������','/fullsearch/img/agencyFlow_wev8.png')
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc) values ('����Ա���¼�','',11,'�Ծ����ϼ���˭','/fullsearch/img/upperLower_wev8.png')
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�����ұ��µĿ������',0 from FullSearch_FixedInst where instructionName = '���ڱ���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��һ���ұ��ܵĿ�������',1 from FullSearch_FixedInst where instructionName = '���ڱ���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫ�����ڱ���',2 from FullSearch_FixedInst where instructionName = '���ڱ���'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'������Ŀ��ڼ�¼',3 from FullSearch_FixedInst where instructionName = '���ڱ���'
GO

insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�һ��м������',0 from FullSearch_FixedInst where instructionName = '�������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�һ������뼸���',1 from FullSearch_FixedInst where instructionName = '�������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�һ����������',2 from FullSearch_FixedInst where instructionName = '�������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��ʣ����ٿ�����',3 from FullSearch_FixedInst where instructionName = '�������'
GO

insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��ôȥ��������',0 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫȥ����������ô��',1 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��������������',2 from FullSearch_FixedInst where instructionName = '����'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'��Ҫ����������',3 from FullSearch_FixedInst where instructionName = '����'
GO


insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'���ж��ٴ�������',0 from FullSearch_FixedInst where instructionName = '���������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�һ��ж�������û��',1 from FullSearch_FixedInst where instructionName = '���������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�г��ҵĴ�������',2 from FullSearch_FixedInst where instructionName = '���������'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�ҵĴ���',3 from FullSearch_FixedInst where instructionName = '���������'
GO


insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�Ծ����ϼ���˭',0 from FullSearch_FixedInst where instructionName = '����Ա���¼�'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'˭���Ծ����쵼',1 from FullSearch_FixedInst where instructionName = '����Ա���¼�'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�Ծ�����Щ����',2 from FullSearch_FixedInst where instructionName = '����Ա���¼�'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�Ծ����¼�����˭',3 from FullSearch_FixedInst where instructionName = '����Ա���¼�'
GO
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'�ҵ�����',4 from FullSearch_FixedInst where instructionName = '����Ա���¼�'
GO