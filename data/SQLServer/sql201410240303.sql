alter table wechat_platform add templateId VARCHAR(200)
go
alter table wechat_msg add sendUrl varchar(2000)
go

alter table wechat_band add latitude decimal(20,6)
go
alter table wechat_band add longitude decimal(20,6)
go


INSERT into wechat_action(msgtype,eventtype,classname,type) VALUES

('event','templatesendjobfinish','weaver.wechat.receive.TemplateSendJobAction','1')
go
INSERT into wechat_action(msgtype,eventtype,classname,type) VALUES

('event','location','weaver.wechat.receive.LocationAction','1')
go