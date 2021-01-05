create table worktask_list(
  id             varchar(36),
  requestid         int ,
  name           varchar(300),
  enddate        varchar(30),
  wtorder        int,
  complete       char(1),
  completedate   varchar(30),
  completetime   varchar(30)
)

/

create table worktask_list_liableperson(
  wtlistid       varchar(36),
  userid         int
)

/


create table worktask_attention(
  userid         int,
  requestid      int
)

/

create table worktask_list_request(
  wtlistid        varchar(36),
  reqeustid            int
)

/

create table worktask_atinfo(
      id varchar(36) not null,
      userid varchar(200),
      requestid varchar(200)
)
/


create table worktask_discuss(
  id             varchar(36),
  reqeustid      int ,
  userid         int,
  datetime       varchar(30),
  content        varchar(4000)
)

/


create table worktask_operatetrace(
  id                 varchar(36),
  requestid          int ,
  userid             int,
  wtdate             varchar(30),
  wttime             varchar(30),
  previousstatus     char(2),
  currentstatus      char(2),
  type               char(2),
  wtlistid           varchar(36)
)

/

create table worktask_resource(
   requestid int not null,
   docs  varchar(1000),
   wfs  varchar(1000),
   custs varchar(1000),
   projs  varchar(1000),
   attachs varchar(1000)
)
/

alter table worktask_discuss add  docs  varchar(1000)
/
alter table worktask_discuss add  wfs  varchar(1000)
/   
alter table worktask_discuss add  custs  varchar(1000)
/   
alter table worktask_discuss add  projs  varchar(1000)
/   
alter table worktask_discuss add  attachs  varchar(1000)
/   

ALTER TRIGGER WORKTASK_BASE_ID_TRI DISABLE
/
INSERT INTO worktask_base(id,name,isvalid,issystem) values(-1,'ƒ¨»œ¿‡–Õ',1,1)
/
alter trigger WORKTASK_BASE_ID_TRI enable
/

insert into worktaskcreateshare(taskid,sharetype,seclevel,foralluser)values(-1,5,0,1)
/

insert into worktask_taskfield(taskid,fieldid,isshow,isedit,ismand,orderid)values(-1,27,1,1,0,0)
/

alter table worktask_requestbase modify (shareduser varchar(4000))
/

alter table worktask_requestbase add taskname  varchar(1000)
/

alter table worktask_requestbase add urgency  char(1)
/

update SysPubRef set detailLabel = 32556 where pubRefID=9
/