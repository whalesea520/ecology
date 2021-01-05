Drop table hrm_fieldgroup
/
Drop sequence hrm_fieldgroup_id
/
create table hrm_fieldgroup (
   id                   int             not null,
   grouplabel           int                  null,
   grouporder           int                  null,
   grouptype            int                  null
)
/
create sequence hrm_fieldgroup_id
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER hrm_fieldgroup_Trigger before insert on hrm_fieldgroup for each row begin select hrm_fieldgroup_id.nextval into :new.id from dual; end;
/
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(1361,1,-1)
/
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(32938,2,-1)
/
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(32946,3,-1)
/
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(15687,1,1)
/
INSERT INTO hrm_fieldgroup (grouplabel, grouporder, grouptype)
VALUES(15688,1,3)
/
INSERT INTO hrm_fieldgroup ( grouplabel, grouporder, grouptype ) 
VALUES  ( 1361, 1, 4)
/
INSERT INTO hrm_fieldgroup ( grouplabel, grouporder, grouptype ) 
VALUES  ( 1361, 1, 5)
/