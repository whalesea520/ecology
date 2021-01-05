update FullSearch_FixedInstShow set showValue = '用内部消息通知赵静，内容是下午2点开会' where instructionId = 3 and showValue = '用内部消息通知（告诉/告知）赵静，下午2点开会' 
/
insert into FullSearch_FixedInstShow (instructionId,showValue,dsporder) select id,'用内部消息告诉(告知)赵静，说下午2点开会',6 from FullSearch_FixedInst where instructionName = '内部消息'
/