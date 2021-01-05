CREATE TABLE WorkPlanCreateShareSet(
ID int NOT NULL primary key,
planid int NULL ,
SHARETYPE int NULL ,
SECLEVEL int NULL ,
seclevelMax int NULL ,
ROLELEVEL int NULL ,
SHARELEVEL int NULL ,
USERID int NULL ,
SUBCOMPANYID int NULL ,
DEPARTMENTID int NULL ,
ROLEID int NULL ,
SUSERID int NULL 
)
/
create sequence WorkPlanCreateShareSet_ID
minvalue 1
increment by 1
/
create or replace trigger WorkPlanCreateShareSet_TR
 before insert on WorkPlanCreateShareSet for each row 
begin select WorkPlanCreateShareSet_ID.nextval into :new.id from dual; 
end;
/
ALTER table WorkPlanShare add isCreate VARCHAR(1) null
/