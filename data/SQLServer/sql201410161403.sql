create table CRM_MapReport (
   id                   int                  identity,
   name                 varchar(100)         null,
   unit                 varchar(50)          null,
   datasource           varchar(50)          null,
   sqlstr1              text                 null,
   sqlstr2              text                 null,
   createrId            int                  null,
   createDate           char(10)             null,
   createTime           char(8)              null,
   updaterId            int                  null,
   updateDate           char(10)             null,
   updateTime           char(8)              null,
   deleted              tinyint              null,
   detailurl            text                 null,
   parmtype             tinyint              null,
   provparm             varchar(50)          null,
   cityparm             varchar(50)          null,
   datefromparm         varchar(50)          null,
   datetoparm           varchar(50)          null,
   constraint PK_CRM_MapReport primary key (id)
)
go

INSERT INTO CRM_MapReport(name,unit,datasource,sqlstr1,sqlstr2,createrId,createDate,createTime,updaterId,updateDate,
updateTime,deleted,detailurl,parmtype,provparm,cityparm,datefromparm,datetoparm) VALUES ('�ͻ��ֲ�ͳ��', '�ͻ�����(��)', '', 'select t2.provincename as province,count(t1.id) as amount from (#crmsql#) t1,HrmProvince t2,HrmCity t3
where t1.city=t3.id and t3.provinceid=t2.id  and (t1.deleted=0 or t1.deleted is null)  and t2.countryid=1
and t1.createdate>=''#datefrom#'' and t1.createdate<=''#dateto#'' and t1.createdate<>'''' and t1.createdate is not null
group by t2.provincename order by amount desc,t2.provincename', 'select t3.cityname as city,t2.provincename as province,count(t1.id) as amount from (#crmsql#) t1,HrmProvince t2,HrmCity t3
where t1.city=t3.id and t3.provinceid=t2.id and (t1.deleted=0 or t1.deleted is null) and t2.countryid=1
and t1.createdate>=''#datefrom#'' and t1.createdate<=''#dateto#'' and t1.createdate<>'''' and t1.createdate is not null
group by t3.id,t3.cityname,t2.provincename order by amount desc,t2.provincename,t3.cityname', 897, '2012-08-20', '18:50:37', 897, '2012-09-04', '16:15:38', 0, '/CRM/search/SearchTabFrame.jsp', 1, 'provinceIds', 'cityIds', 'createdatefrom', 'createdateto');
GO