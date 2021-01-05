drop sequence HRMARRANGESHIFTSET_ID
/
drop TRIGGER HrmArrangeShiftSet_Trigger
/
drop table HRMARRANGESHIFTSET
/
create table HRMARRANGESHIFTSET
(
  id               INTEGER not null,
  resourceid       INTEGER,
  arrangeshifttype INTEGER,
  relatedid        INTEGER,
  levelfrom        INTEGER,
  levelto          INTEGER
)
/
create sequence HRMARRANGESHIFTSET_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER HrmArrangeShiftSet_Trigger before insert on HrmArrangeShiftSet for each row begin select HrmArrangeShiftSet_id.nextval into :new.id from dual; end;
/