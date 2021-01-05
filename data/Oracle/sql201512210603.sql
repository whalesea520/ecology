CREATE TABLE social_IMMsgTag (
  id number primary key,
  msgid VARCHAR2(100),
  tag char(1),
  shareid number(11)
)
/
CREATE INDEX social_IMMsgTag_index ON social_IMMsgTag (msgid DESC) 
/
