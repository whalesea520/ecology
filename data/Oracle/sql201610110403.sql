alter table FullSearch_FixedInstShow add id integer
/
alter table FullSearch_FixedInstShow add dsporder integer
/
truncate table FullSearch_FixedInstShow 
/
create sequence seq_fullSearch_FixedInstShow
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger FixedInstShow_tri
before insert on FullSearch_FixedInstShow 
for each row
begin
select seq_fullSearch_FixedInstShow.nextval into :new.id from dual;
end ;
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'打电话给赵静',1 from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'给赵静打电话',2 from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'帮我接通赵静的电话',3 from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'拨打赵静的电话',4 from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'呼叫赵静',5 from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'打赵静的电话',6 from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'打给赵静',7 from FullSearch_FixedInst where instructionName = '电话'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发短信给赵静',1 from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'给赵静发短信',2 from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发短信给赵静，说我马上就到',3 from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发短信给赵静，内容是晚上7点见',4 from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'短信通知（告诉/告知）赵静，不要等我了',5 from FullSearch_FixedInst where instructionName = '短信'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发消息给赵静',1 from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'给赵静发消息',2 from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发消息给赵静，说我稍后就到',3 from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发消息给赵静，内容是一个小时后见面谈',4 from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'用内部消息通知（告诉/告知）赵静，下午2点开会',5 from FullSearch_FixedInst where instructionName = '内部消息'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发起请假流程',1 from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要建出差流程',2 from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'发起留言流程',3 from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'走个报销流程',4 from FullSearch_FixedInst where instructionName = '发起流程'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'提醒我下午开会',1 from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要建日程',2 from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要写备忘',3 from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'给赵静建日程，明天上午参加部门会议',4 from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'提醒赵静下午有会要参加',5 from FullSearch_FixedInst where instructionName = '建日程备忘'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要签到',1 from FullSearch_FixedInst where instructionName = '考勤'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要签退',2 from FullSearch_FixedInst where instructionName = '考勤'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'我要考勤',3 from FullSearch_FixedInst where instructionName = '考勤'
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'帮我签到',4 from FullSearch_FixedInst where instructionName = '考勤'
/