CREATE TABLE HistorySearch(
	id int primary key,
	userid varchar(50) NULL,
	searchtext varchar(255) NULL,
	searchdate varchar(10) NULL,
	searchtime varchar(8) NULL,
	searchtype int NULL
)
/

create sequence HistorySearch_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HistorySearch_id_Tri
before insert on HistorySearch
for each row
begin
select HistorySearch_id.nextval into :new.id from dual;
end;
/