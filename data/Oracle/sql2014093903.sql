alter table TM_TaskInfo add lev smallint
/
alter table TM_TaskInfo add showallsub smallint
/
create table TM_TaskTodo (
   id integer PRIMARY KEY not null,
   taskid               integer                  null,
   userid               integer                  null,
   tododate             char(10)             null
)
/
create sequence TM_TaskTodo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskTodo_id_trigger
before insert on TM_TaskTodo
for each row
begin
select TM_TaskTodo_id.nextval into :new.id from dual;
end;
/

create index TM_TT_Index_1 on TM_TaskTodo (
taskid ASC
)
/

create index TM_TT_Index_2 on TM_TaskTodo (
userid ASC
)
/


alter table TM_TaskFeedback add replyid integer
/

create table GP_AccessItem (
   id                   integer                   PRIMARY KEY not null,
   itemname             varchar2(100)         null,
   itemdesc             varchar2(500)         null,
   itemtype             smallint              null,
   itemunit             varchar2(50)          null,
   isvalid              smallint              null
)
/
create sequence GP_AccessItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_AccessItem_id_trigger
before insert on GP_AccessItem
for each row
begin
select GP_AccessItem_id.nextval into :new.id from dual;
end;
/

create table GP_AccessProgram (
   id                   integer                   PRIMARY KEY not null,
   programname          varchar2(100)         null,
   userid               integer                  null,
   startdate            varchar2(10)          null,
   programtype          smallint              null,
   status               smallint              null
)
/
create sequence GP_AccessProgram_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_AccessProgram_id_trigger
before insert on GP_AccessProgram
for each row
begin
select GP_AccessProgram_id.nextval into :new.id from dual;
end;
/

create index GP_AP_Index_1 on GP_AccessProgram (
userid ASC
)
/

create table GP_AccessProgramAudit (
   id                   integer                   PRIMARY KEY not null,
   programid            integer                  null,
   userid               integer                  null
)
/
create sequence GP_AccessProgramAudit_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_APA_id_trigger
before insert on GP_AccessProgramAudit
for each row
begin
select GP_AccessProgramAudit_id.nextval into :new.id from dual;
end;
/

create table GP_AccessProgramCheck (
   id                   integer                   PRIMARY KEY not null,
   programid            integer                  null,
   userid               integer                  null,
   rate                 decimal(10,2)        null,
   exeorder             integer                  null
)
/
create sequence GP_AccessProgramCheck_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_APC_id_trigger
before insert on GP_AccessProgramCheck
for each row
begin
select GP_AccessProgramCheck_id.nextval into :new.id from dual;
end;
/

create index GP_GPC_Index_1 on GP_AccessProgramCheck (
programid ASC
)
/

create table GP_AccessProgramDetail (
   id                   integer                   PRIMARY KEY not null,
   programid            integer                  null,
   cate                 varchar2(50)          null,
   accessitemid         integer                  null,
   name                 varchar2(100)         null,
   description          varchar2(500)         null,
   rate                 decimal(10,2)        null,
   target1              decimal(10,2)        null,
   target2              varchar2(4000)                 null
)
/
create sequence GP_AccessProgramDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_APD_id_trigger
before insert on GP_AccessProgramDetail
for each row
begin
select GP_AccessProgramDetail_id.nextval into :new.id from dual;
end;
/

create index GP_APD_Index_1 on GP_AccessProgramDetail (
programid ASC
)
/

create table GP_AccessProgramLog (
   id                   integer                   PRIMARY KEY not null,
   programid            integer                  null,
   operator             integer                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          smallint              null
)
/
create sequence GP_APL_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_APL_id_trigger
before insert on GP_AccessProgramLog
for each row
begin
select GP_APL_id.nextval into :new.id from dual;
end;
/

create index GP_GPL_Index_1 on GP_AccessProgramLog (
programid ASC
)
/

create table GP_AccessScore (
   id                   integer                   PRIMARY KEY not null,
   scorename            varchar2(100)         null,
   userid               integer                  null,
   year                 integer                  null,
   type1                smallint              null,
   type2                integer                  null,
   status               smallint              null,
   result               decimal(10,2)        null,
   startdate            char(10)             null,
   enddate              char(10)             null,
   operator             integer                  null,
   isupdate             smallint              null,
   isinit               smallint              null,
   isfirst              smallint              null,
   programid            integer                  null,
   isvalid              smallint              null,
   finishdate           char(10)             null,
   finishtime           char(8)              null
)
/
create sequence GP_AccessScore_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_AccessScore_id_trigger
before insert on GP_AccessScore
for each row
begin
select GP_AccessScore_id.nextval into :new.id from dual;
end;
/

create index GP_AS_Index_1 on GP_AccessScore (
userid ASC
)
/

create table GP_AccessScoreAudit (
   id                   integer                   PRIMARY KEY not null,
   scoreid              integer                  null,
   userid               integer                  null
)
/
create sequence GP_AccessScoreAudit_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_AccessScoreAudit_id_trigger
before insert on GP_AccessScoreAudit
for each row
begin
select GP_AccessScoreAudit_id.nextval into :new.id from dual;
end;
/

create table GP_AccessScoreCheck (
   id                   integer                   PRIMARY KEY not null,
   scoreid              integer                  null,
   userid               integer                  null,
   rate                 decimal(10,2)        null,
   score                decimal(10,2)        null,
   revise               decimal(10,2)        null,
   result               decimal(10,2)        null,
   remark               varchar2(4000)                 null,
   status               smallint              null,
   exeorder             integer                  null
)
/
create sequence GP_AccessScoreCheck_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_AccessSC_id_trigger
before insert on GP_AccessScoreCheck
for each row
begin
select GP_AccessScoreCheck_id.nextval into :new.id from dual;
end;
/

create index GP_ASC_Index_1 on GP_AccessScoreCheck (
scoreid ASC
)
/

create table GP_AccessScoreCheckDetail (
   id                   integer                   PRIMARY KEY not null,
   scoreid              integer                  null,
   detailid             integer                  null,
   checkid              integer                  null,
   score                decimal(10,2)        null,
   result               decimal(10,2)        null,
   remark               varchar2(4000)                 null
)
/
create sequence GP_ASCD_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_ASCD_id_trigger
before insert on GP_AccessScoreCheckDetail
for each row
begin
select GP_ASCD_id.nextval into :new.id from dual;
end;
/

create index GP_ASCD_Index_1 on GP_AccessScoreCheckDetail (
scoreid ASC
)
/

create table GP_AccessScoreDetail (
   id                   integer                   PRIMARY KEY not null,
   scoreid              integer                  null,
   cate                 varchar2(50)          null,
   accessitemid         integer                  null,
   name                 varchar2(100)         null,
   description          varchar2(500)         null,
   rate                 decimal(10,2)        null,
   target1              decimal(10,2)        null,
   target2              varchar2(4000)                 null,
   result1              decimal(10,2)        null,
   result2              varchar2(4000)                 null,
   next1                decimal(10,2)        null,
   next2                varchar2(4000)                 null
)
/
create sequence GP_ASD_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_ASD_id_trigger
before insert on GP_AccessScoreDetail
for each row
begin
select GP_ASD_id.nextval into :new.id from dual;
end;
/

create index GP_ASD_Index_1 on GP_AccessScoreDetail (
scoreid ASC
)
/

create table GP_AccessScoreLog (
   id                   integer                   PRIMARY KEY not null,
   scoreid              integer                  null,
   operator             integer                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          smallint              null
)
/
create sequence GP_AccessScoreLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_AccessScoreLog_id_trigger
before insert on GP_AccessScoreLog
for each row
begin
select GP_AccessScoreLog_id.nextval into :new.id from dual;
end;
/

create index GP_AccessSL_Index_1 on GP_AccessScoreLog (
scoreid ASC
)
/

create table GP_BaseSetting (
   id                   integer                   PRIMARY KEY not null,
   resourceid           integer                  null,
   resourcetype         smallint              null,
   isfyear              smallint              null,
   ishyear              smallint              null,
   isquarter            smallint              null,
   ismonth              smallint              null,
   fstarttype           integer                  null,
   fstartdays           integer                  null,
   fendtype             integer                  null,
   fenddays             integer                  null,
   hstarttype           integer                  null,
   hstartdays           integer                  null,
   hendtype             integer                  null,
   henddays             integer                  null,
   qstarttype           integer                  null,
   qstartdays           integer                  null,
   qendtype             integer                  null,
   qenddays             integer                  null,
   mstarttype           integer                  null,
   mstartdays           integer                  null,
   mendtype             integer                  null,
   menddays             integer                  null,
   programcreate        varchar2(4000)                 null,
   programaudit         varchar2(4000)                 null,
   manageraudit         smallint              null,
   accessconfirm        varchar2(4000)                 null,
   accessview           varchar2(4000)                 null,
   isself               smallint              null,
   ismanager            smallint              null
)
/
create sequence GP_BaseSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_BaseSetting_id_trigger
before insert on GP_BaseSetting
for each row
begin
select GP_BaseSetting_id.nextval into :new.id from dual;
end;
/

create table GP_InitTag (
   id                   integer                   PRIMARY KEY not null,
   type1                integer                  null,
   type2                integer                  null,
   year                 integer                  null
)
/
create sequence GP_InitTag_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_InitTag_id_trigger
before insert on GP_InitTag
for each row
begin
select GP_InitTag_id.nextval into :new.id from dual;
end;
/

alter table GP_AccessScore add isrescore smallint
/

alter table GP_AccessProgram add auditids varchar2(4000)
/

alter table GP_AccessScore add auditids varchar2(4000)
/

alter table GP_AccessScoreCheck add fileids varchar2(4000)
/

alter table GP_AccessItem add formula integer
/

alter table GP_BaseSetting add docsecid integer
/

create table GP_AccessScoreExchange (
   id                   integer                  PRIMARY KEY not null,
   scoreid              integer                  null,
   operator             integer                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   content              varchar2(4000)                 null
)
/

create sequence GP_AccessSE_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_AccessSE_id_trigger
before insert on GP_AccessScoreExchange
for each row
begin
select GP_AccessSE_id.nextval into :new.id from dual;
end;
/

create index GP_ASE_Index_1 on GP_AccessScoreExchange (
scoreid ASC
)
/

alter table GP_AccessProgram add remark varchar2(4000)
/

alter table GP_AccessScore add remark varchar2(4000)
/

alter table GP_AccessProgramDetail modify(description varchar2(4000))
/

alter table GP_AccessScoreDetail modify(description varchar2(4000))
/

alter table GP_AccessScoreLog add result decimal(10,2)
/

alter table GP_AccessScoreCheck add reason varchar2(4000)
/

alter table GP_BaseSetting add scoremin decimal(10,2)
/

alter table GP_BaseSetting add scoremax decimal(10,2)
/

alter table GP_BaseSetting add revisemin decimal(10,2)
/

alter table GP_BaseSetting add revisemax decimal(10,2)
/

create table PR_BaseSetting (
   id                   integer               PRIMARY KEY not null,
   resourceid           integer               null,
   resourcetype         smallint              null,
   isweek               smallint              null,
   ismonth              smallint              null,
   wstarttype           integer               null,
   wstartdays           integer               null,
   wendtype             integer               null,
   wenddays             integer               null,
   mstarttype           integer               null,
   mstartdays           integer               null,
   mendtype             integer               null,
   menddays             integer               null,
   programcreate        varchar2(4000)        null,
   reportaudit          varchar2(4000)        null,
   manageraudit         smallint              null,
   reportview           varchar2(4000)        null,
   isself               smallint              null,
   ismanager            smallint              null,
   docsecid             integer               null,
   iswremind            smallint              null,
   ismremind            smallint              null
)
/

create sequence PR_BaseSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_BaseSetting_id_trigger
before insert on PR_BaseSetting
for each row
begin
select PR_BaseSetting_id.nextval into :new.id from dual;
end;
/

create table PR_PlanProgram (
   id                   integer             PRIMARY KEY not null,
   userid               integer                  null,
   programtype          smallint              null,
   auditids             varchar2(4000)                 null
)
/

create sequence PR_PlanProgram_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PlanProgram_id_trigger
before insert on PR_PlanProgram
for each row
begin
select PR_PlanProgram_id.nextval into :new.id from dual;
end;
/

create index PR_PP_Index_1 on PR_PlanProgram (
userid ASC
)
/

create table PR_PlanProgramDetail (
   id                   integer              PRIMARY KEY not null,
   programid            integer                  null,
   planid               integer                  null,
   showname             varchar(100)         null,
   fieldname            varchar(100)         null,
   customname           varchar(100)         null,
   isshow               smallint              null,
   showorder            decimal(10,2)        null,
   showwidth            integer                  null,
   isshow2              smallint              null,
   showorder2           decimal(10,2)        null,
   showwidth2           integer                  null
)
/

create sequence PR_PlanProgramDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PRDetail_id_trigger
before insert on PR_PlanProgramDetail
for each row
begin
select PR_PlanProgramDetail_id.nextval into :new.id from dual;
end;
/

create index PR_PPD_Index_1 on PR_PlanProgramDetail (
programid ASC
)
/

create index PR_PPD_Index_2 on PR_PlanProgramDetail (
planid ASC
)
/

create table PR_PlanProgramLog (
   id                   integer              PRIMARY KEY not null,
   programid            integer                  null,
   operator             integer                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          smallint              null
)
/

create sequence PR_PlanProgramLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PlanProgramLog_id_trigger
before insert on PR_PlanProgramLog
for each row
begin
select PR_PlanProgramLog_id.nextval into :new.id from dual;
end;
/

create index PR_PPL_Index_1 on PR_PlanProgramLog (
programid ASC
)
/

create table PR_PlanReport (
   id                   integer              PRIMARY KEY not null,
   planname             varchar(100)         null,
   userid               integer                  null,
   year                 integer                  null,
   type1                smallint              null,
   type2                integer                  null,
   status               smallint              null,
   startdate            char(10)             null,
   enddate              char(10)             null,
   isupdate             smallint              null,
   isresubmit           smallint              null,
   isvalid              smallint              null,
   finishdate           char(10)             null,
   finishtime           char(8)              null,
   auditids             varchar2(4000)                 null,
   remark               varchar2(4000)                 null,
   fileids              varchar2(4000)                 null
)
/

create sequence PR_PlanReport_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PlanReport_id_trigger
before insert on PR_PlanReport
for each row
begin
select PR_PlanReport_id.nextval into :new.id from dual;
end;
/

create index PR_PR_Index_1 on PR_PlanReport (
userid ASC
)
/

create table PR_PlanReportDetail (
   id                   integer              PRIMARY KEY not null,
   programid            integer                  null,
   planid               integer                  null,
   planid2              integer                  null,
   datatype             smallint              null,
   userid               integer                  null,
   name                 varchar2(4000)         null,
   cate                 varchar(100)         null,
   begindate1           char(10)             null,
   enddate1             char(10)             null,
   days1                varchar(50)          null,
   begindate2           char(10)             null,
   enddate2             varchar(50)          null,
   days2                varchar(50)          null,
   finishrate           varchar(50)          null,
   target               varchar2(4000)                 null,
   result               varchar2(4000)                 null,
   taskids              varchar2(4000)                 null,
   goalids              varchar2(4000)                 null,
   crmids               varchar2(4000)                 null,
   docids               varchar2(4000)                 null,
   wfids                varchar2(4000)                 null,
   projectids           varchar2(4000)                 null,
   fileids              varchar2(4000)                 null,
   custom1              varchar2(4000)                 null,
   custom2              varchar2(4000)                 null,
   custom3              varchar2(4000)                 null,
   custom4              varchar2(4000)                 null,
   custom5              varchar2(4000)                 null
)
/

create sequence PR_PlanReportDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PlanReportDetail_id_trigger
before insert on PR_PlanReportDetail
for each row
begin
select PR_PlanReportDetail_id.nextval into :new.id from dual;
end;
/

create index PR_PRD_Index_1 on PR_PlanReportDetail (
planid ASC
)
/

create index PR_PRD_Index_2 on PR_PlanReportDetail (
planid2 ASC
)
/

create table PR_PlanReportAudit (
   id                   integer              PRIMARY KEY not null,
   planid               integer                  null,
   userid               integer                  null
)
/

create sequence PR_PlanReportAudit_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PlanReportAudit_id_trigger
before insert on PR_PlanReportAudit
for each row
begin
select PR_PlanReportAudit_id.nextval into :new.id from dual;
end;
/

create table PR_PlanReportLog (
   id                   integer              PRIMARY KEY not null,
   planid               integer                  null,
   operator             integer                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          smallint              null
)
/

create sequence PR_PlanReportLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PlanReportLog_id_trigger
before insert on PR_PlanReportLog
for each row
begin
select PR_PlanReportLog_id.nextval into :new.id from dual;
end;
/

create index GP_ASL_Index_1 on PR_PlanReportLog (
planid ASC
)
/

create table PR_PlanReportExchange (
   id                   integer              PRIMARY KEY not null,
   planid               integer                  null,
   operator             integer                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   content              varchar2(4000)                 null
)
/

create sequence PR_PlanReportExchange_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PRExchange_id_trigger
before insert on PR_PlanReportExchange
for each row
begin
select PR_PlanReportExchange_id.nextval into :new.id from dual;
end;
/

create index PR_PRE_Index_1 on PR_PlanReportExchange (
planid ASC
)
/

INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'分类','cate','',1,1,1,1,1,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'标题','name','',1,2,2,1,2,2)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划开始日期','begindate1','',0,3,1,1,3,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划结束日期','enddate1','',0,4,1,1,4,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划天数','days1','',0,5,1,1,5,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划目标','target','',0,6,4,1,6,4)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'实际开始日期','begindate2','',1,7,1,0,7,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'实际结束日期','enddate2','',1,8,1,0,8,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'实际天数','days2','',1,9,1,0,9,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'完成比例','finishrate','',1,10,1,0,10,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'完成情况','result','',1,11,4,0,11,4)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段1','custom1','',0,12,1,0,7,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段2','custom2','',0,13,1,0,8,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段3','custom3','',0,14,1,0,9,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段4','custom4','',0,15,1,0,10,1)
/
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段5','custom5','',0,16,1,0,11,1)
/

alter table PR_PlanReportDetail add showorder integer
/

create table PR_PlanFeedback (
   id                   integer           PRIMARY KEY  not null,
   plandetailid         integer                        null,
   remark               varchar2(4000)                 null,
   hrmid                integer                        null,
   type                 smallint                       null,
   docids               varchar2(4000)                 null,
   wfids                varchar2(4000)                 null,
   meetingids           varchar2(4000)                 null,
   crmids               varchar2(4000)                 null,
   projectids           varchar2(4000)                 null,
   fileids              varchar2(4000)                 null,
   createdate           char(10)                       null,
   createtime           char(8)                        null
)
/
create sequence PR_PlanFeedback_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PR_PlanFeedback_id_trigger
before insert on PR_PlanFeedback
for each row
begin
select PR_PlanFeedback_id.nextval into :new.id from dual;
end;
/

create index PR_PFB_Index_2 on PR_PlanFeedback (
plandetailid ASC
)
/

create index PR_PFB_Index_3 on PR_PlanFeedback (
hrmid ASC
)
/

alter table PR_PlanReport add remindids varchar2(4000)
/


alter table GP_AccessScore add remindids varchar2(4000)
/

create table GM_GoalInfo (
   id                   integer                 PRIMARY KEY not null,
   name                 varchar2(2000)                 null,
   status               smallint              null,
   typeid               integer                  null,
   attribute            smallint              null,
   cate                 varchar(100)         null,
   remark               varchar2(4000)                 null,
   target               decimal(10,2)        null,
   tunit                varchar(100)         null,
   result               decimal(10,2)        null,
   runit                varchar(100)         null,
   rate                 varchar(200)         null,
   period               integer                  null,
   arrangerid           integer                  null,
   principalid          integer                  null,
   partnerids           varchar2(4000)                 null,
   begindate            char(10)             null,
   enddate              char(10)             null,
   parentid             integer                  null,
   taskids              varchar2(4000)                 null,
   docids               varchar2(4000)                 null,
   wfids                varchar2(4000)                 null,
   meetingids           varchar2(4000)                 null,
   crmids               varchar2(4000)                 null,
   projectids           varchar2(4000)                 null,
   goalids              varchar2(4000)                 null,
   planids              varchar2(4000)                 null,
   fileids              varchar2(4000)                 null,
   creater              integer                  null,
   createdate           char(10)             null,
   createtime           char(8)              null,
   updater              integer                  null,
   updatedate           char(10)             null,
   updatetime           char(8)              null,
   deleted              smallint              null,
   showallsub           smallint              null
)
/
create sequence GM_GoalInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_GoalInfo_id_trigger
before insert on GM_GoalInfo
for each row
begin
select GM_GoalInfo_id.nextval into :new.id from dual;
end;
/

create index GM_GI_Index_2 on GM_GoalInfo (
arrangerid ASC
)
/

create index GM_GI_Index_3 on GM_GoalInfo (
principalid ASC
)
/

create index GM_GI_Index_4 on GM_GoalInfo (
parentid ASC
)
/

create table GM_GoalFeedback (
   id                   integer                  PRIMARY KEY not null,
   goalid               integer                  null,
   content              varchar2(4000)                 null,
   hrmid                integer                  null,
   type                 smallint              null,
   docids               varchar2(4000)                 null,
   wfids                varchar2(4000)                 null,
   meetingids           varchar2(4000)                 null,
   crmids               varchar2(4000)                 null,
   projectids           varchar2(4000)                 null,
   fileids              varchar2(4000)                 null,
   createdate           char(10)             null,
   createtime           char(8)              null
)
/

create sequence GM_GoalFeedback_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_GoalFeedback_id_trigger
before insert on GM_GoalFeedback
for each row
begin
select GM_GoalFeedback_id.nextval into :new.id from dual;
end;
/

create index GM_GF_Index_2 on GM_GoalFeedback (
goalid ASC
)
/

create index GM_GF_Index_3 on GM_GoalFeedback (
hrmid ASC
)
/

create table GM_GoalLog (
   id                   integer                  PRIMARY KEY not null,
   goalid               integer                  null,
   type                 smallint              null,
   operator             integer                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatefiled         varchar(50)          null,
   operatevalue         varchar2(4000)                 null
)
/
create sequence GM_GoalLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_GoalLog_id_trigger
before insert on GM_GoalLog
for each row
begin
select GM_GoalLog_id.nextval into :new.id from dual;
end;
/

create index GM_GL_Index_2 on GM_GoalLog (
goalid ASC
)
/

create table GM_GoalPartner (
   id                   integer                 PRIMARY KEY not null,
   goalid               integer                  null,
   partnerid            integer                  null
)
/
create sequence GM_GoalPartner_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_GoalPartner_id_trigger
before insert on GM_GoalPartner
for each row
begin
select GM_GoalPartner_id.nextval into :new.id from dual;
end;
/

create index GM_GP_Index_1 on GM_GoalPartner (
goalid ASC
)
/

create table GM_GoalSharer (
   id                   integer                 PRIMARY KEY not null,
   goalid               integer                  null,
   sharerid             integer                  null
)
/
create sequence GM_GoalSharer_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_GoalSharer_id_trigger
before insert on GM_GoalSharer
for each row
begin
select GM_GoalSharer_id.nextval into :new.id from dual;
end;
/
create index GM_GS_Index_1 on GM_GoalSharer (
goalid ASC
)
/

create table GM_GoalSpecial (
   id                   integer                  PRIMARY KEY not null,
   goalid               integer                  null,
   userid               integer                  null
)
/
create sequence GM_GoalSpecial_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_GoalSpecial_id_trigger
before insert on GM_GoalSpecial
for each row
begin
select GM_GoalSpecial_id.nextval into :new.id from dual;
end;
/

create index GM_GSL_Index_1 on GM_GoalSpecial (
goalid ASC
)
/

create index GM_GSL_Index_2 on GM_GoalSpecial (
userid ASC
)
/

create table GM_RightSetting (
   id                   integer                  PRIMARY KEY not null,
   orgId                integer                  null,
   type                 integer                  null,
   hrmId                integer                  null
)
/
create sequence GM_RightSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_RightSetting_id_trigger
before insert on GM_RightSetting
for each row
begin
select GM_RightSetting_id.nextval into :new.id from dual;
end;
/

create table GM_BaseSetting (
   id                   integer                  PRIMARY KEY not null,
   goalmaint            varchar2(4000)                 null,
   iscgoal              smallint              null,
   isself               smallint              null
)
/
create sequence GM_BaseSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GM_BaseSetting_id_trigger
before insert on GM_BaseSetting
for each row
begin
select GM_BaseSetting_id.nextval into :new.id from dual;
end;
/

alter table GM_GoalInfo add showorder decimal(10,2)
/

alter table PR_PlanProgram add shareids varchar2(4000)
/

alter table PR_PlanReport add shareids varchar2(4000)
/

create table TM_TaskView (
   id                   integer PRIMARY KEY not null,
   userid               integer                  null,
   menutype             integer                  null,
   listtype				integer				null,
   status				integer				null,
   viewdate             char(19)             null,
   taskid				integer null,
   seltag				char(200) null,
   subuserid			integer null
)
/

create sequence TM_TaskView_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger TM_TaskView_id_trigger
before insert on TM_TaskView
for each row
begin
select TM_TaskView_id.nextval into :new.id from dual;
end;
/

CREATE TABLE GP_ScoreSetting
    (
      id          integer             PRIMARY KEY not null,
      gardename   VARCHAR(100) ,
      beginSymbol integer ,
      beginscore  DECIMAL(10, 2) ,
      endSymbol   integer ,
      endscore    DECIMAL(10, 2) ,
      rank INT
    )

/
create sequence GP_ScoreSetting_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger GP_ScoreSetting_id_trigger
before insert on GP_ScoreSetting
for each row
begin
select GP_ScoreSetting_id.nextval into :new.id from dual;
end;
/


ALTER TABLE GP_BaseSetting ADD scoreSetting integer
/