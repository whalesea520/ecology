create table mode_toolbar_search(
  id int primary key ,
  isUsedSearch  int,
  searchName varchar2(100) ,
  searchField varchar2(50),
  imageSource varchar2(20),
  imageId int,
  imageUrl varchar2(500),
  showOrder int,
  mainid  int,
  serachtype int
)
/
 
create sequence mode_toolbar_search_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger mode_toolbar_search_id_Tri
before insert on mode_toolbar_search
for each row
begin
select mode_toolbar_search_id.nextval into :new.id from dual;
end;
/