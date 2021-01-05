create or replace trigger sensitive_settings_id_TRIGGER
  before insert on sensitive_settings
  for each row
begin
  select sensitive_settings_id.nextval into :new.id from dual;
end;
/

create or replace trigger sensitive_words_id_TRIGGER
  before insert on sensitive_words
  for each row
begin
  select sensitive_words_id.nextval into :new.id from dual;
end;
/

create or replace trigger sensitive_logs_id_TRIGGER
  before insert on sensitive_logs
  for each row
begin
  select sensitive_logs_id.nextval into :new.id from dual;
end;
/