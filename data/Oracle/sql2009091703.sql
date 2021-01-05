create table bill_hrmtimedetail(
id integer,
requestid integer,
name varchar2(50),
resourceid integer,
accepterid varchar2(1000),
begindate char(10),
begintime char(8),
enddate char(10),
endtime char(8),
wakedate char(10),
delaydate char(10),
crmid integer,
projectid integer,
relatedrequestid integer,
isopen integer,
remark varchar2(2000),
alldoc varchar2(1000),
requestlevel integer
)
/
create sequence bill_hrmtimedetail_Id start with 1 increment by 1 nomaxvalue nocycle
/
CREATE OR REPLACE TRIGGER bill_hrmtimedetail_Id_Trigger before insert on bill_hrmtimedetail for each row begin select bill_hrmtimedetail_Id.nextval into :new.id from dual; end;
/
alter table bill_HrmTime add tempresourceid integer
/
update bill_HrmTime set tempresourceid=resourceid
/
alter table bill_HrmTime drop COLUMN resourceid
/
alter table bill_HrmTime add resourceid integer
/
update bill_HrmTime set resourceid=tempresourceid
/
alter table bill_HrmTime drop COLUMN tempresourceid
/
