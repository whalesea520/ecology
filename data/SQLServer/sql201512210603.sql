create table social_IMMsgTag (
  id int IDENTITY,
  msgid VARCHAR(100),
  tag char(1),
  shareid int
)
GO
CREATE INDEX social_IMMsgTag_index ON social_IMMsgTag (msgid DESC) 
GO
