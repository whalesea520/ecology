create table cpt_cptcardtab(
id int  not null,
groupname varchar2(60) null,
grouplabel int null,
dsporder decimal(10,2) null,
isopen char(1) null,
ismand char(1) null,
isused char(1) null,
issystem char(1) null,
linkurl varchar2(2000)
)
/
create sequence cpt_cptcardtab_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger cpt_cptcardtab_TRIGGER before insert on cpt_cptcardtab for each row 
begin select cpt_cptcardtab_ID.nextval into :new.id from dual; end;
/
create table prj_prjcardtab(
id int  not null,
groupname varchar2(60) null,
grouplabel int null,
dsporder decimal(10,2) null,
isopen char(1) null,
ismand char(1) null,
isused char(1) null,
issystem char(1) null,
linkurl varchar2(2000)
)
/
create sequence prj_prjcardtab_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_prjcardtab_TRIGGER before insert on prj_prjcardtab for each row 
begin select prj_prjcardtab_ID.nextval into :new.id from dual; end;
/
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(1,'�ʲ���Ϣ',15806,1,'1','1','1','1','/cpt/capital/CptCapital.jsp')
/
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(2,'��������',2112,1,'1','1','1','1','/cpt/capital/CptCapitalShareDsp.jsp')
/
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(3,'��ת��־',34253,1,'1','1','1','1','/cpt/capital/CptCapitalFlowView.jsp')
/
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(4,'�����¼',19765,1,'1','1','1','1','/cpt/capital/CptCapitalModifyView.jsp')
/
insert into cpt_cptcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(5,'ͳ�Ʊ���',15296,1,'1','1','1','1','/cpt/capital/CptCapitalStatistics.jsp')
/
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(1,'��Ŀ��Ϣ',16290,1,'1','1','1','1','/proj/data/ViewProject.jsp')
/
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(2,'�����б�',18505,1,'1','1','1','1','/proj/process/ViewProcess.jsp')
/
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(3,'����Ŀ',846,1,'1','1','1','1','/proj/data/ViewProjectSub.jsp')
/
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(4,'��ؽ���',15153,1,'1','1','1','1','/proj/process/ViewPrjDiscuss.jsp')
/
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(5,'��������',2112,1,'1','1','1','1','/proj/data/PrjShareDsp.jsp')
/
insert into prj_prjcardtab(id,groupname,grouplabel,dsporder,isopen,isused,issystem,ismand,linkurl) values(6,'ͳ�Ʊ���',15296,1,'1','1','1','1','/proj/data/ViewProjectStastics.jsp')
/