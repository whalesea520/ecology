update meeting_remind_type set name='΢�ŷ��������',label=126016 where id=5
GO

ALTER TABLE meetingset ADD createMeetingRemindChk INT, cancelMeetingRemindChk INT, reMeetingRemindChk INT
GO

update meeting_remind_mode set name='���鿪ʼǰ����' where type='start'
GO
update meeting_remind_mode set name='�������ǰ����' where type='end'
GO
insert into meeting_remind_template VALUES (2,'','','���л���#[name]����#[begindate] #[begintime]��#[address]�ٿ�,��ע��׼ʱ�μ�','start')
GO
insert into meeting_remind_template VALUES (3,'','���鿪ʼǰ����-#[name]','���л���#[name]����#[begindate] #[begintime]��#[address]�ٿ�,��ע��׼ʱ�μ�','start')
GO
insert into meeting_remind_template VALUES (5,'','','���л���#[name]����#[begindate] #[begintime]��#[address]�ٿ�,��ע��׼ʱ�μ�','start')
GO
insert into meeting_remind_template VALUES (2,'','','���μӵĻ���#[name]������#[enddate]#[endtime]�������뿪�᳡ʱ������©������Ʒ','end')
GO
insert into meeting_remind_template VALUES (3,'','�������ǰ����-#[name]','���μӵĻ���#[name]������#[enddate]#[endtime]�������뿪�᳡ʱ������©������Ʒ','end')
GO
insert into meeting_remind_template VALUES (5,'','','���μӵĻ���#[name]������#[enddate]#[endtime]�������뿪�᳡ʱ������©������Ʒ','end')
GO