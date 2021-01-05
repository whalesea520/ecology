drop table HRMJOBTITLESTEMPLET
/
create table HRMJOBTITLESTEMPLET
(
  id                INTEGER  not null primary key,
  jobtitlemark          VARCHAR2(60),
  jobtitlename          VARCHAR2(200),
  jobtitleremark        VARCHAR2(4000),
  jobactivityid         INTEGER,
  jobresponsibility     VARCHAR2(200),
  jobcompetency         VARCHAR2(200),
  jobdoc                INTEGER,
  jobtitlecode          VARCHAR2(60),
  outkey                VARCHAR2(100),
  ecology_pinyin_search VARCHAR2(300)
)
/
drop sequence HRMJOBTITLESTEMPLET_ID
/
create sequence HRMJOBTITLESTEMPLET_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER hrmjobtitlestemplet_Trigger before insert on hrmjobtitlestemplet for each row begin select hrmjobtitlestemplet_id.nextval into :new.id from dual; end;
/
insert into HRMJOBTITLESTEMPLET (jobtitlemark,jobtitlename,jobtitleremark,jobactivityid,jobresponsibility,jobcompetency,jobdoc,jobtitlecode,outkey,ecology_pinyin_search)select jobtitlemark,jobtitlename,jobtitleremark,jobactivityid,jobresponsibility,jobcompetency,jobdoc,jobtitlecode,outkey,ecology_pinyin_search from HrmJobTitles
/
