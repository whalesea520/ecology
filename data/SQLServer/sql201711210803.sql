alter table FullSearch_FixedInst add isCast integer
GO
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('�½�����','','12','�½�����','/fullsearch/img/meeting_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'�½�����',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'��������һ��������',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'�������������ȥ���ǹ�˾����',3 from FullSearch_FixedInst
GO


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('΢��','','13','д΢��','/fullsearch/img/blog_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'д΢��',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'���������΢��',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'���뿴�Ծ���΢��',3 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'���һ�²��Ž����΢����д���',4 from FullSearch_FixedInst
GO

insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('���','','14','��Ҫ���','/fullsearch/img/leave_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'��Ҫ���',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'����һ���2���������',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'�����岻���Ҫ�������',3 from FullSearch_FixedInst
GO

insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('����','','15','��Ҫ����','/fullsearch/img/travel_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'��Ҫ����',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'�����ύһ����������',2 from FullSearch_FixedInst
GO


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('����','','16','��Ҫ����','/fullsearch/img/reimburse_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'��Ҫ����',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'���ұ�������Ľ�ͨ��30��',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'���ұ�һ���ϸ��µ�200��Ǯ����',3 from FullSearch_FixedInst
GO


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('Ӧ��','','17','���ճ�','/fullsearch/img/v_app_wev8.png',0)
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'���ճ�',1 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'ֱ��˵��Ӧ������',2 from FullSearch_FixedInst
GO
insert into FullSearch_FixedInstShow select MAX(id) ,'������ǩ��',3 from FullSearch_FixedInst
GO