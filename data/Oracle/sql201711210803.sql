alter table FullSearch_FixedInst add isCast int
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('�½�����','','12','�½�����','/fullsearch/img/meeting_wev8.png',0)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'�½�����',1)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'��������һ��������',2)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'�������������ȥ���ǹ�˾����',3)
/


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('΢��','','13','д΢��','/fullsearch/img/blog_wev8.png',0)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'д΢��',1)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'���������΢��',2)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'���뿴�Ծ���΢��',3)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'���һ�²��Ž����΢����д���',4)
/

insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('���','','14','��Ҫ���','/fullsearch/img/leave_wev8.png',0)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'��Ҫ���',1)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'����һ���2���������',2)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'�����岻���Ҫ�������',3)
/

insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('����','','15','��Ҫ����','/fullsearch/img/travel_wev8.png',0)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'��Ҫ����',1)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'�����ύһ����������',2)
/


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('����','','16','��Ҫ����','/fullsearch/img/reimburse_wev8.png',0)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'��Ҫ����',1)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'���ұ�������Ľ�ͨ��30��',2)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'���ұ�һ���ϸ��µ�200��Ǯ����',3)
/


insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample,defaultImgSrc,isCast) values ('Ӧ��','','17','���ճ�','/fullsearch/img/v_app_wev8.png',0)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'���ճ�',1)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'ֱ��˵��Ӧ������',2)
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) values ((select MAX(id) from FullSearch_FixedInst),'������ǩ��',3)
/