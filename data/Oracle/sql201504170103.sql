create sequence HRMJOBTITLESTEMPLET_ID
minvalue 1
maxvalue 999999999999999999999999999
start with 21
increment by 1
cache 20
/
CREATE OR REPLACE TRIGGER hrmjobtitlestemplet_Trigger before insert on hrmjobtitlestemplet for each row begin select hrmjobtitlestemplet_id.nextval into :new.id from dual; end;
/