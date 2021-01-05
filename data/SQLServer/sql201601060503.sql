CREATE TABLE WorkPlanCreateShareSet(
ID int NOT NULL IDENTITY(1,1) ,
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
Go

ALTER table WorkPlanShare add isCreate VARCHAR(1) null
go