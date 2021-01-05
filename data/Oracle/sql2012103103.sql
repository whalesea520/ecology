create or replace trigger Tri_mobile_getpinyin
before insert or update on HrmResource
for each row
begin
select Lower(getPinYin(:new.lastname)) into :new.pinyinlastname from dual;
end;
/