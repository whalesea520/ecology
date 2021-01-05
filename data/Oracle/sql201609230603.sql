CREATE TABLE FullSearch_CustomerSerDetail(
  id integer NOT NULL primary key,
  serviceID integer NOT NULL,
  label varchar(1000) NULL,
  subcompanyid integer NULL,
  departmentid integer NULL,
  jobId integer NULL,
  lastmoddate char(10) NULL,
  lastmodTime char(8) NULL
)
/
create sequence seq_fullSearch_CusSerDetail
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CustomerSerDetail_tri
before insert on FullSearch_CustomerSerDetail
for each row
begin
select seq_fullSearch_CusSerDetail.nextval into :new.id from dual;
end ;
/
CREATE TABLE FullSearch_FixedInst(
  id integer NOT NULL primary key,
  instructionName varchar(800) NOT NULL,
  instructionImgSrc varchar(800) NULL,
  showorder varchar(800) NULL,
  showExample varchar(800) NULL
  )
  
/
create sequence seq_fullSearch_FixedInst
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger FixedInst_tri
before insert on FullSearch_FixedInst
for each row
begin
select seq_fullSearch_FixedInst.nextval into :new.id from dual;
end ;
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('�绰','','1','��绰���Ծ�')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('����','','2','�����Ÿ��Ծ�')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('�ڲ���Ϣ','','3','����Ϣ���Ծ�')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('��������','','4','�����������')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('���ճ̱���','','5','���������翪��')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('����','','6','��Ҫǩ��')
/
CREATE TABLE FullSearch_FixedInstShow(
  instructionId integer NOT NULL,
  showValue varchar(800) NULL
) 
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��绰���Ծ�' from FullSearch_FixedInst where instructionName = '�绰'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ���绰' from FullSearch_FixedInst where instructionName = '�绰'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���ҽ�ͨ�Ծ��ĵ绰' from FullSearch_FixedInst where instructionName = '�绰'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ծ��ĵ绰' from FullSearch_FixedInst where instructionName = '�绰'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ծ�' from FullSearch_FixedInst where instructionName = '�绰'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ��ĵ绰' from FullSearch_FixedInst where instructionName = '�绰'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ծ�' from FullSearch_FixedInst where instructionName = '�绰'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ÿ��Ծ�' from FullSearch_FixedInst where instructionName = '����'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ�������' from FullSearch_FixedInst where instructionName = '����'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ÿ��Ծ���˵�����Ͼ͵�' from FullSearch_FixedInst where instructionName = '����'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ÿ��Ծ�������������7���' from FullSearch_FixedInst where instructionName = '����'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����֪ͨ������/��֪���Ծ�����Ҫ������' from FullSearch_FixedInst where instructionName = '����'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ϣ���Ծ�' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ�����Ϣ' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ϣ���Ծ���˵���Ժ�͵�' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����Ϣ���Ծ���������һ��Сʱ�����̸' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���ڲ���Ϣ֪ͨ������/��֪���Ծ�������2�㿪��' from FullSearch_FixedInst where instructionName = '�ڲ���Ϣ'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����������' from FullSearch_FixedInst where instructionName = '��������'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫ����������' from FullSearch_FixedInst where instructionName = '��������'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'������������' from FullSearch_FixedInst where instructionName = '��������'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�߸���������' from FullSearch_FixedInst where instructionName = '��������'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���������翪��' from FullSearch_FixedInst where instructionName = '���ճ̱���'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫ���ճ�' from FullSearch_FixedInst where instructionName = '���ճ̱���'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫд����' from FullSearch_FixedInst where instructionName = '���ճ̱���'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'���Ծ����ճ̣���������μӲ��Ż���' from FullSearch_FixedInst where instructionName = '���ճ̱���'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'�����Ծ������л�Ҫ�μ�' from FullSearch_FixedInst where instructionName = '���ճ̱���'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫǩ��' from FullSearch_FixedInst where instructionName = '���ճ̱���'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫǩ��' from FullSearch_FixedInst where instructionName = '����'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'��Ҫ����' from FullSearch_FixedInst where instructionName = '����'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'����ǩ��' from FullSearch_FixedInst where instructionName = '����'
/