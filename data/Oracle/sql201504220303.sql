create or replace trigger Tri_mobile_getpinyin
  before insert or update of lastname on HrmResource
  for each row
begin
  if (:old.lastname!=:new.lastname or :old.lastname is null) then
  select Lower(getPinYin(:new.lastname)) into :new.pinyinlastname from dual;
  end if;
end;
/
update hrmresource set pinyinlastname = ecology_pinyin_search
/