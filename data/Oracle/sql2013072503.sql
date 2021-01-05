create table mode_searchPageshareinfo
(
  ID        INTEGER not null,
  pageid  INTEGER,
  RIGHTTYPE INTEGER,
  SHARETYPE INTEGER,
  RELATEDID INTEGER,
  ROLELEVEL INTEGER,
  SHOWLEVEL INTEGER
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64
    minextents 1
    maxextents unlimited
  )
/
