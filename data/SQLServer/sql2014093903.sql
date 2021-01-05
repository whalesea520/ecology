alter table TM_TaskInfo add lev tinyint
go

alter table TM_TaskInfo add showallsub tinyint
go

alter table TM_TaskFeedback add replyid int
go

create table TM_TaskTodo (
   id                   int                  identity,
   taskid               int                  null,
   userid               int                  null,
   tododate             char(10)             null,
   constraint PK_TM_TASKTODO primary key (id)
)
go

create index TM_TT_Index_1 on TM_TaskTodo (
taskid ASC
)
go

create index TM_TT_Index_2 on TM_TaskTodo (
userid ASC
)
go

if not exists(select 1 from syscolumns where id=object_id('TM_TaskFeedback') and name='replyid')
alter table TM_TaskFeedback add replyid int
go

if exists(select 1 from syscolumns where id=object_id('TM_TaskInfo') and name='level')
exec sp_rename 'TM_TaskInfo.level','lev','column'
go

create table GP_AccessItem (
   id                   int                  identity,
   itemname             varchar(100)         null,
   itemdesc             varchar(500)         null,
   itemtype             tinyint              null,
   itemunit             varchar(50)          null,
   isvalid              tinyint              null,
   constraint PK_GP_ACCESSITEM primary key (id)
)
go

create table GP_AccessProgram (
   id                   int                  identity,
   programname          varchar(100)         null,
   userid               int                  null,
   startdate            varchar(10)          null,
   programtype          tinyint              null,
   status               tinyint              null,
   constraint PK_GP_ACCESSPROGRAM primary key (id)
)
go

create index GP_AP_Index_1 on GP_AccessProgram (
userid ASC
)
go

create table GP_AccessProgramAudit (
   id                   int                  identity,
   programid            int                  null,
   userid               int                  null,
   constraint PK_GP_ACCESSPROGRAMAUDIT primary key (id)
)
go

create table GP_AccessProgramCheck (
   id                   int                  identity,
   programid            int                  null,
   userid               int                  null,
   rate                 decimal(10,2)        null,
   exeorder             int                  null,
   constraint PK_GP_ACCESSPROGRAMCHECK primary key (id)
)
go

create index GP_GPC_Index_1 on GP_AccessProgramCheck (
programid ASC
)
go

create table GP_AccessProgramDetail (
   id                   int                  identity,
   programid            int                  null,
   cate                 varchar(50)          null,
   accessitemid         int                  null,
   name                 varchar(100)         null,
   description          varchar(500)         null,
   rate                 decimal(10,2)        null,
   target1              decimal(10,2)        null,
   target2              text                 null,
   constraint PK_GP_ACCESSPROGRAMDETAIL primary key (id)
)
go

create index GP_APD_Index_1 on GP_AccessProgramDetail (
programid ASC
)
go

create table GP_AccessProgramLog (
   id                   int                  identity,
   programid            int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          tinyint              null,
   constraint PK_GP_ACCESSPROGRAMLOG primary key (id)
)
go

create index GP_GPL_Index_1 on GP_AccessProgramLog (
programid ASC
)
go

create table GP_AccessScore (
   id                   int                  identity,
   scorename            varchar(100)         null,
   userid               int                  null,
   year                 int                  null,
   type1                tinyint              null,
   type2                int                  null,
   status               tinyint              null,
   result               decimal(10,2)        null,
   startdate            char(10)             null,
   enddate              char(10)             null,
   operator             int                  null,
   isupdate             tinyint              null,
   isinit               tinyint              null,
   isfirst              tinyint              null,
   programid            int                  null,
   isvalid              tinyint              null,
   finishdate           char(10)             null,
   finishtime           char(8)              null,
   constraint PK_GP_ACCESSSCORE primary key (id)
)
go

create index GP_AS_Index_1 on GP_AccessScore (
userid ASC
)
go

create table GP_AccessScoreAudit (
   id                   int                  identity,
   scoreid              int                  null,
   userid               int                  null,
   constraint PK_GP_ACCESSSCOREAUDIT primary key (id)
)
go

create table GP_AccessScoreCheck (
   id                   int                  identity,
   scoreid              int                  null,
   userid               int                  null,
   rate                 decimal(10,2)        null,
   score                decimal(10,2)        null,
   revise               decimal(10,2)        null,
   result               decimal(10,2)        null,
   remark               text                 null,
   status               tinyint              null,
   exeorder             int                  null,
   constraint PK_GP_ACCESSSCORECHECK primary key (id)
)
go

create index GP_ASC_Index_1 on GP_AccessScoreCheck (
scoreid ASC
)
go

create table GP_AccessScoreCheckDetail (
   id                   int                  identity,
   scoreid              int                  null,
   detailid             int                  null,
   checkid              int                  null,
   score                decimal(10,2)        null,
   result               decimal(10,2)        null,
   remark               text                 null,
   constraint PK_GP_ACCESSSCORECHECKDETAIL primary key (id)
)
go

create index GP_ASCD_Index_1 on GP_AccessScoreCheckDetail (
scoreid ASC
)
go

create table GP_AccessScoreDetail (
   id                   int                  identity,
   scoreid              int                  null,
   cate                 varchar(50)          null,
   accessitemid         int                  null,
   name                 varchar(100)         null,
   description          varchar(500)         null,
   rate                 decimal(10,2)        null,
   target1              decimal(10,2)        null,
   target2              text                 null,
   result1              decimal(10,2)        null,
   result2              text                 null,
   next1                decimal(10,2)        null,
   next2                text                 null,
   constraint PK_GP_ACCESSSCOREDETAIL primary key (id)
)
go

create index GP_ASD_Index_1 on GP_AccessScoreDetail (
scoreid ASC
)
go

create table GP_AccessScoreLog (
   id                   int                  identity,
   scoreid              int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          tinyint              null,
   constraint PK_GP_ACCESSSCORELOG primary key (id)
)
go

create index GP_ASL_Index_1 on GP_AccessScoreLog (
scoreid ASC
)
go

create table GP_BaseSetting (
   id                   int                  identity,
   resourceid           int                  null,
   resourcetype         tinyint              null,
   isfyear              tinyint              null,
   ishyear              tinyint              null,
   isquarter            tinyint              null,
   ismonth              tinyint              null,
   fstarttype           int                  null,
   fstartdays           int                  null,
   fendtype             int                  null,
   fenddays             int                  null,
   hstarttype           int                  null,
   hstartdays           int                  null,
   hendtype             int                  null,
   henddays             int                  null,
   qstarttype           int                  null,
   qstartdays           int                  null,
   qendtype             int                  null,
   qenddays             int                  null,
   mstarttype           int                  null,
   mstartdays           int                  null,
   mendtype             int                  null,
   menddays             int                  null,
   programcreate        text                 null,
   programaudit         text                 null,
   manageraudit         tinyint              null,
   accessconfirm        text                 null,
   accessview           text                 null,
   isself               tinyint              null,
   ismanager            tinyint              null,
   constraint PK_GP_BASESETTING primary key (id)
)
go

create table GP_InitTag (
   id                   int                  identity,
   type1                int                  null,
   type2                int                  null,
   year                 int                  null,
   constraint PK_GP_INITTAG primary key (id)
)
go

alter table GP_AccessScore add isrescore tinyint
go

alter table GP_AccessProgram add auditids text
go

alter table GP_AccessScore add auditids text
go

alter table GP_AccessScoreCheck add fileids text
go

alter table GP_AccessItem add formula int
go

alter table GP_BaseSetting add docsecid int
go

create table GP_AccessScoreExchange (
   id                   int                  identity,
   scoreid              int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   content              text                 null,
   constraint PK_GP_ACCESSSCOREEXCHANGE primary key (id)
)
go

create index GP_ASE_Index_1 on GP_AccessScoreExchange (
scoreid ASC
)
go

alter table GP_AccessProgram add remark text
go

alter table GP_AccessScore add remark text
go

alter table GP_AccessProgramDetail alter column description varchar(8000)
go

alter table GP_AccessScoreDetail alter column description varchar(8000)
go

alter table GP_AccessScoreLog add result decimal(10,2)
go

alter table GP_AccessScoreCheck add reason text
go

alter table GP_BaseSetting add scoremin decimal(10,2)
go

alter table GP_BaseSetting add scoremax decimal(10,2)
go

alter table GP_BaseSetting add revisemin decimal(10,2)
go

alter table GP_BaseSetting add revisemax decimal(10,2)
go

create table PR_BaseSetting (
   id                   int                  identity,
   resourceid           int                  null,
   resourcetype         tinyint              null,
   isweek               tinyint              null,
   ismonth              tinyint              null,
   wstarttype           int                  null,
   wstartdays           int                  null,
   wendtype             int                  null,
   wenddays             int                  null,
   mstarttype           int                  null,
   mstartdays           int                  null,
   mendtype             int                  null,
   menddays             int                  null,
   programcreate        text                 null,
   reportaudit          text                 null,
   manageraudit         tinyint              null,
   reportview           text                 null,
   isself               tinyint              null,
   ismanager            tinyint              null,
   docsecid             int                  null,
   iswremind            tinyint              null,
   ismremind            tinyint              null,
   constraint PK_PR_BASESETTING primary key (id)
)
go

create table PR_PlanProgram (
   id                   int                  identity,
   userid               int                  null,
   programtype          tinyint              null,
   auditids             text                 null,
   constraint PK_PR_PLANPROGRAM primary key (id)
)
go

create index PR_PP_Index_1 on PR_PlanProgram (
userid ASC
)
go

create table PR_PlanProgramDetail (
   id                   int                  identity,
   programid            int                  null,
   planid               int                  null,
   showname             varchar(100)         null,
   fieldname            varchar(100)         null,
   customname           varchar(100)         null,
   isshow               tinyint              null,
   showorder            decimal(10,2)        null,
   showwidth            int                  null,
   isshow2              tinyint              null,
   showorder2           decimal(10,2)        null,
   showwidth2           int                  null,
   constraint PK_PR_PLANPROGRAMDETAIL primary key (id)
)
go

create index PR_PPD_Index_1 on PR_PlanProgramDetail (
programid ASC
)
go

create index PR_PPD_Index_2 on PR_PlanProgramDetail (
planid ASC
)
go

create table PR_PlanProgramLog (
   id                   int                  identity,
   programid            int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          tinyint              null,
   constraint PK_PR_PLANPROGRAMLOG primary key (id)
)
go

create index PR_PPL_Index_1 on PR_PlanProgramLog (
programid ASC
)
go

create table PR_PlanReport (
   id                   int                  identity,
   planname             varchar(100)         null,
   userid               int                  null,
   year                 int                  null,
   type1                tinyint              null,
   type2                int                  null,
   status               tinyint              null,
   startdate            char(10)             null,
   enddate              char(10)             null,
   isupdate             tinyint              null,
   isresubmit           tinyint              null,
   isvalid              tinyint              null,
   finishdate           char(10)             null,
   finishtime           char(8)              null,
   auditids             text                 null,
   remark               text                 null,
   fileids              text                 null,
   constraint PK_PR_PLANREPORT primary key (id)
)
go

create index PR_PR_Index_1 on PR_PlanReport (
userid ASC
)
go

create table PR_PlanReportDetail (
   id                   int                  identity,
   programid            int                  null,
   planid               int                  null,
   planid2              int                  null,
   datatype             tinyint              null,
   userid               int                  null,
   name                 varchar(100)         null,
   cate                 varchar(100)         null,
   begindate1           char(10)             null,
   enddate1             char(10)             null,
   days1                varchar(50)          null,
   begindate2           char(10)             null,
   enddate2             varchar(50)          null,
   days2                varchar(50)          null,
   finishrate           varchar(50)          null,
   target               text                 null,
   result               text                 null,
   taskids              text                 null,
   goalids              text                 null,
   crmids               text                 null,
   docids               text                 null,
   wfids                text                 null,
   projectids           text                 null,
   fileids              text                 null,
   custom1              text                 null,
   custom2              text                 null,
   custom3              text                 null,
   custom4              text                 null,
   custom5              text                 null,
   constraint PK_PR_PLANREPORTDETAIL primary key (id)
)
go

create index PR_PRD_Index_1 on PR_PlanReportDetail (
planid ASC
)
go

create index PR_PRD_Index_2 on PR_PlanReportDetail (
planid2 ASC
)
go

create table PR_PlanReportAudit (
   id                   int                  identity,
   planid               int                  null,
   userid               int                  null,
   constraint PK_PR_PLANREPORTAUDIT primary key (id)
)
go

create table PR_PlanReportLog (
   id                   int                  identity,
   planid               int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatetype          tinyint              null,
   constraint PK_PR_PLANREPORTLOG primary key (id)
)
go

create index GP_ASL_Index_1 on PR_PlanReportLog (
planid ASC
)
go

create table PR_PlanReportExchange (
   id                   int                  identity,
   planid               int                  null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   content              text                 null,
   constraint PK_PR_PLANREPORTEXCHANGE primary key (id)
)
go

create index PR_PRE_Index_1 on PR_PlanReportExchange (
planid ASC
)
go

INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'分类','cate','',1,1,1,1,1,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'标题','name','',1,2,2,1,2,2)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划开始日期','begindate1','',0,3,1,1,3,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划结束日期','enddate1','',0,4,1,1,4,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划天数','days1','',0,5,1,1,5,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'计划目标','target','',0,6,4,1,6,4)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'实际开始日期','begindate2','',1,7,1,0,7,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'实际结束日期','enddate2','',1,8,1,0,8,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'实际天数','days2','',1,9,1,0,9,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'完成比例','finishrate','',1,10,1,0,10,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'完成情况','result','',1,11,4,0,11,4)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段1','custom1','',0,12,1,0,7,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段2','custom2','',0,13,1,0,8,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段3','custom3','',0,14,1,0,9,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段4','custom4','',0,15,1,0,10,1)
GO
INSERT INTO PR_PlanProgramDetail (programid,showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2) VALUES (0,'自定义字段5','custom5','',0,16,1,0,11,1)
GO

alter table PR_PlanReportDetail add showorder int
go

alter table PR_PlanReportDetail alter column name text
go

create table PR_PlanFeedback (
   id                   int                  identity,
   plandetailid         int                  null,
   remark               text                 null,
   hrmid                int                  null,
   type                 tinyint              null,
   docids               text                 null,
   wfids                text                 null,
   meetingids           text                 null,
   crmids               text                 null,
   projectids           text                 null,
   fileids              text                 null,
   createdate           char(10)             null,
   createtime           char(8)              null,
   constraint PK_PR_PLANFEEDBACK primary key (id)
)
go

create index PR_PFB_Index_1 on PR_PlanFeedback (
id ASC
)
go

create index PR_PFB_Index_2 on PR_PlanFeedback (
plandetailid ASC
)
go

create index PR_PFB_Index_3 on PR_PlanFeedback (
hrmid ASC
)
go

alter table PR_PlanReport add remindids text
go

alter table GP_AccessScore add remindids text
go

create table GM_GoalInfo (
   id                   int                  identity,
   name                 text                 null,
   status               tinyint              null,
   typeid               int                  null,
   attribute            tinyint              null,
   cate                 varchar(100)         null,
   remark               text                 null,
   target               decimal(10,2)        null,
   tunit                varchar(100)         null,
   result               decimal(10,2)        null,
   runit                varchar(100)         null,
   rate                 varchar(200)         null,
   period               int                  null,
   arrangerid           int                  null,
   principalid          int                  null,
   partnerids           text                 null,
   begindate            char(10)             null,
   enddate              char(10)             null,
   parentid             int                  null,
   taskids              text                 null,
   docids               text                 null,
   wfids                text                 null,
   meetingids           text                 null,
   crmids               text                 null,
   projectids           text                 null,
   goalids              text                 null,
   planids              text                 null,
   fileids              text                 null,
   creater              int                  null,
   createdate           char(10)             null,
   createtime           char(8)              null,
   updater              int                  null,
   updatedate           char(10)             null,
   updatetime           char(8)              null,
   deleted              tinyint              null,
   showallsub           tinyint              null,
   constraint PK_GM_GOALINFO primary key (id)
)
go

create index GM_GI_Index_1 on GM_GoalInfo (
id ASC
)
go

create index GM_GI_Index_2 on GM_GoalInfo (
arrangerid ASC
)
go

create index GM_GI_Index_3 on GM_GoalInfo (
principalid ASC
)
go

create index GM_GI_Index_4 on GM_GoalInfo (
parentid ASC
)
go

create table GM_GoalFeedback (
   id                   int                  identity,
   goalid               int                  null,
   content              text                 null,
   hrmid                int                  null,
   type                 tinyint              null,
   docids               text                 null,
   wfids                text                 null,
   meetingids           text                 null,
   crmids               text                 null,
   projectids           text                 null,
   fileids              text                 null,
   createdate           char(10)             null,
   createtime           char(8)              null,
   constraint PK_GM_GOALFEEDBACK primary key (id)
)
go

create index GM_GF_Index_1 on GM_GoalFeedback (
id ASC
)
go

create index GM_GF_Index_2 on GM_GoalFeedback (
goalid ASC
)
go

create index GM_GF_Index_3 on GM_GoalFeedback (
hrmid ASC
)
go

create table GM_GoalLog (
   id                   int                  identity,
   goalid               int                  null,
   type                 tinyint              null,
   operator             int                  null,
   operatedate          char(10)             null,
   operatetime          char(8)              null,
   operatefiled         varchar(50)          null,
   operatevalue         text                 null,
   constraint PK_GM_GOALLOG primary key (id)
)
go

create index GM_GL_Index_1 on GM_GoalLog (
id ASC
)
go

create index GM_GL_Index_2 on GM_GoalLog (
goalid ASC
)
go

create table GM_GoalPartner (
   id                   int                  identity,
   goalid               int                  null,
   partnerid            int                  null,
   constraint PK_GM_GOALPARTNER primary key (id)
)
go

create index GM_GP_Index_1 on GM_GoalPartner (
goalid ASC
)
go

create table GM_GoalSharer (
   id                   int                  identity,
   goalid               int                  null,
   sharerid             int                  null,
   constraint PK_GM_GOALSHARER primary key (id)
)
go

create index GM_GS_Index_1 on GM_GoalSharer (
goalid ASC
)
go

create table GM_GoalSpecial (
   id                   int                  identity,
   goalid               int                  null,
   userid               int                  null,
   constraint PK_GM_GOALSPECIAL primary key (id)
)
go

create index GM_GSL_Index_1 on GM_GoalSpecial (
goalid ASC
)
go

create index GM_GSL_Index_2 on GM_GoalSpecial (
userid ASC
)
go

create table GM_RightSetting (
   id                   int                  identity,
   orgId                int                  null,
   type                 int                  null,
   hrmId                int                  null,
   constraint PK_GM_RIGHTSETTING primary key (id)
)
go

create table GM_BaseSetting (
   id                   int                  identity,
   goalmaint            text                 null,
   iscgoal              tinyint              null,
   isself               tinyint              null,
   constraint PK_GM_BASESETTING primary key (id)
)
go

alter table GM_GoalInfo add showorder decimal(10,2)
go

alter table PR_PlanProgram add shareids text
go

alter table PR_PlanReport add shareids text
go



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('GetdeptTree'))
 DROP FUNCTION GetdeptTree 
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('GetSubCpyTree'))
 DROP FUNCTION GetSubCpyTree
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('F_split'))
 DROP FUNCTION F_split 
 go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('GetSubcpyIdsTreeWithSelf'))
 DROP FUNCTION GetSubcpyIdsTreeWithSelf
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('GetDeptIdsTreeWithSelf'))
 DROP FUNCTION GetDeptIdsTreeWithSelf
go


CREATE FUNCTION GetdeptTree()
returns @t TABLE(
  id             INT,
  departmentname VARCHAR(50),
  supdepid       INT,
  subcompanyid1  INT,
  code           VARCHAR(100),
  level          INT )
AS
  BEGIN
      INSERT @t
      SELECT id,
             departmentname,
             supdepid,
             subcompanyid1,
             CONVERT(VARCHAR, ( 'dept_' + CONVERT(VARCHAR, id) )) AS code,
             1                                                    level
      FROM   HrmDepartment
      WHERE  supdepid = 0
	         AND (canceled IS NULL 
			 OR  canceled!=1)

      WHILE @@rowcount > 0
        INSERT @t
        SELECT dept.id,
               dept.departmentname,
               dept.supdepid,
               dept.subcompanyid1,
               CONVERT(VARCHAR, ( CONVERT(VARCHAR, B.code) + '_'
                                  + CONVERT(VARCHAR, dept.id) )) AS code,
               level + 1
        FROM   HrmDepartment dept,
               @t B
        WHERE  dept.supdepid = B.id
		       AND (dept.canceled IS NULL 
			   OR  dept.canceled!=1)
               AND dept.id NOT IN(SELECT id
                                  FROM   @t)

      RETURN
  END
go
  
CREATE FUNCTION GetSubCpyTree()
returns @t TABLE(
  id             INT,
  subcompanyname VARCHAR(50),
  supsubcomid    INT,
  code           VARCHAR(50),
  level          INT)
AS
  BEGIN
      INSERT @t
      SELECT id,
             subcompanyname,
             supsubcomid,
             CONVERT(VARCHAR, ( CONVERT(VARCHAR, id) )) AS code,
             1                                          level
      FROM   HrmSubCompany
      WHERE  supsubcomid = 0
	         AND (canceled IS NULL 
			 OR  canceled!=1)

      WHILE @@rowcount > 0
        INSERT @t
        SELECT hrm.id,
               hrm.subcompanyname,
               hrm.supsubcomid,
               CONVERT(VARCHAR, ( CONVERT(VARCHAR, b.code) + '_'
                                  + CONVERT(VARCHAR, hrm.id) )) AS code,
               level + 1
        FROM   HrmSubCompany hrm
               INNER JOIN @t b
                       ON hrm.supsubcomid = b.id
					   AND (hrm.canceled IS NULL 
			           OR  hrm.canceled!=1)
                          AND hrm.id NOT IN(SELECT id
                                            FROM   @t)

      RETURN
  END
go

CREATE FUNCTION F_split(@ids   VARCHAR(2000),@split VARCHAR(2))
returns @t_split TABLE(col INT)
AS
  BEGIN
      WHILE( Charindex(@split, @ids) <> 0 )
        BEGIN
            INSERT @t_split (col)
            VALUES(Substring(@ids, 1, Charindex(@split, @ids) - 1))
            SET @ids=Stuff(@ids, 1, Charindex(@split, @ids), '')
        END
      INSERT @t_split (col)
      VALUES(@ids)
      RETURN
  END
go


CREATE FUNCTION GetSubcpyIdsTreeWithSelf(@ids VARCHAR(500))
returns @t TABLE(
  id INT )
AS
  BEGIN
      INSERT @t
      SELECT id
      FROM   HrmSubCompany
      WHERE  id IN ( select * from f_split(@ids,',') )
             AND (canceled IS NULL 
			 OR  canceled!=1)
      WHILE @@rowcount > 0
	    INSERT @t
        SELECT hrm.id
        FROM   HrmSubCompany hrm,
               @t B
        WHERE  hrm.supsubcomid = B.id
		       AND (hrm.canceled IS NULL 
			   OR  hrm.canceled!=1)
               AND hrm.id NOT IN (SELECT id
                                  FROM   @t)

      RETURN
  END
go
 
CREATE FUNCTION GetDeptIdsTreeWithSelf(@ids VARCHAR(500))
returns @t TABLE(
  id INT )
AS
  BEGIN
      INSERT @t
      SELECT id
      FROM   HrmDepartment
      WHERE  id IN ( select * from f_split(@ids,',') )
	         AND (canceled IS NULL 
			 OR  canceled!=1)

      WHILE @@rowcount > 0
	    INSERT @t
        SELECT hrm.id
        FROM   HrmDepartment hrm,
               @t B
        WHERE  hrm.supdepid = B.id
		       AND (hrm.canceled IS NULL 
			   OR  hrm.canceled!=1)
               AND hrm.id NOT IN (SELECT id
                                  FROM   @t)

      RETURN
  END
go


create table TM_TaskView (
   id                   int                  identity,
   userid               int                  null,
   menutype             int                  null,
   listtype				int				null,
   status				int				null,
   viewdate             char(19)             null,
   taskid				int null,
   seltag				char(200) null,
   subuserid			int null,
   constraint PK_TM_TASKVIEW primary key (id)
)
go



IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID('GP_ScoreSetting')
                    AND type = 'U' )
DROP TABLE GP_ScoreSetting 
go

CREATE TABLE GP_ScoreSetting
    (
      id INT IDENTITY ,
      gardename VARCHAR(100) ,
      beginSymbol TINYINT ,
      beginscore DECIMAL(10, 2) ,
      endSymbol TINYINT ,
      endscore DECIMAL(10, 2) ,
      rank INT ,
      CONSTRAINT PK_GP_ScoreSetting PRIMARY KEY ( id )
    )

CREATE INDEX GP_ScoreSetting_Index_1 ON GP_ScoreSetting (
id ASC
)
GO

ALTER TABLE GP_BaseSetting ADD scoreSetting INT
go