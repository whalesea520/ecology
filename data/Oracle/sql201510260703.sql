alter table hrmresource modify seclevel INT
/
CREATE TABLE hrmresourceout(
id int PRIMARY KEY,
resourceid integer,
wxname VARCHAR(500),
wxopenid integer,
wxuuid integer,
customid integer,
country VARCHAR(500), 
province VARCHAR(500), 
city VARCHAR(500), 
customfrom VARCHAR(500),
isoutmanager integer
)
/
create sequence hrmresourceout_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER hrmresourceout_trigger before insert on hrmresourceout for each row begin select hrmresourceout_id.nextval INTO :new.id from dual; end;
/

create TABLE customresourceout(
id int PRIMARY KEY,
customid int,
subcompanyid int,
crmdeptid int,
crmmanagerdeptid int
)
/
create sequence customresourceout_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER customresourceout_trigger before insert on customresourceout for each row begin select customresourceout_id.nextval INTO :new.id from dual; end;
/
drop sequence HRMCOMPANYVIRTUAL_ID
/
create sequence HRMCOMPANYVIRTUAL_ID
minvalue -99999999999999999
maxvalue -1
start with -10000
increment by -1
cache 20
/

INSERT into HrmCompanyVirtual( companyname ,companycode ,companydesc ,canceled ,showorder ,virtualType ,virtualtypedesc)
VALUES  ( '客户纬度' , '客户纬度' , '客户纬度' ,0 , 0 , '客户纬度' , '客户纬度' )
/