create table CRM_MapReport (
   id                   int                  not null,
   name                 varchar(100)         null,
   unit                 varchar(50)          null,
   datasource           varchar(50)          null,
   sqlstr1              clob                 null,
   sqlstr2              clob                 null,
   createrId            int                  null,
   createDate           char(10)             null,
   createTime           char(8)              null,
   updaterId            int                  null,
   updateDate           char(10)             null,
   updateTime           char(8)              null,
   deleted              int                  null,
   detailurl            clob                 null,
   parmtype             int                  null,
   provparm             varchar(50)          null,
   cityparm             varchar(50)          null,
   datefromparm         varchar(50)          null,
   datetoparm           varchar(50)          null
)
/  
create sequence dectuser_tb_seq 
increment by 1
start with 1
nomaxvalue
nocycle
/
create or replace trigger dectuser_tb_tri	
before insert on CRM_MapReport     
for each row                     
begin                            
      select dectuser_tb_seq.nextval into :new.id from dual;   
end;
/
INSERT INTO CRM_MapReport(name,unit,datasource,sqlstr1,sqlstr2,createrId,createDate,createTime,updaterId,updateDate,
updateTime,deleted,detailurl,parmtype,provparm,cityparm,datefromparm,datetoparm) 
VALUES ('客户分布统计', '客户数量(个)', '', 'select t2.provincename as province,count(t1.id) as amount from (#crmsql#) t1,HrmProvince t2,HrmCity t3
where t1.city=t3.id and t3.provinceid=t2.id  and (t1.deleted=0 or t1.deleted is null)  and t2.countryid=1
and t1.createdate>=''#datefrom#'' and t1.createdate<=''#dateto#'' and t1.createdate<>'''' and t1.createdate is not null
group by t2.provincename order by amount desc,t2.provincename', 'select t3.cityname as city,t2.provincename as province,count(t1.id) as amount from (#crmsql#) t1,HrmProvince t2,HrmCity t3
where t1.city=t3.id and t3.provinceid=t2.id and (t1.deleted=0 or t1.deleted is null) and t2.countryid=1
and t1.createdate>=''#datefrom#'' and t1.createdate<=''#dateto#'' and t1.createdate<>'''' and t1.createdate is not null
group by t3.id,t3.cityname,t2.provincename order by amount desc,t2.provincename,t3.cityname', 897, '2012-08-20', '18:50:37', 897, '2012-09-04', '16:15:38', 0, '/CRM/search/SearchTabFrame.jsp', 1, 'provinceIds', 'cityIds', 'createdatefrom', 'createdateto')
/