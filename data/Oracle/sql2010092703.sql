ALTER Table HrmResource ADD pinyinlastname varchar2(50)
/

UPDATE HrmResource set pinyinlastname = Lower(getPinYin(lastname))
/

create or replace trigger Tri_mobile_getpinyin
before insert on HrmResource
for each row
begin
select Lower(getPinYin(:new.lastname)) into :new.pinyinlastname from dual;
end;
/
