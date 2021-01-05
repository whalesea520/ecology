create table FullSearch_SearchSet(
id int PRIMARY key ,
userid int ,
searchField int,
sortField int
)
/
create sequence FS_SearchSet_ID
minvalue 1
increment by 1
/

create or replace trigger FS_SearchSet_TR
 before insert on FullSearch_SearchSet for each row 
begin select FS_SearchSet_ID.nextval into :new.id from dual; 
end;
/