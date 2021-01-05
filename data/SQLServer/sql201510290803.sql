alter table HrmResource add notallot int
GO
alter table HrmResource add beforefrozen int
GO
alter table HrmResource add resourcefrom varchar(100)
GO
alter table HrmResource add isnewuser varchar(100)
GO
create table rdeployhrmsetting(
	setname varchar(100),
	setvalue varchar(1000)
)
GO
insert into rdeployhrmsetting(setname,setvalue) values('subcom','')
GO
insert into rdeployhrmsetting(setname,setvalue) values('onoff','1')
GO
insert into rdeployhrmsetting(setname,setvalue) values('hostadd','192.168.7.200:8080')
GO
create table rdeployhrmsendmsg(
	resourceid int,
	sendtime varchar(50)
)
GO

create table user_model_config(
    userid int,
    modelid int,
    orderindex int
)
go
CREATE TABLE system_model_base (
	id INT PRIMARY KEY,
	modelname VARCHAR(1000),
	modelDESC VARCHAR(1000),
 	modeldetaildesc VARCHAR(4000),
	modelicosrc varchar(1000),
	mgrpage VARCHAR(1000)
)
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (1, '����', '˽������&�Ŷ����񣬱�ݵ��������Ӧ��', '1�����ٴ�������,�����ĵ����ϣ�����������뷨������ͬ�½��������� 
2�������չ���һĿ��Ȼ���ṩ������ͼ�鿴��������
3���Ŷ�����ɷּ��������༶��������Ҳ�ܰ��ŵþ�������', '/rdeploy/assets/img/cproj/btask.png')
go


INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc, mgrpage)
VALUES (2, '����', '��Ч������˾�ڲ���������İ���', '1��������ת���ڼ�����������ȷ�������ܹ����ٸ�Ч����ת��ÿ������İ��������������ͼ��ֱ�۲鿴
2��ǿ��ı�����ƹ������������ʽ����ʵ��������ֽ���칫
3���ϸ��Ȩ���ж�ȷ����Ϣ�İ�ȫ
4���ḻ����Ϣ���ѻ������û���ʱ����������̽�չ���
5��֧�ֶ��ֽӿڣ�ȷ��������ģ����������ݵ���������', '/rdeploy/assets/img/cproj/bworkflow.png'
, '/rdeploy/wf/index.jsp')
go

INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc, mgrpage)
VALUES (3, '����', '�����ݵ��ļ��洢������ƽ̨', '1������Ŀ¼ȷ�������û����Թ������Ե���Դ��������Ϣ�������γ��Ŷ�֪ʶ��
2��˽��Ŀ¼�ṩ�˱�������ļ��Ŀռ䣬��Ҳ����������U��
3���Ͻ���Ȩ�޿��ƣ�ȷ����Ҫ�ļ�������', '/rdeploy/assets/img/cproj/bdoc.png'
, '/rdeploy/doc/index.jsp')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (4, '�ش�', '����شȷ����Ҫ�����������Աȷʵ�յ�', '1����ȷ����������ȷʵ���յ������Ϣ���Ѷ�δ�������������
2���ṩӦ�������ѡ����ŷ�ʽ�ȶ������ѷ�ʽ���ѽ����˽��в���
3����ÿ���������ݾ��ɵ������۽���', '/rdeploy/assets/img/cproj/bbing.png')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (5, '�ͻ�', '�ÿͻ���Դ�Ĺ�����ά����ü�', '1��ͳһ������������Ŀͻ���Դ�������Ŀͻ��������Ҳ�ܷ���鿴
2���ͻ���ϵ����Ϣʵʱ���£��ؼ���ϵ��һ������
3����Ҫ�ͻ���ϵ�����ա���ϵ�ƻ�����ϵͳ�Զ������������ĵĿͻ��ػ���ʵ��', '/rdeploy/assets/img/cproj/bcstom.png')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (6, '�ճ�', '��������С�������������������������г̼ƻ�', '1���������ѡ��ʼ����ѵȸ������ѷ�ʽ���������������κ���Ҫ����
2��ͨ���ճ̹����������û������˽����Ĺ������ţ����������������ʱ����ŵ���
3������ֱ�Ӹ��¼������ճ̲��ල������', '/rdeploy/assets/img/cproj/bschedule.png')
go
INSERT INTO system_model_base(id, modelname, modeldesc, modeldetaildesc, modelicosrc)
VALUES (7, '��־', '��¼����ÿ��Ĺ������ݼ��ĵ����', '1��ÿ���û������Լ�¼���ԵĹ�����־
2��ͨ��������ע���Բ鿴�����˵Ĺ�����־�������ϼ��˽��¼��Ĺ���״̬
3��ͨ�����ۿ��Զ������˵Ĺ��������Լ������', '/rdeploy/assets/img/cproj/blog.png')
go

CREATE TABLE Workflow_RecordMesConfig
(
	userid            INT
)
GO
CREATE TABLE Workflow_RecordNavigation
(
	userid            INT
)
GO

INSERT INTO Workflow_Initialization(wfid, orderid) 
SELECT id,0 FROM workflow_base WHERE (isvalid = 0 OR isvalid=1) AND id != 1
GO

CREATE TABLE CHECKIN_USER_SECCATEGORY (
userid int NOT NULL ,
seccategory int NOT NULL 
)
GO

ALTER TABLE DocDetail ADD docVestIn int NOT NULL DEFAULT 0 
GO
ALTER TABLE DocSecCategory ADD seccategoryType int NOT NULL DEFAULT 0 
GO