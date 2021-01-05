CREATE table sms_set(
  id int NOT NULL PRIMARY key,
  longSms char(1) DEFAULT 0,
  splitLength int DEFAULT 60,
  signPostion char(1) DEFAULT 1,
  username char(1)  DEFAULT 1,
  userid char(1)  DEFAULT 1,
  dept char(1) DEFAULT 0,
  subcomp char(1) DEFAULT 0,
  sign varchar(50) DEFAULT '',
  showReply char(1) DEFAULT 1
)
/
INSERT into sms_set(id,splitLength) values(1,70)
/


alter table sms_set add signPos char(1) DEFAULT ((0)) not null
/

