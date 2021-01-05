CREATE OR REPLACE  TRIGGER hrmjobtitles_getpinyin 
  before insert or update of jobtitlename on hrmjobtitles
  for each row 
  begin
  select Lower(getpinyin((:new.jobtitlename)))
    into :new.ecology_pinyin_search
    from dual;
end;
/
CREATE OR REPLACE  TRIGGER hrmjobtitlestemplet_getpinyin 
  before insert or update of jobtitlename on hrmjobtitlestemplet
  for each row 
  begin
  select Lower(getpinyin((:new.jobtitlename)))
    into :new.ecology_pinyin_search
    from dual;
end;
/
