CREATE table sms_reminder_mode(
  modekey VARCHAR(50) PRIMARY key,
  modename VARCHAR(200) not null
)
/
CREATE table sms_reminder_type(
  type VARCHAR(50) PRIMARY key,
  typename VARCHAR(200) not null,
  modekey VARCHAR(50) not null
)
/
CREATE table sms_reminder_set(
  id int NOT NULL  PRIMARY key,
  prefix VARCHAR(200) null,
  prefixConnector VARCHAR(10) null,
  suffix VARCHAR(200) null,
  suffixConnector VARCHAR(10) null,
  type VARCHAR(100) not null,
  def char(1) not null
)
/
create sequence sms_reminder_set_id
minvalue 1
start with 1
increment by 1
/
create or replace trigger sms_reminder_set_tri
before insert on sms_reminder_set for each row
begin
select sms_reminder_set_id.nextval into :new.id from dual;
end;
/
INSERT into sms_reminder_set(prefix,type,def) VALUES((SELECT messageprefix FROM SystemSet),'ALL','1')
/
UPDATE sms_reminder_set set prefix=prefix+':' where prefix!='' and type='ALL' and def='1'
/