create table HrmPSLManagement(
   id integer not null,
   resourceid int,   
   pslyear varchar(30),   
   psldays float,
   status int
)
/
create sequence HrmPSLManagement_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmPSLManagement_Trigger
before insert on HrmPSLManagement
for each row
begin
select HrmPSLManagement_id.nextval into :new.id from dual;
end;
/

create table HrmPSLBatchProcess(
   id integer not null,
   workingage float,
   psldays float,
   subcompanyid integer
)
/
create sequence HrmPSLBatchProcess_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmPSLBatchProcess_Trigger
before insert on HrmPSLBatchProcess
for each row
begin
select HrmPSLBatchProcess_id.nextval into :new.id from dual;
end;
/

create table HrmPSLPeriod(
   id integer not null,
   PSLyear varchar(30),
   startdate varchar(30),
   enddate varchar(30),
   subcompanyid integer
)
/
create sequence HrmPSLPeriod_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmPSLPeriod_Trigger
before insert on HrmPSLPeriod
for each row
begin
select HrmPSLPeriod_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_SelectItem(fieldid,isbill,selectvalue,selectname,listorder,isdefault) select max(id),1,11,'´øÐ½²¡¼Ù',11,'n' from workflow_billfield where billid=180 and fieldname='otherLeaveType'
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'lastyearpsldays',24039,'float',1,3,16,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'thisyearpsldays',24040,'float',1,3,10,0,'')
/
 
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype,detailtable) VALUES (180,'allpsldays',24041,'float',1,3,13,0,'')
/ 

update workflow_billfield set dsporder=40 where billid=180 and fieldname='leaveReason'
/

alter table bill_bohaileave add lastyearpsldays float
/
alter table bill_bohaileave add thisyearpsldays float
/
alter table bill_bohaileave add allpsldays float
/
