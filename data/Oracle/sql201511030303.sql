update meeting_remind_type set name='΢�ŷ��������',label=126016 where id=5
/

alter table meetingset ADD (createMeetingRemindChk INTEGER,cancelMeetingRemindChk INTEGER, reMeetingRemindChk INTEGER)
/


update meeting_remind_mode set name='���鿪ʼǰ����' where type='start'
/
update meeting_remind_mode set name='�������ǰ����' where type='end'
/
insert into meeting_remind_template (type,desc_n,title,body,modetype) VALUES (2,'','','���л���#[name]����#[begindate] #[begintime]��#[address]�ٿ�,��ע��׼ʱ�μ�','start')
/
insert into meeting_remind_template (type,desc_n,title,body,modetype) VALUES (3,'','���鿪ʼǰ����-#[name]','���л���#[name]����#[begindate] #[begintime]��#[address]�ٿ�,��ע��׼ʱ�μ�','start')
/
insert into meeting_remind_template (type,desc_n,title,body,modetype) VALUES (5,'','','���л���#[name]����#[begindate] #[begintime]��#[address]�ٿ�,��ע��׼ʱ�μ�','start')
/
insert into meeting_remind_template (type,desc_n,title,body,modetype) VALUES (2,'','','���μӵĻ���#[name]������#[enddate]#[endtime]�������뿪�᳡ʱ������©������Ʒ','end')
/
insert into meeting_remind_template (type,desc_n,title,body,modetype) VALUES (3,'','�������ǰ����-#[name]','���μӵĻ���#[name]������#[enddate]#[endtime]�������뿪�᳡ʱ������©������Ʒ','end')
/
insert into meeting_remind_template (type,desc_n,title,body,modetype) VALUES (5,'','','���μӵĻ���#[name]������#[enddate]#[endtime]�������뿪�᳡ʱ������©������Ʒ','end')
/