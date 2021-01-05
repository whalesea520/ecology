alter table wechat_platform add templateId VARCHAR(200)
/
alter table wechat_msg add sendUrl varchar(2000)
/

alter table wechat_band add latitude decimal(20,6)
/
alter table wechat_band add longitude decimal(20,6)
/


INSERT into wechat_action(msgtype,eventtype,classname,type) VALUES('event','templatesendjobfinish','weaver.wechat.receive.TemplateSendJobAction','1')
/
INSERT into wechat_action(msgtype,eventtype,classname,type) VALUES('event','location','weaver.wechat.receive.LocationAction','1')
/