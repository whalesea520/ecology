drop trigger MODE_CUSTOMSEARCHBUTTON_ID_TRI
/
create or replace trigger MODE_CUSTOMSEARCHBUTTON_ID_TRI 
before insert on mode_customSearchButton for each row 
begin select mode_customSearchButton_id.nextval into :new.id from dual; end;
/