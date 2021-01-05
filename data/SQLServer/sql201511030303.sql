update meeting_remind_type set name='微信服务号提醒',label=126016 where id=5
GO

ALTER TABLE meetingset ADD createMeetingRemindChk INT, cancelMeetingRemindChk INT, reMeetingRemindChk INT
GO

update meeting_remind_mode set name='会议开始前提醒' where type='start'
GO
update meeting_remind_mode set name='会议结束前提醒' where type='end'
GO
insert into meeting_remind_template VALUES (2,'','','您有会议#[name]，于#[begindate] #[begintime]在#[address]召开,请注意准时参加','start')
GO
insert into meeting_remind_template VALUES (3,'','会议开始前提醒-#[name]','您有会议#[name]，于#[begindate] #[begintime]在#[address]召开,请注意准时参加','start')
GO
insert into meeting_remind_template VALUES (5,'','','您有会议#[name]，于#[begindate] #[begintime]在#[address]召开,请注意准时参加','start')
GO
insert into meeting_remind_template VALUES (2,'','','您参加的会议#[name]，将于#[enddate]#[endtime]结束，离开会场时请勿遗漏随身物品','end')
GO
insert into meeting_remind_template VALUES (3,'','会议结束前提醒-#[name]','您参加的会议#[name]，将于#[enddate]#[endtime]结束，离开会场时请勿遗漏随身物品','end')
GO
insert into meeting_remind_template VALUES (5,'','','您参加的会议#[name]，将于#[enddate]#[endtime]结束，离开会场时请勿遗漏随身物品','end')
GO