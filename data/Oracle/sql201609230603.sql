CREATE TABLE FullSearch_CustomerSerDetail(
  id integer NOT NULL primary key,
  serviceID integer NOT NULL,
  label varchar(1000) NULL,
  subcompanyid integer NULL,
  departmentid integer NULL,
  jobId integer NULL,
  lastmoddate char(10) NULL,
  lastmodTime char(8) NULL
)
/
create sequence seq_fullSearch_CusSerDetail
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CustomerSerDetail_tri
before insert on FullSearch_CustomerSerDetail
for each row
begin
select seq_fullSearch_CusSerDetail.nextval into :new.id from dual;
end ;
/
CREATE TABLE FullSearch_FixedInst(
  id integer NOT NULL primary key,
  instructionName varchar(800) NOT NULL,
  instructionImgSrc varchar(800) NULL,
  showorder varchar(800) NULL,
  showExample varchar(800) NULL
  )
  
/
create sequence seq_fullSearch_FixedInst
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger FixedInst_tri
before insert on FullSearch_FixedInst
for each row
begin
select seq_fullSearch_FixedInst.nextval into :new.id from dual;
end ;
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('电话','','1','打电话给赵静')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('短信','','2','发短信给赵静')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('内部消息','','3','发消息给赵静')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('发起流程','','4','发起请假流程')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('建日程备忘','','5','提醒我下午开会')
/
insert into FullSearch_FixedInst (instructionName,instructionImgSrc,showorder,showExample) values ('考勤','','6','我要签到')
/
CREATE TABLE FullSearch_FixedInstShow(
  instructionId integer NOT NULL,
  showValue varchar(800) NULL
) 
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'打电话给赵静' from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'给赵静打电话' from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'帮我接通赵静的电话' from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'拨打赵静的电话' from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'呼叫赵静' from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'打赵静的电话' from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'打给赵静' from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发短信给赵静' from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'给赵静发短信' from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发短信给赵静，说我马上就到' from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发短信给赵静，内容是晚上7点见' from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'短信通知（告诉/告知）赵静，不要等我了' from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发消息给赵静' from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'给赵静发消息' from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发消息给赵静，说我稍后就到' from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发消息给赵静，内容是一个小时后见面谈' from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'用内部消息通知（告诉/告知）赵静，下午2点开会' from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发起请假流程' from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'我要建出差流程' from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'发起留言流程' from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'走个报销流程' from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'提醒我下午开会' from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'我要建日程' from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'我要写备忘' from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'给赵静建日程，明天上午参加部门会议' from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'提醒赵静下午有会要参加' from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'我要签到' from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'我要签退' from FullSearch_FixedInst where instructionName = '考勤'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'我要考勤' from FullSearch_FixedInst where instructionName = '考勤'
/
insert into FullSearch_FixedInstShow (instructionId,showValue) select id,'帮我签到' from FullSearch_FixedInst where instructionName = '考勤'
/