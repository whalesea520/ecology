CREATE TABLE WorkPlanShareSet
(
  ID                int        identity(1,1)             NOT NULL,
   planid            int,
  SHARETYPE         int,
  SECLEVEL          int,
  ROLELEVEL         int,
  SHARELEVEL        int,
  USERID           varchar(8000),
  SUBCOMPANYID     varchar(8000),
  DEPARTMENTID     varchar(8000),
  ROLEID            int,
  FORALLUSER        int, 
  SSHARETYPE         int,
  SSECLEVEL          int,
  SROLELEVEL         int,
  SUSERID            varchar(8000),
  SSUBCOMPANYID      varchar(8000),
  SDEPARTMENTID      varchar(8000),
  SROLEID            int,
  SFORALLUSER        int,
  settype        int
)
go

alter table workplansharedetail add  sharesrc varchar(1)
go

CREATE  PROCEDURE 
WorkPlanShareSet_Insert (@reportid_1       int, @sharetype_1	int, @seclevel_1	int, @rolelevel_1	int, 
@sharelevel_1	int, @userid_1	varchar(8000), @subcompanyid_1	varchar(8000), @departmentid_1	varchar(8000), 
@roleid_1	int, @foralluser_1	int, @sharetype_2	int, @seclevel_2	int, @rolelevel_2	int,
 @userid_2	varchar(8000), @subcompanyid_2	varchar(8000), @departmentid_2	varchar(8000), @roleid_2	int, @foralluser_2	int, 
 @settype_1	int,
@flag  	int output, @msg 	varchar output) as 
 insert into WorkPlanShareSet(planid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,
departmentid,roleid,foralluser,ssharetype,sseclevel,srolelevel,suserid,ssubcompanyid,sdepartmentid,sroleid,sforalluser,settype) 
values(@reportid_1,@sharetype_1,@seclevel_1,@rolelevel_1,@sharelevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@roleid_1,@foralluser_1,@sharetype_2,
@seclevel_2,@rolelevel_2,@userid_2,@subcompanyid_2,@departmentid_2,@roleid_2,@foralluser_2,@settype_1)

go
