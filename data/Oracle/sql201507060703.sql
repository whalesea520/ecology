alter table mode_customSearchButton add jsmethodbody2 varchar2(4000)
/
update mode_customSearchButton set jsmethodbody2=jsmethodbody
/
alter table mode_customSearchButton drop column jsmethodbody
/
alter table mode_customSearchButton rename column jsmethodbody2 to jsmethodbody
/